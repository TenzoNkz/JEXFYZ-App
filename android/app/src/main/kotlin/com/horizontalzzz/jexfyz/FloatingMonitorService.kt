package com.horizontalzzz.jexfyz

// Native Floating Monitor overlay.
// The overlay owns only its window and visual presentation. BLE/GATT remains
// entirely in flutter_blue_plus; telemetry arrives from MainActivity.

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.Service
import android.content.Context
import android.content.Intent
import android.graphics.Canvas
import android.graphics.Color
import android.graphics.Paint
import android.graphics.Path
import android.graphics.PixelFormat
import android.os.Build
import android.os.IBinder
import android.provider.Settings
import android.view.Gravity
import android.view.MotionEvent
import android.view.ScaleGestureDetector
import android.view.WindowManager
import org.json.JSONArray
import org.json.JSONObject
import kotlin.math.abs
import kotlin.math.ceil
import kotlin.math.max
import kotlin.math.min
import kotlin.math.roundToInt

class FloatingMonitorService : Service() {

    companion object {
        private const val CHANNEL_ID = "je_x_fyz_floating"
        private const val NOTIFICATION_ID = 2301
        private const val ACTION_START = "je_x_fyz.floating.START"
        private const val ACTION_STOP = "je_x_fyz.floating.STOP"
        private const val ACTION_CONFIG = "je_x_fyz.floating.CONFIG"
        private const val ACTION_DATA = "je_x_fyz.floating.DATA"
        private const val EXTRA_JSON = "json"

        @Volatile
        private var instance: FloatingMonitorService? = null

        fun start(context: Context, json: String): Boolean {
            if (!Settings.canDrawOverlays(context)) return false
            val intent = Intent(context, FloatingMonitorService::class.java).apply {
                action = ACTION_START
                putExtra(EXTRA_JSON, json)
            }
            return try {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                    context.startForegroundService(intent)
                } else {
                    context.startService(intent)
                }
                true
            } catch (_: Exception) {
                false
            }
        }

        fun stop(context: Context) {
            try {
                context.stopService(Intent(context, FloatingMonitorService::class.java))
            } catch (_: Exception) {
            }
        }

        fun updateConfig(context: Context, json: String) {
            instance?.applyConfig(json) ?: run {
                context.startService(Intent(context, FloatingMonitorService::class.java).apply {
                    action = ACTION_CONFIG
                    putExtra(EXTRA_JSON, json)
                })
            }
        }

        fun updateData(context: Context, json: String) {
            instance?.applyData(json) ?: run {
                context.startService(Intent(context, FloatingMonitorService::class.java).apply {
                    action = ACTION_DATA
                    putExtra(EXTRA_JSON, json)
                })
            }
        }
    }

    private data class Config(
        var enabled: Boolean = false,
        var style: String = "letters",
        var order: MutableList<String> = mutableListOf("F", "B", "H", "V", "A", "P", "S"),
        var selected: MutableSet<String> = mutableSetOf(),
        var size: Float = 1.0f,
        var opacity: Float = 0.9f,
        var horizontal: Boolean = true,
    )

    private data class Data(
        var fps: String = "--",
        var battery: String = "--",
        var hotside: String = "--",
        var voltage: String = "--",
        var fanOn: Boolean = false,
        var speed: Int = 100,
        var adaptiveOn: Boolean = false,
        var peltierOn: Boolean = false,
    )

    private lateinit var windowManager: WindowManager
    private var hudView: FloatingHudView? = null
    private lateinit var layoutParams: WindowManager.LayoutParams
    private var config = Config()
    private var data = Data()
    private val prefs by lazy { getSharedPreferences("jexfyz_floating_native_v1", Context.MODE_PRIVATE) }

    override fun onCreate() {
        super.onCreate()
        instance = this
        windowManager = getSystemService(WINDOW_SERVICE) as WindowManager
        createNotificationChannel()
        startForeground(NOTIFICATION_ID, buildNotification())
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        when (intent?.action) {
            ACTION_START -> {
                val json = intent.getStringExtra(EXTRA_JSON)
                if (json != null) applyConfig(json)
                ensureOverlay()
            }
            ACTION_STOP -> removeOverlay()
            ACTION_CONFIG -> intent.getStringExtra(EXTRA_JSON)?.let { applyConfig(it) }
            ACTION_DATA -> intent.getStringExtra(EXTRA_JSON)?.let { applyData(it) }
        }
        return START_NOT_STICKY
    }

    override fun onDestroy() {
        removeOverlay()
        instance = null
        super.onDestroy()
    }

    override fun onBind(intent: Intent?): IBinder? = null

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) return
        val manager = getSystemService(NotificationManager::class.java)
        val channel = NotificationChannel(
            CHANNEL_ID,
            "JE X FYZ Floating Monitor",
            NotificationManager.IMPORTANCE_LOW,
        ).apply {
            description = "Keeps the JE X FYZ Floating Monitor active."
            setShowBadge(false)
            setSound(null, null)
            enableVibration(false)
        }
        manager.createNotificationChannel(channel)
    }

    private fun buildNotification(): Notification {
        val builder = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            Notification.Builder(this, CHANNEL_ID)
        } else {
            @Suppress("DEPRECATION")
            Notification.Builder(this)
        }
        return builder
            .setSmallIcon(R.drawable.jexfyzicon)
            .setContentTitle("JE X FYZ")
            .setContentText("Floating Monitor active")
            .setOngoing(true)
            .setShowWhen(false)
            .setPriority(Notification.PRIORITY_LOW)
            .build()
    }

    private fun applyConfig(json: String) {
        try {
            val obj = JSONObject(json)
            config.enabled = obj.optBoolean("enabled", false)
            config.style = obj.optString("style", "letters")
            config.size = obj.optDouble("size", 1.0).toFloat().coerceIn(0.65f, 1.8f)
            config.opacity = obj.optDouble("opacity", 0.9).toFloat().coerceIn(0.35f, 1.0f)
            config.horizontal = obj.optBoolean("horizontal", true)

            val parsedOrder = mutableListOf<String>()
            val order = obj.optJSONArray("order")
            if (order != null) {
                for (i in 0 until order.length()) {
                    val value = order.optString(i)
                    if (value in listOf("F", "B", "H", "V", "A", "P", "S") && !parsedOrder.contains(value)) {
                        parsedOrder.add(value)
                    }
                }
            }
            for (metric in listOf("F", "B", "H", "V", "A", "P", "S")) {
                if (!parsedOrder.contains(metric)) parsedOrder.add(metric)
            }
            config.order = parsedOrder

            val selected = mutableSetOf<String>()
            val selectedArray = obj.optJSONArray("selected")
            if (selectedArray != null) {
                for (i in 0 until selectedArray.length()) {
                    val value = selectedArray.optString(i)
                    if (value in listOf("F", "B", "H", "V", "A", "P", "S")) selected.add(value)
                }
            }
            config.selected = selected
            persistNativePositionAndSize()
            if (config.enabled) {
                ensureOverlay()
                hudView?.invalidate()
                hudView?.requestLayout()
            } else {
                removeOverlay()
            }
        } catch (_: Exception) {
        }
    }

    private fun applyData(json: String) {
        try {
            val obj = JSONObject(json)
            data.fps = obj.optString("fps", "--")
            data.battery = obj.optString("battery", "--")
            data.hotside = obj.optString("hotside", "--")
            data.voltage = obj.optString("voltage", "--")
            data.fanOn = obj.optBoolean("fanOn", false)
            data.speed = obj.optInt("speed", 100)
            data.adaptiveOn = obj.optBoolean("adaptiveOn", false) && data.fanOn
            data.peltierOn = obj.optBoolean("peltierOn", false) && data.fanOn
            if (config.enabled) {
                hudView?.invalidate()
            }
        } catch (_: Exception) {
        }
    }

    private fun persistNativePositionAndSize() {
        if (::layoutParams.isInitialized) {
            prefs.edit()
                .putInt("x", layoutParams.x)
                .putInt("y", layoutParams.y)
                .putFloat("size", config.size)
                .putBoolean("horizontal", config.horizontal)
                .apply()
        } else {
            prefs.edit().putFloat("size", config.size).apply()
        }
    }

    private fun ensureOverlay() {
        if (!config.enabled || !Settings.canDrawOverlays(this)) return

        if (hudView == null) {
            hudView = FloatingHudView(this)
            val type = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                android.view.WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY
            } else {
                @Suppress("DEPRECATION")
                android.view.WindowManager.LayoutParams.TYPE_PHONE
            }

            layoutParams = WindowManager.LayoutParams(
                WindowManager.LayoutParams.WRAP_CONTENT,
                WindowManager.LayoutParams.WRAP_CONTENT,
                type,
                WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE or
                    WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL,
                PixelFormat.TRANSLUCENT,
            ).apply {
                gravity = Gravity.TOP or Gravity.START
                x = prefs.getInt("x", 16)
                y = prefs.getInt("y", 120)
            }

            try {
                windowManager.addView(hudView, layoutParams)
            } catch (_: Exception) {
                hudView = null
            }
        } else {
            hudView?.requestLayout()
            hudView?.invalidate()
        }
    }

    private fun removeOverlay() {
        val view = hudView ?: return
        try {
            windowManager.removeView(view)
        } catch (_: Exception) {
        }
        hudView = null
    }

    private fun rotateOrientation() {
        config.horizontal = !config.horizontal
        persistNativePositionAndSize()
        hudView?.requestLayout()
        hudView?.invalidate()
    }

    private fun resizeOverlay(newSize: Float) {
        config.size = newSize.coerceIn(0.65f, 1.8f)
        prefs.edit().putFloat("size", config.size).apply()
        hudView?.requestLayout()
        hudView?.invalidate()
        try {
            if (hudView != null) windowManager.updateViewLayout(hudView, layoutParams)
        } catch (_: Exception) {
        }
    }

    private inner class FloatingHudView(context: Context) : android.view.View(context) {
        private val textPaint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
            color = Color.WHITE
            typeface = android.graphics.Typeface.create("sans", android.graphics.Typeface.BOLD)
        }
        private val iconPaint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
            color = Color.WHITE
            style = Paint.Style.STROKE
            strokeWidth = dp(1.7f)
            strokeCap = Paint.Cap.ROUND
            strokeJoin = Paint.Join.ROUND
        }
        private val fillPaint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
            color = Color.WHITE
            style = Paint.Style.FILL
        }
        private val bgPaint = Paint(Paint.ANTI_ALIAS_FLAG)
        private val scaleDetector = ScaleGestureDetector(context, object : ScaleGestureDetector.SimpleOnScaleGestureListener() {
            override fun onScaleBegin(detector: ScaleGestureDetector): Boolean {
                baseSizeAtScaleStart = config.size
                scaleGestureActive = true
                return true
            }

            override fun onScale(detector: ScaleGestureDetector): Boolean {
                resizeOverlay(baseSizeAtScaleStart * detector.scaleFactor)
                return true
            }
        })

        private var downRawX = 0f
        private var downRawY = 0f
        private var downX = 0
        private var downY = 0
        private var moved = false
        private var baseSizeAtScaleStart = 1f
        private var scaleGestureActive = false
        private var density = resources.displayMetrics.density

        private val visibleMetrics: List<String>
            get() = config.order.filter {
                config.selected.contains(it) && (it != "S" || data.fanOn)
            }

        init {
            setBackgroundColor(Color.TRANSPARENT)
            isClickable = true
        }

        private fun dp(value: Float): Float = value * density

        override fun onMeasure(widthMeasureSpec: Int, heightMeasureSpec: Int) {
            val size = config.size
            val textSize = dp(11.5f * size)
            textPaint.textSize = textSize
            val horizontal = config.horizontal
            val metrics = visibleMetrics
            val gap = dp(8f * size)
            val padX = dp(11f * size)
            val padY = dp(7f * size)

            var width = padX * 2
            var height = padY * 2

            if (metrics.isEmpty()) {
                width += dp(20f * size)
                height += dp(12f * size)
            } else if (horizontal) {
                width += metrics.sumOf { itemWidth(it) } + gap * (metrics.size - 1)
                height += max(dp(28f * size), metrics.maxOf { itemHeight(it) })
            } else {
                width += metrics.maxOf { itemWidth(it) }
                height += metrics.sumOf { itemHeight(it) } + gap * (metrics.size - 1)
            }

            setMeasuredDimension(ceil(width).toInt(), ceil(height).toInt())
        }

        private fun itemText(metric: String): String {
            return when (metric) {
                "F" -> "F:" + data.fps
                "B" -> "B:" + if (data.battery == "--") "--" else data.battery + "°"
                "H" -> "H:" + if (data.hotside == "--") "--" else data.hotside + "°"
                "V" -> "V:" + data.voltage
                "A" -> "A:" + if (data.fanOn && data.adaptiveOn) "ON" else "OFF"
                "P" -> "P:" + if (data.fanOn && data.peltierOn) "ON" else "OFF"
                "S" -> "S:" + if (data.fanOn) data.speed.toString() else "OFF"
                else -> ""
            }
        }

        private fun itemWidth(metric: String): Float {
            if (config.style == "icons") {
                return dp(21f * config.size) + dp(4f * config.size) + textPaint.measureText(itemText(metric))
            }
            return textPaint.measureText(itemText(metric))
        }

        private fun itemHeight(metric: String): Float {
            return max(dp(18f * config.size), textPaint.textSize)
        }

        override fun onDraw(canvas: Canvas) {
            super.onDraw(canvas)
            val scale = config.size
            val radius = dp(16f * scale)
            bgPaint.color = Color.argb(
                (config.opacity.coerceIn(0.0f, 1.0f) * 225f).roundToInt(),
                10, 10, 12,
            )
            canvas.drawRoundRect(
                0f,
                0f,
                width.toFloat(),
                height.toFloat(),
                radius,
                radius,
                bgPaint,
            )

            val metrics = visibleMetrics
            val padX = dp(11f * scale)
            val padY = dp(7f * scale)
            val gap = dp(8f * scale)
            var cursor = if (config.horizontal) padX else padY

            for (metric in metrics) {
                val itemH = itemHeight(metric)
                if (config.horizontal) {
                    drawMetric(canvas, metric, cursor, padY + itemH * 0.72f, scale)
                    cursor += itemWidth(metric) + gap
                } else {
                    drawMetric(canvas, metric, padX, cursor + itemH * 0.72f, scale)
                    cursor += itemH + gap
                }
            }
        }

        private fun drawMetric(canvas: Canvas, metric: String, x: Float, baseline: Float, scale: Float) {
            val value = itemText(metric)
            if (config.style != "icons") {
                canvas.drawText(value, x, baseline, textPaint)
                return
            }

            drawIcon(canvas, metric, x + dp(10.5f * scale), baseline - dp(6f * scale), scale)
            canvas.drawText(
                value.substringAfter(':'),
                x + dp(21f * scale),
                baseline,
                textPaint,
            )
        }

        private fun drawIcon(canvas: Canvas, metric: String, cx: Float, cy: Float, scale: Float) {
            val s = dp(scale)
            iconPaint.strokeWidth = dp(1.55f * scale)
            when (metric) {
                "F" -> {
                    canvas.drawCircle(cx, cy, dp(7f * scale), iconPaint)
                    canvas.drawLine(cx, cy, cx + dp(4f * scale), cy - dp(4f * scale), iconPaint)
                    canvas.drawLine(cx - dp(5f * scale), cy + dp(5f * scale), cx + dp(5f * scale), cy + dp(5f * scale), iconPaint)
                }
                "B" -> {
                    canvas.drawRoundRect(cx - dp(6f * scale), cy - dp(7f * scale), cx + dp(6f * scale), cy + dp(7f * scale), dp(2f * scale), dp(2f * scale), iconPaint)
                    canvas.drawRect(cx + dp(6f * scale), cy - dp(3f * scale), cx + dp(8f * scale), cy + dp(3f * scale), iconPaint)
                    canvas.drawRect(cx - dp(4f * scale), cy - dp(4f * scale), cx, cy + dp(4f * scale), fillPaint)
                }
                "H" -> {
                    canvas.drawLine(cx, cy - dp(7f * scale), cx, cy + dp(2f * scale), iconPaint)
                    canvas.drawCircle(cx, cy + dp(5f * scale), dp(4f * scale), iconPaint)
                }
                "V" -> {
                    val p = Path().apply {
                        moveTo(cx + dp(2f * scale), cy - dp(8f * scale))
                        lineTo(cx - dp(3f * scale), cy + dp(1f * scale))
                        lineTo(cx + dp(1f * scale), cy + dp(1f * scale))
                        lineTo(cx - dp(2f * scale), cy + dp(8f * scale))
                        lineTo(cx + dp(5f * scale), cy - dp(2f * scale))
                        lineTo(cx + dp(1f * scale), cy - dp(2f * scale))
                        close()
                    }
                    canvas.drawPath(p, fillPaint)
                }
                "A" -> {
                    canvas.drawCircle(cx, cy, dp(6f * scale), iconPaint)
                    canvas.drawLine(cx, cy, cx + dp(4f * scale), cy - dp(4f * scale), iconPaint)
                    canvas.drawLine(cx - dp(1f * scale), cy - dp(9f * scale), cx - dp(1f * scale), cy - dp(6f * scale), iconPaint)
                    canvas.drawLine(cx + dp(6f * scale), cy - dp(1f * scale), cx + dp(9f * scale), cy - dp(1f * scale), iconPaint)
                }
                "P" -> {
                    for (angle in 0 until 360 step 60) {
                        val rad = Math.toRadians(angle.toDouble())
                        canvas.drawLine(
                            cx + kotlin.math.cos(rad).toFloat() * dp(2f * scale),
                            cy + kotlin.math.sin(rad).toFloat() * dp(2f * scale),
                            cx + kotlin.math.cos(rad).toFloat() * dp(7f * scale),
                            cy + kotlin.math.sin(rad).toFloat() * dp(7f * scale),
                            iconPaint,
                        )
                    }
                    canvas.drawCircle(cx, cy, dp(2f * scale), iconPaint)
                }
                "S" -> {
                    for (angle in 0 until 360 step 120) {
                        val rad = Math.toRadians(angle.toDouble())
                        val p = Path().apply {
                            moveTo(cx, cy)
                            lineTo(
                                cx + kotlin.math.cos(rad).toFloat() * dp(7f * scale),
                                cy + kotlin.math.sin(rad).toFloat() * dp(7f * scale),
                            )
                        }
                        canvas.drawPath(p, iconPaint)
                    }
                    canvas.drawCircle(cx, cy, dp(2.5f * scale), iconPaint)
                }
            }
        }

        override fun onTouchEvent(event: MotionEvent): Boolean {
            scaleDetector.onTouchEvent(event)
            when (event.actionMasked) {
                MotionEvent.ACTION_DOWN -> {
                    downRawX = event.rawX
                    downRawY = event.rawY
                    downX = layoutParams.x
                    downY = layoutParams.y
                    moved = false
                    scaleGestureActive = false
                    return true
                }
                MotionEvent.ACTION_POINTER_DOWN -> return true
                MotionEvent.ACTION_MOVE -> {
                    if (scaleDetector.isInProgress) {
                        scaleGestureActive = true
                        return true
                    }
                    if (event.pointerCount == 1) {
                        val dx = event.rawX - downRawX
                        val dy = event.rawY - downRawY
                        if (abs(dx) > dp(4f) || abs(dy) > dp(4f)) moved = true
                        layoutParams.x = downX + dx.roundToInt()
                        layoutParams.y = downY + dy.roundToInt()
                        try {
                            windowManager.updateViewLayout(this, layoutParams)
                        } catch (_: Exception) {
                        }
                    }
                    return true
                }
                MotionEvent.ACTION_UP -> {
                    if (!scaleGestureActive && !moved) {
                        rotateOrientation()
                    }
                    persistNativePositionAndSize()
                    return true
                }
                MotionEvent.ACTION_CANCEL -> {
                    persistNativePositionAndSize()
                    return true
                }
            }
            return true
        }
    }
}
