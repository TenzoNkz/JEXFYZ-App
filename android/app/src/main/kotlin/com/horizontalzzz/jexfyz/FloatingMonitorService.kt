package com.horizontalzzz.jexfyz

// AI-MEMORY / FILE CONTRACT
// File: FloatingMonitorService.kt
// Owns: native Floating Monitor foreground service, WindowManager overlay lifetime,
//       native overlay rendering, drag/resize/orientation gestures, and runtime diagnostics.
// Permission authority: Settings.canDrawOverlays() is the public Android SYSTEM_ALERT_WINDOW gate.
// Window authority: WindowManager.addView()/removeView() determine actual attachment.
// Localization: Flutter sends the selected AppLanguage with telemetry. English status = ON/OFF;
// Indonesia status = HIDUP/MATI. The metric identifiers F/B/H/V/A/P/S stay unchanged.
// Fan Speed invariant: metric S remains rendered; when Fan telemetry is OFF, S reports localized OFF/MATI.
// Do not create a BLE/GATT client here; telemetry is supplied by MainActivity/Flutter.
// Do not add vendor-specific hidden APIs as a default compatibility mechanism.

// Native Floating Monitor overlay.
// The overlay owns only its window and visual presentation. BLE/GATT remains
// entirely in flutter_blue_plus; telemetry arrives from MainActivity.

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.Service
import android.content.Context
import android.content.Intent
import android.content.ComponentName
import android.content.ServiceConnection
import android.content.pm.PackageManager
import android.content.pm.ServiceInfo
import android.graphics.Canvas
import android.graphics.Color
import android.graphics.Paint
import android.graphics.Path
import android.graphics.PixelFormat
import android.os.Build
import android.os.Handler
import android.os.IBinder
import android.os.Looper
import android.os.RemoteException
import rikka.shizuku.Shizuku
import android.os.SystemClock
import android.provider.Settings
import android.view.Gravity
import android.view.MotionEvent
import android.view.ScaleGestureDetector
import android.view.WindowManager
import org.json.JSONArray
import org.json.JSONObject
import java.util.concurrent.Executors
import java.util.concurrent.ScheduledFuture
import java.util.concurrent.TimeUnit
import kotlin.math.abs
import kotlin.math.ceil
import kotlin.math.max
import kotlin.math.min
import kotlin.math.roundToInt

private data class ShizukuFpsAccessSnapshot(
    val available: Boolean,
    val supported: Boolean,
    val granted: Boolean,
    val uid: Int,
) {
    fun toStatusMap(monitorStatus: String, monitorActive: Boolean): Map<String, Any?> {
        val status = when {
            !available -> "shizuku_not_running"
            !supported -> "shizuku_unsupported"
            !granted -> "shizuku_permission_missing"
            else -> monitorStatus
        }
        return mapOf(
            "fps_permission_granted" to granted,
            "shizuku_available" to available,
            "shizuku_supported" to supported,
            "shizuku_permission_granted" to granted,
            "shizuku_uid" to uid,
            "fps_monitor_active" to (monitorActive && granted),
            "fps_monitor_status" to status,
        )
    }
}

private fun shizukuFpsAccessSnapshot(): ShizukuFpsAccessSnapshot {
    val available = runCatching { Shizuku.pingBinder() }.getOrDefault(false)
    if (!available) return ShizukuFpsAccessSnapshot(false, false, false, -1)
    val supported = runCatching { Shizuku.getVersion() >= 10 }.getOrDefault(false)
    if (!supported) return ShizukuFpsAccessSnapshot(true, false, false, -1)
    val granted = runCatching { Shizuku.checkSelfPermission() == PackageManager.PERMISSION_GRANTED }.getOrDefault(false)
    val uid = if (granted) runCatching { Shizuku.getUid() }.getOrDefault(-1) else -1
    return ShizukuFpsAccessSnapshot(true, true, granted, uid)
}

class FloatingMonitorService : Service() {

    private data class DumpsysResult(
        val output: String,
        val ok: Boolean,
        val error: String? = null,
    )

    private data class LayerFrameCount(
        val name: String,
        val totalFrames: Long,
    )

    private fun hasShizukuFpsPermission(): Boolean = shizukuFpsAccessSnapshot().let {
        it.available && it.supported && it.granted
    }

    private fun fpsAccessStateMap(): Map<String, Any?> =
        shizukuFpsAccessSnapshot().toStatusMap(fpsMonitorStatus, fpsMonitorStatus == "active")

    // AI-METHOD / FPS-SAMPLER-ELIGIBILITY
    // Never poll global frame statistics unless the visible overlay is attached and F is selected.
    private fun refreshFpsMonitor() {
        val shouldRun = config.enabled &&
            config.selected.contains("F") &&
            hudView?.isAttachedToWindow == true

        if (!shouldRun) {
            stopFpsMonitor("monitor_off")
            return
        }
        val access = shizukuFpsAccessSnapshot()
        if (!access.available) {
            stopFpsMonitor("shizuku_not_running")
            return
        }
        if (!access.supported) {
            stopFpsMonitor("shizuku_unsupported")
            return
        }
        if (!access.granted) {
            stopFpsMonitor("shizuku_permission_missing")
            return
        }
        if (fpsMonitorWanted && fpsMonitorStatus in setOf("starting", "active")) return

        fpsMonitorWanted = true
        val generation = ++fpsGeneration
        fpsMonitorStatus = "starting"
        data.fps = "--"
        hudView?.requestLayout()
        hudView?.invalidate()

        fpsExecutor.execute {
            val start = runDumpsys("SurfaceFlinger", "--timestats", "-clear", "-enable")
            if (!start.ok) {
                fpsCaptureEnabled = false
                fpsMainHandler.post {
                    if (generation != fpsGeneration) return@post
                    fpsMonitorWanted = false
                    fpsMonitorStatus = start.error ?: "surfaceflinger_blocked"
                    data.fps = "--"
                    hudView?.requestLayout()
                    hudView?.invalidate()
                }
                return@execute
            }

            if (!fpsMonitorWanted || generation != fpsGeneration) {
                runDumpsys("SurfaceFlinger", "--timestats", "-disable")
                return@execute
            }

            fpsCaptureEnabled = true
            fpsFrameCounts.clear()
            fpsLastSampleAtMs = 0L
            fpsTrackedLayer = null
            fpsLastPositiveLayer = null
            fpsTrackedPackage = null
            fpsMainHandler.post {
                if (generation != fpsGeneration) return@post
                // Capture is enabled, but no valid FPS sample exists until the sampler
                // observes at least two compatible frame-counter snapshots.
                fpsMonitorStatus = "starting"
                data.fps = "--"
                hudView?.requestLayout()
                hudView?.invalidate()
            }
            fpsPollingTask = fpsExecutor.scheduleWithFixedDelay(
                { pollSurfaceFlinger(generation) },
                1,
                1,
                TimeUnit.SECONDS,
            )
        }
    }

    // AI-METHOD / FPS-SAMPLER-STOP
    // Clear stale readings and disable the global SurfaceFlinger collector on an orderly stop.
    private fun stopFpsMonitor(reason: String) {
        val wasWanted = fpsMonitorWanted
        val shouldDisable = fpsCaptureEnabled
        if (!wasWanted && !shouldDisable && fpsMonitorStatus == reason) {
            data.fps = "--"
            hudView?.requestLayout()
            hudView?.invalidate()
            return
        }

        fpsMonitorWanted = false
        fpsGeneration += 1
        fpsPollingTask?.cancel(false)
        fpsPollingTask = null
        fpsMonitorStatus = reason
        data.fps = "--"
        fpsTrackedPackage = null
        fpsTrackedLayer = null
        fpsLastPositiveLayer = null
        hudView?.requestLayout()
        hudView?.invalidate()

        if (shouldDisable) {
            fpsCaptureEnabled = false
            if (hasShizukuFpsPermission()) {
                fpsExecutor.execute { runDumpsys("SurfaceFlinger", "--timestats", "-disable") }
            } else {
                fpsExecutor.execute { releaseFpsUserService() }
            }
        } else if (reason == "shizuku_not_running" ||
            reason == "shizuku_unsupported" ||
            reason == "shizuku_permission_missing"
        ) {
            fpsExecutor.execute { releaseFpsUserService() }
        }
    }

    // FPS UserService binding. Only a fixed set of read-only FPS operations cross Binder.
    private val fpsUserServiceLock = Any()
    @Volatile private var fpsUserService: IFpsShizukuUserService? = null
    @Volatile private var fpsUserServiceBindingRequested = false

    private val fpsUserServiceArgs by lazy {
        Shizuku.UserServiceArgs(ComponentName(this, FpsShizukuUserService::class.java))
            .daemon(false)
            .processNameSuffix("fps")
            .debuggable(false)
            .version(BuildConfig.VERSION_CODE)
    }

    private val fpsUserServiceConnection = object : ServiceConnection {
        override fun onServiceConnected(name: ComponentName, service: IBinder) {
            synchronized(fpsUserServiceLock) {
                fpsUserService = IFpsShizukuUserService.Stub.asInterface(service)
                fpsUserServiceBindingRequested = true
            }
        }
        override fun onServiceDisconnected(name: ComponentName) {
            resetFpsUserServiceBinding()
            fpsMainHandler.post {
                if (fpsMonitorWanted) stopFpsMonitor("shizuku_userservice_disconnected")
            }
        }
    }

    private fun acquireFpsUserService(): IFpsShizukuUserService? {
        if (!hasShizukuFpsPermission()) return null
        var shouldBind = false
        synchronized(fpsUserServiceLock) {
            val existing = fpsUserService
            if (existing != null && runCatching { existing.asBinder().isBinderAlive }.getOrDefault(false)) return existing
            if (!fpsUserServiceBindingRequested) {
                fpsUserServiceBindingRequested = true
                shouldBind = true
            }
        }
        if (shouldBind) {
            try {
                Shizuku.bindUserService(fpsUserServiceArgs, fpsUserServiceConnection)
            } catch (_: Exception) {
                synchronized(fpsUserServiceLock) { fpsUserServiceBindingRequested = false }
                return null
            }
        }
        val deadline = SystemClock.elapsedRealtime() + 6000L
        while (SystemClock.elapsedRealtime() < deadline && hasShizukuFpsPermission()) {
            val remote = synchronized(fpsUserServiceLock) { fpsUserService }
            if (remote != null && runCatching { remote.asBinder().isBinderAlive }.getOrDefault(false)) return remote
            try {
                Thread.sleep(35)
            } catch (_: InterruptedException) {
                Thread.currentThread().interrupt()
                return null
            }
        }
        releaseFpsUserService()
        return null
    }

    private fun resetFpsUserServiceBinding() {
        synchronized(fpsUserServiceLock) {
            fpsUserService = null
            fpsUserServiceBindingRequested = false
        }
    }

    private fun releaseFpsUserService() {
        val shouldUnbind = synchronized(fpsUserServiceLock) {
            val wasRequested = fpsUserServiceBindingRequested
            fpsUserService = null
            fpsUserServiceBindingRequested = false
            wasRequested
        }
        if (shouldUnbind && shizukuFpsAccessSnapshot().available) {
            try {
                Shizuku.unbindUserService(fpsUserServiceArgs, fpsUserServiceConnection, true)
            } catch (_: Exception) {
                // Binder may have restarted or stopped.
            }
        }
    }

    // Relay a whitelisted FPS operation to Shizuku; arbitrary command strings are never accepted.
    private fun runDumpsys(vararg arguments: String): DumpsysResult {
        val access = shizukuFpsAccessSnapshot()
        if (!access.available) return DumpsysResult("", false, "shizuku_not_running")
        if (!access.supported) return DumpsysResult("", false, "shizuku_unsupported")
        if (!access.granted) return DumpsysResult("", false, "shizuku_permission_missing")
        val operation = when (arguments.toList()) {
            listOf("SurfaceFlinger", "--timestats", "-clear", "-enable") -> FpsShizukuUserService.OP_START_CAPTURE
            listOf("SurfaceFlinger", "--timestats", "-disable") -> FpsShizukuUserService.OP_STOP_CAPTURE
            listOf("activity", "activities") -> FpsShizukuUserService.OP_READ_FOREGROUND_ACTIVITY
            listOf("SurfaceFlinger", "--timestats", "-dump") -> FpsShizukuUserService.OP_READ_SURFACEFLINGER_STATS
            listOf("window", "displays") -> FpsShizukuUserService.OP_READ_FOREGROUND_WINDOW
            listOf("window") -> FpsShizukuUserService.OP_READ_FOREGROUND_WINDOW_FULL
            else -> return DumpsysResult("", false, "unsupported_fps_operation")
        }
        val remote = acquireFpsUserService()
            ?: return DumpsysResult("", false, "shizuku_userservice_unavailable")
        return try {
            val bundle = remote.executeFpsOperation(operation)
            DumpsysResult(bundle.getString("output", ""), bundle.getBoolean("ok", false), bundle.getString("error"))
        } catch (_: RemoteException) {
            releaseFpsUserService()
            DumpsysResult("", false, "shizuku_userservice_disconnected")
        } catch (_: Exception) {
            releaseFpsUserService()
            DumpsysResult("", false, "shizuku_userservice_error")
        }
    }



    // AI-METHOD / SURFACEFLINGER-STATS-PARSER
    // Support the JSON and line-oriented forms seen in Android SurfaceFlinger timestats dumps.
    private fun parseLayerFrameCounts(output: String): List<LayerFrameCount> {
        val fromJson = try {
            val root = JSONObject(output)
            val stats = root.optJSONObject("stats")
            if (stats == null) emptyList() else {
                val parsed = mutableListOf<LayerFrameCount>()
                val keys = stats.keys()
                while (keys.hasNext()) {
                    val name = keys.next()
                    val layer = stats.optJSONObject(name) ?: continue
                    val total = layer.optLong("totalFrames", -1L)
                    if (total >= 0L) parsed.add(LayerFrameCount(name, total))
                }
                parsed
            }
        } catch (_: Exception) {
            emptyList()
        }
        if (fromJson.isNotEmpty()) return fromJson

        val namePattern = Regex("""^\s*layerName\s*=\s*(.+?)\s*$""")
        val framePattern = Regex("""^\s*totalFrames\s*=\s*(\d+)\s*$""")
        val parsed = mutableListOf<LayerFrameCount>()
        var currentName: String? = null
        var currentFrames: Long? = null
        fun flush() {
            val name = currentName
            val frames = currentFrames
            if (name != null && frames != null && frames >= 0L) {
                parsed.add(LayerFrameCount(name.trim().trim('"'), frames))
            }
        }

        for (line in output.lineSequence()) {
            val nameMatch = namePattern.find(line)
            if (nameMatch != null) {
                flush()
                currentName = nameMatch.groupValues[1].trim().trim('"', ',')
                currentFrames = null
                continue
            }
            val frameMatch = framePattern.find(line)
            if (frameMatch != null && currentName != null) {
                currentFrames = frameMatch.groupValues[1].toLongOrNull()
            }
        }
        flush()
        return parsed.distinctBy { it.name }
    }

    // Allow any current foreground package, including JE Cooler itself, launchers,
    // Settings and Android system UI. Exact package-boundary matching below prevents
    // unrelated/background layers from being mixed into the screen sample.
    private fun isCandidateApplicationLayer(name: String): Boolean {
        val value = name.trim().lowercase()
        if (value.isEmpty() || value.contains("surfaceflinger")) return false
        return Regex("""[a-z][a-z0-9_]*(?:\.[a-z0-9_]+)+""").containsMatchIn(value)
    }

    // Prefer the focused WindowManager window. Some OEM builds omit focus fields from
    // "window displays", so retry the complete WindowManager dump before ActivityManager.
    private fun readForegroundPackage(): String? {
        fun focusedPackage(output: String): String? {
            val patterns = listOf(
                Regex("""\bmCurrentFocus\s*=\s*Window\{[^\r\n}]*\bu\d+\s+([A-Za-z0-9_.]+)/"""),
                Regex("""\bmFocusedApp\s*=\s*[^\r\n]*?\bu\d+\s+([A-Za-z0-9_.]+)/"""),
            )
            return patterns.firstNotNullOfOrNull { pattern ->
                pattern.find(output)?.groupValues?.get(1)
            }
        }

        val displaysResult = runDumpsys("window", "displays")
        if (displaysResult.ok) {
            focusedPackage(displaysResult.output)?.let { return it }
        }

        val fullWindowResult = runDumpsys("window")
        if (fullWindowResult.ok) {
            focusedPackage(fullWindowResult.output)?.let { return it }
        }

        val activityResult = runDumpsys("activity", "activities")
        if (!activityResult.ok) return null
        val activityPatterns = listOf(
            Regex("""\b(?:mResumedActivity|topResumedActivity|ResumedActivity)\s*[:=]\s*ActivityRecord\{[^\r\n}]*\bu\d+\s+([A-Za-z0-9_.]+)/"""),
            Regex("""\b(?:mResumedActivity|topResumedActivity|ResumedActivity)\s*[:=]\s*[^\r\n]*?\bu\d+\s+([A-Za-z0-9_.]+)/"""),
        )
        return activityPatterns.firstNotNullOfOrNull { pattern ->
            pattern.find(activityResult.output)?.groupValues?.get(1)
        }
    }

    // Match a compositor layer to a single exact package boundary to avoid counting another
    // app or a similarly prefixed package as this foreground app.
    private fun layerBelongsToPackage(layerName: String, foregroundPackage: String): Boolean {
        return layerName.contains("$foregroundPackage/") ||
            layerName.startsWith("$foregroundPackage#") ||
            layerName == foregroundPackage
    }

    // AI-METHOD / FPS-SAMPLE-CALCULATION
    // Compute per-layer frame deltas for the package behind the focused screen window.
    // Never substitute display refreshRate or an unrelated background layer for presented FPS.
    private fun pollSurfaceFlinger(generation: Int) {
        if (!fpsMonitorWanted || generation != fpsGeneration) return
        if (!hasShizukuFpsPermission()) {
            val access = shizukuFpsAccessSnapshot()
            val reason = when {
                !access.available -> "shizuku_not_running"
                !access.supported -> "shizuku_unsupported"
                else -> "shizuku_permission_missing"
            }
            fpsMainHandler.post {
                if (generation != fpsGeneration) return@post
                stopFpsMonitor(reason)
            }
            return
        }

        val foregroundPackage = readForegroundPackage()
        if (foregroundPackage == null) {
            fpsFrameCounts.clear()
            fpsLastSampleAtMs = 0L
            fpsTrackedLayer = null
            fpsLastPositiveLayer = null
            fpsTrackedPackage = null
            fpsMainHandler.post {
                if (generation != fpsGeneration) return@post
                data.fps = "--"
                fpsMonitorStatus = "foreground_unknown"
                hudView?.requestLayout()
                hudView?.invalidate()
            }
            return
        }

        // Track the exact focused package regardless of whether it is a game, App UI,
        // launcher, Settings, or Android system UI. Reject only unparseable identities.
        if (!isCandidateApplicationLayer(foregroundPackage)) {
            fpsFrameCounts.clear()
            fpsLastSampleAtMs = 0L
            fpsTrackedLayer = null
            fpsLastPositiveLayer = null
            fpsTrackedPackage = null
            fpsMainHandler.post {
                if (generation != fpsGeneration) return@post
                data.fps = "--"
                fpsMonitorStatus = "foreground_unknown"
                hudView?.requestLayout()
                hudView?.invalidate()
            }
            return
        }

        if (fpsTrackedPackage != foregroundPackage) {
            fpsFrameCounts.clear()
            fpsLastSampleAtMs = 0L
            fpsTrackedLayer = null
            fpsLastPositiveLayer = null
            fpsTrackedPackage = foregroundPackage
            fpsMainHandler.post {
                if (generation != fpsGeneration) return@post
                data.fps = "--"
                fpsMonitorStatus = "waiting_for_frames"
                hudView?.requestLayout()
                hudView?.invalidate()
            }
        }

        val result = runDumpsys("SurfaceFlinger", "--timestats", "-dump")
        if (!result.ok) {
            fpsMainHandler.post {
                if (generation != fpsGeneration) return@post
                stopFpsMonitor(result.error ?: "surfaceflinger_blocked")
            }
            return
        }

        val now = SystemClock.elapsedRealtime()
        val layers = parseLayerFrameCounts(result.output)
            .filter { isCandidateApplicationLayer(it.name) }
            .filter { layerBelongsToPackage(it.name, foregroundPackage) }

        if (layers.isEmpty()) {
            fpsFrameCounts.clear()
            fpsLastSampleAtMs = 0L
            fpsTrackedLayer = null
            fpsLastPositiveLayer = null
            fpsMainHandler.post {
                if (generation != fpsGeneration) return@post
                data.fps = "--"
                fpsMonitorStatus = "no_layer_data"
                hudView?.requestLayout()
                hudView?.invalidate()
            }
            return
        }

        val elapsed = if (fpsLastSampleAtMs == 0L) 0L else now - fpsLastSampleAtMs
        val previous = fpsFrameCounts.toMap()
        fpsFrameCounts.clear()
        for (layer in layers) fpsFrameCounts[layer.name] = layer.totalFrames

        // The first snapshot is a baseline, not a valid zero-FPS measurement.
        if (fpsLastSampleAtMs == 0L) {
            fpsLastSampleAtMs = now
            return
        }
        fpsLastSampleAtMs = now

        val elapsedValid = elapsed in MIN_VALID_FPS_SAMPLE_INTERVAL_MS..MAX_VALID_FPS_SAMPLE_INTERVAL_MS
        if (!elapsedValid) {
            fpsLastPositiveLayer = null
            fpsMainHandler.post {
                if (generation != fpsGeneration) return@post
                data.fps = "--"
                fpsMonitorStatus = "sample_invalid"
                hudView?.requestLayout()
                hudView?.invalidate()
            }
            return
        }

        val deltas = layers.mapNotNull { layer ->
            val old = previous[layer.name] ?: return@mapNotNull null
            val delta = layer.totalFrames - old
            if (delta < 0L || delta > MAX_VALID_FPS_FRAME_DELTA) return@mapNotNull null
            val fps = delta * 1000.0 / elapsed.toDouble()
            if (!fps.isFinite() || fps > MAX_VALID_FPS_VALUE) return@mapNotNull null
            Triple(layer, delta, fps)
        }

        // Zero is valid only for a layer with a previous positive sample in this session.
        // Missing, reset and out-of-range samples clear that evidence instead of yielding false zero.
        val lastPositiveName = fpsLastPositiveLayer
        val lastPositiveSample = deltas.firstOrNull { it.first.name == lastPositiveName }
        if (lastPositiveName != null && lastPositiveSample == null) {
            fpsLastPositiveLayer = null
        }

        val bestPositive = deltas.filter { it.second > 0L }.maxByOrNull { it.second }
        val verifiedZero = fpsLastPositiveLayer?.let { activeLayer ->
            deltas.firstOrNull { it.first.name == activeLayer && it.second == 0L }
        }

        val value: String
        val status: String
        when {
            bestPositive != null -> {
                fpsTrackedLayer = bestPositive.first.name
                fpsLastPositiveLayer = bestPositive.first.name
                value = bestPositive.third.roundToInt().coerceIn(1, 480).toString()
                status = "active"
            }
            verifiedZero != null -> {
                fpsTrackedLayer = verifiedZero.first.name
                value = "0"
                status = "active"
            }
            else -> {
                fpsTrackedLayer = null
                value = "--"
                status = "waiting_for_frames"
            }
        }
        fpsMainHandler.post {
            if (generation != fpsGeneration) return@post
            data.fps = value
            fpsMonitorStatus = status
            hudView?.requestLayout()
            hudView?.invalidate()
        }
    }

    companion object {
        private const val CHANNEL_ID = "je_x_fyz_floating"
        private const val NOTIFICATION_ID = 2301
        private const val ACTION_START = "je_x_fyz.floating.START"
        private const val ACTION_STOP = "je_x_fyz.floating.STOP"
        private const val ACTION_CONFIG = "je_x_fyz.floating.CONFIG"
        private const val ACTION_DATA = "je_x_fyz.floating.DATA"
        private const val EXTRA_JSON = "json"
        private const val MIN_VALID_FPS_SAMPLE_INTERVAL_MS = 250L
        private const val MAX_VALID_FPS_SAMPLE_INTERVAL_MS = 5000L
        private const val MAX_VALID_FPS_FRAME_DELTA = 1200L
        private const val MAX_VALID_FPS_VALUE = 480.0

        @Volatile
        private var instance: FloatingMonitorService? = null

        // AI-METHOD / START CONTRACT
        // Start the overlay foreground service only when the public overlay permission is granted.
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

        // AI-METHOD / STOP CONTRACT
        // Stop the native overlay service; Flutter controls the user-facing toggle state.
        fun stop(context: Context) {
            try {
                context.stopService(Intent(context, FloatingMonitorService::class.java))
            } catch (_: Exception) {
            }
        }

        // AI-METHOD / CONFIG CONTRACT
        // Apply configuration to a running service; start only as a compatibility fallback when absent.
        fun updateConfig(context: Context, json: String) {
            instance?.applyConfig(json) ?: start(context, json)
        }

        // AI-METHOD / RUNTIME-STATE CONTRACT
        // Expose public permission, service, WindowManager attach, and persisted geometry diagnostics.
        fun runtimeState(context: Context): Map<String, Any?> {
            return instance?.runtimeStateMap() ?: run {
                val prefs = context.getSharedPreferences(
                    "jexfyz_floating_native_v1",
                    Context.MODE_PRIVATE
                )
                mapOf(
                    "running" to false,
                    "service_running" to false,
                    "overlay" to false,
                    "public_overlay_granted" to Settings.canDrawOverlays(context),
                    "window_add_attempted" to false,
                    "window_add_succeeded" to false,
                    "window_add_error" to null,
                    "view_attached_to_window" to false,
                    "fps_permission_granted" to shizukuFpsAccessSnapshot().granted,
                    "shizuku_available" to shizukuFpsAccessSnapshot().available,
                    "shizuku_supported" to shizukuFpsAccessSnapshot().supported,
                    "shizuku_permission_granted" to shizukuFpsAccessSnapshot().granted,
                    "shizuku_uid" to shizukuFpsAccessSnapshot().uid,
                    "fps_monitor_active" to false,
                    "fps_monitor_status" to shizukuFpsAccessSnapshot().toStatusMap("monitor_off", false)["fps_monitor_status"],
                    "horizontal" to prefs.getBoolean("horizontal", true),
                    "size" to prefs.getFloat("size", 0.6f).coerceIn(0.3f, 1.0f).toDouble(),
                    "x" to prefs.getInt("x", 16),
                    "y" to prefs.getInt("y", 120),
                )
            }
        }

        // AI-METHOD / FPS ACCESS STATUS CONTRACT
        // Report the narrowly scoped ADB DUMP grant and native FPS sampler state.
        fun fpsAccessStatus(context: Context): Map<String, Any?> {
            return instance?.fpsAccessStateMap()
                ?: shizukuFpsAccessSnapshot().toStatusMap("monitor_off", false)
        }

        // Refresh the sampler only when a real attached overlay and the F metric are selected.
        fun refreshFpsMonitor(context: Context): Map<String, Any?> {
            instance?.refreshFpsMonitor()
            return fpsAccessStatus(context)
        }

        // AI-METHOD / DATA CONTRACT
        // Forward live telemetry to the existing service instance; never start a service from telemetry.
        fun updateData(context: Context, json: String) {
            instance?.applyData(json)
        }
    }

    private data class Config(
        var enabled: Boolean = false,
        var style: String = "letters",
        var order: MutableList<String> = mutableListOf("F", "B", "H", "V", "A", "P", "S"),
        var selected: MutableSet<String> = mutableSetOf(),
        var size: Float = 0.6f,
        var opacity: Float = 0.9f,
        var backgroundColor: String = "black",
        var horizontal: Boolean = true,
    )

    // AI-MEMORY / DATA CONTRACT
    // Live presentation data forwarded from Flutter. The language is presentation state,
    // not device protocol state, and therefore never changes BLE command semantics.
    private data class Data(
        var fps: String = "--",
        var battery: String = "--",
        var hotside: String = "--",
        var voltage: String = "--",
        var fanOn: Boolean = false,
        var speed: Int = 100,
        var adaptiveOn: Boolean = false,
        var peltierOn: Boolean = false,
        var connected: Boolean = false,
        var language: String = "english",
    )

    private lateinit var windowManager: WindowManager
    private var hudView: FloatingHudView? = null
    private lateinit var layoutParams: WindowManager.LayoutParams
    private var config = Config()
    private var data = Data()
    private var windowAddAttempted = false
    private var windowAddSucceeded = false
    private var windowAddError: String? = null
    private var viewAttachedToWindow = false
    private val prefs by lazy { getSharedPreferences("jexfyz_floating_native_v1", Context.MODE_PRIVATE) }

    // FPS capture runs off the main thread and samples SurfaceFlinger totals once per second.
    // It is active only while the user-enabled overlay is attached and metric F is selected.
    private val fpsMainHandler = Handler(Looper.getMainLooper())
    private val fpsExecutor = Executors.newSingleThreadScheduledExecutor { task ->
        Thread(task, "JE-FPS-Monitor").apply { isDaemon = true }
    }
    @Volatile private var fpsMonitorWanted = false
    @Volatile private var fpsCaptureEnabled = false
    @Volatile private var fpsMonitorStatus = "monitor_off"
    @Volatile private var fpsGeneration = 0
    @Volatile private var fpsPollingTask: ScheduledFuture<*>? = null
    private val fpsFrameCounts = mutableMapOf<String, Long>() // FPS worker thread only.
    private var fpsLastSampleAtMs = 0L
    private var fpsTrackedLayer: String? = null
    private var fpsTrackedPackage: String? = null
    private var fpsLastPositiveLayer: String? = null

    // AI-METHOD / SERVICE-CREATE CONTRACT
    // Initialize WindowManager, notification channel, and the required specialUse foreground service.
    override fun onCreate() {
        super.onCreate()
        instance = this
        windowManager = getSystemService(WINDOW_SERVICE) as WindowManager
        createNotificationChannel()
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
            startForeground(
                NOTIFICATION_ID,
                buildNotification(),
                ServiceInfo.FOREGROUND_SERVICE_TYPE_SPECIAL_USE,
            )
        } else {
            startForeground(NOTIFICATION_ID, buildNotification())
        }
    }

    // AI-METHOD / COMMAND-DISPATCH CONTRACT
    // Handle start/stop/config/data intents without changing BLE ownership or protocol.
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

    // AI-METHOD / SERVICE-DESTROY CONTRACT
    // Remove any attached overlay and clear the singleton instance used by the MethodChannel bridge.
    override fun onDestroy() {
        removeOverlay()
        instance = null
        fpsExecutor.execute { releaseFpsUserService() }
        fpsExecutor.shutdown()
        super.onDestroy()
    }

    // AI-METHOD / BIND-CONTRACT
    // This service is command-driven and deliberately not bound to an Activity client.
    override fun onBind(intent: Intent?): IBinder? = null

    // AI-METHOD / RUNTIME-MAP-CONTRACT
    // Compose one diagnostic snapshot; attached state is the definitive overlay-health signal.
    private fun runtimeStateMap(): Map<String, Any?> {
        val attached = hudView?.isAttachedToWindow == true || viewAttachedToWindow
        return mapOf(
            "running" to (instance === this),
            "service_running" to (instance === this),
            "overlay" to (hudView != null && config.enabled && attached),
            "public_overlay_granted" to Settings.canDrawOverlays(this),
            "window_add_attempted" to windowAddAttempted,
            "window_add_succeeded" to windowAddSucceeded,
            "window_add_error" to windowAddError,
            "view_attached_to_window" to attached,
            "horizontal" to config.horizontal,
            "size" to config.size.toDouble(),
            "x" to if (::layoutParams.isInitialized) layoutParams.x else 16,
            "y" to if (::layoutParams.isInitialized) layoutParams.y else 120,
            "fps_permission_granted" to shizukuFpsAccessSnapshot().granted,
            "shizuku_available" to shizukuFpsAccessSnapshot().available,
            "shizuku_supported" to shizukuFpsAccessSnapshot().supported,
            "shizuku_permission_granted" to shizukuFpsAccessSnapshot().granted,
            "shizuku_uid" to shizukuFpsAccessSnapshot().uid,
            "fps_monitor_active" to (fpsMonitorStatus == "active" && hasShizukuFpsPermission()),
            "fps_monitor_status" to shizukuFpsAccessSnapshot().toStatusMap(fpsMonitorStatus, fpsMonitorStatus == "active")["fps_monitor_status"],
        )
    }

    // AI-METHOD / NOTIFICATION-CONTRACT
    // Create the low-priority channel required by the foreground overlay service.
    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) return
        val manager = getSystemService(NotificationManager::class.java)
        val channel = NotificationChannel(
            CHANNEL_ID,
            "JE X FYZ",
            NotificationManager.IMPORTANCE_LOW,
        ).apply {
            description = ""
            setShowBadge(false)
            setSound(null, null)
            enableVibration(false)
        }
        manager.createNotificationChannel(channel)
    }

    // AI-METHOD / NOTIFICATION-BUILD-CONTRACT
    // Build the persistent foreground-service notification without exposing device controls.
    private fun buildNotification(): Notification {
        val builder = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            Notification.Builder(this, CHANNEL_ID)
        } else {
            @Suppress("DEPRECATION")
            Notification.Builder(this)
        }
        return builder
            .setJexNotificationBranding(this)
            .setContentTitle("JE X FYZ")
            .setContentText(
                if (data.language.equals("indonesia", ignoreCase = true))
                    "Monitor Melayang aktif"
                else
                    "Floating Monitor active"
            )
            .setOngoing(true)
            .setShowWhen(false)
            .setCategory(Notification.CATEGORY_SERVICE)
            .setContentIntent(jexNotificationContentIntent(this, NOTIFICATION_ID))
            .setPriority(Notification.PRIORITY_LOW)
            .build()
    }

    // AI-METHOD / CONFIG-APPLY-CONTRACT
    // Parse persisted/display configuration, then attach/remove the native overlay accordingly.
    private fun applyConfig(json: String) {
        try {
            val obj = JSONObject(json)
            config.enabled = obj.optBoolean("enabled", false)
            config.style = "letters"
            config.size = obj.optDouble("size", 0.6).toFloat().coerceIn(0.3f, 1.0f)
            config.opacity = obj.optDouble("opacity", 0.9).toFloat().coerceIn(0.0f, 1.0f)
            config.backgroundColor = if (obj.optString("backgroundColor", "black").equals("white", ignoreCase = true)) "white" else "black"
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
            refreshFpsMonitor()
        } catch (_: Exception) {
        }
    }

    // AI-METHOD / DATA-APPLY-CONTRACT
    // Update native presentation telemetry only; Flutter remains the live state producer.
    private fun applyData(json: String) {
        try {
            val obj = JSONObject(json)
            // FPS is owned by the native SurfaceFlinger sampler, not Flutter frame timing.
            data.battery = obj.optString("battery", "--")
            data.hotside = obj.optString("hotside", "--")
            data.voltage = obj.optString("voltage", "--")
            data.fanOn = obj.optBoolean("fanOn", false)
            data.speed = obj.optInt("speed", 100)
            data.adaptiveOn = obj.optBoolean("adaptiveOn", false)
            data.peltierOn = obj.optBoolean("peltierOn", false)
            data.connected = obj.optBoolean("connected", false)
            val nextLanguage = obj.optString("language", data.language).lowercase()
            val languageChanged = nextLanguage != data.language
            data.language = nextLanguage
            if (config.enabled) {
                // Values can change measured HUD width (for example FPS 60 -> 120 or
                // Hotside changing from -- to a numeric temperature), not just its pixels.
                hudView?.requestLayout()
                hudView?.invalidate()
            }
            if (languageChanged) {
                getSystemService(NotificationManager::class.java)
                    .notify(NOTIFICATION_ID, buildNotification())
            }
        } catch (_: Exception) {
        }
    }

    // AI-METHOD / GEOMETRY-PERSIST-CONTRACT
    // Persist user-controlled position/orientation/size so the next overlay session restores it.
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

    // AI-METHOD / ATTACH-CONTRACT
    // Verify the public permission, create the real HUD window, and record attach diagnostics.
    private fun ensureOverlay() {
        if (!config.enabled) return

        if (!Settings.canDrawOverlays(this)) {
            windowAddAttempted = false
            windowAddSucceeded = false
            windowAddError = "SYSTEM_ALERT_WINDOW permission denied"
            removeOverlay()
            return
        }

        if (hudView == null) {
            windowAddAttempted = true
            windowAddSucceeded = false
            windowAddError = null
            viewAttachedToWindow = false

            val view = FloatingHudView(this)
            view.addOnAttachStateChangeListener(object : android.view.View.OnAttachStateChangeListener {
                override fun onViewAttachedToWindow(v: android.view.View) {
                    if (v === hudView) {
                        viewAttachedToWindow = true
                    }
                }

                override fun onViewDetachedFromWindow(v: android.view.View) {
                    if (v === hudView) {
                        viewAttachedToWindow = false
                    }
                }
            })
            hudView = view

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
                windowManager.addView(view, layoutParams)
                windowAddSucceeded = true
                viewAttachedToWindow = view.isAttachedToWindow
            } catch (error: Exception) {
                windowAddSucceeded = false
                windowAddError = formatWindowAddError(error)
                viewAttachedToWindow = false
                hudView = null
            }
        } else {
            viewAttachedToWindow = hudView?.isAttachedToWindow == true
            hudView?.requestLayout()
            hudView?.invalidate()
        }
    }

    // AI-METHOD / ERROR-FORMAT-CONTRACT
    // Preserve the exception class plus message so Flutter can distinguish WindowManager failures.
    private fun formatWindowAddError(error: Exception): String {
        val type = error::class.java.simpleName
        val message = error.message?.trim().orEmpty()
        return if (message.isEmpty()) type else "$type: $message"
    }

    // AI-METHOD / DETACH-CONTRACT
    // Remove the attached view safely and clear attach state even when WindowManager reports an error.
    private fun removeOverlay() {
        stopFpsMonitor("monitor_off")
        val view = hudView ?: run {
            viewAttachedToWindow = false
            return
        }
        try {
            windowManager.removeView(view)
        } catch (_: Exception) {
        }
        viewAttachedToWindow = false
        hudView = null
    }

    // AI-METHOD / ORIENTATION-CONTRACT
    // Toggle horizontal/vertical layout without changing metric order or device state.
    private fun rotateOrientation() {
        config.horizontal = !config.horizontal
        persistNativePositionAndSize()
        hudView?.requestLayout()
        hudView?.invalidate()
    }

    // AI-METHOD / RESIZE-CONTRACT
    // Apply bounded user scaling and persist it; actual window geometry is updated through WindowManager.
    private fun resizeOverlay(newSize: Float) {
        config.size = newSize.coerceIn(0.3f, 1.0f)
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

        // AI-MEMORY / VISIBILITY-INVARIANT
        // Selected metrics remain visible. S (Fan Speed) reports OFF/MATI when Fan is OFF.
        private val visibleMetrics: List<String>
            get() = config.order.filter { config.selected.contains(it) }

        init {
            setBackgroundColor(Color.TRANSPARENT)
            isClickable = true
        }

        // AI-METHOD / DP-CONTRACT
        // Convert logical density-independent units to physical pixels for the native HUD.
        private fun dp(value: Float): Float = value * density

        // AI-METHOD / MEASURE-CONTRACT
        // Measure only metrics currently selected and visible; S is omitted when Fan is OFF.
        override fun onMeasure(widthMeasureSpec: Int, heightMeasureSpec: Int) {
            val size = config.size
            val textSize = dp(11.5f * size)
            textPaint.textSize = textSize
            val horizontal = config.horizontal
            val metrics = visibleMetrics
            val gap = dp(5f * size)
            val padX = dp(8f * size)
            val padY = dp(5f * size)

            var width = padX * 2
            var height = padY * 2

            if (metrics.isEmpty()) {
                width += dp(20f * size)
                height += dp(12f * size)
            } else if (horizontal) {
                width += metrics.fold(0f) { total, metric -> total + itemWidth(metric) } + gap * (metrics.size - 1)
                height += max(dp(28f * size), metrics.maxOf { itemHeight(it) })
            } else {
                width += metrics.maxOf { itemWidth(it) }
                height += metrics.fold(0f) { total, metric -> total + itemHeight(metric) } + gap * (metrics.size - 1)
            }

            setMeasuredDimension(ceil(width).toInt(), ceil(height).toInt())
        }

        // AI-METHOD / METRIC-TEXT-CONTRACT
        // Convert stable metric identifiers to presentation text using the Flutter-selected language.
        private fun itemText(metric: String): String {
            val onText = if (data.language == "indonesia") "HIDUP" else "ON"
            val offText = if (data.language == "indonesia") "MATI" else "OFF"
            return when (metric) {
                "F" -> "F:" + data.fps
                "B" -> "B:" + if (!data.connected || data.battery == "--") "--" else data.battery + "°"
                "H" -> "H:" + if (!data.connected || data.hotside == "--") "--" else data.hotside + "°"
                "V" -> "V:" + if (data.connected) data.voltage else "--"
                "A" -> "A:" + if (!data.connected) "--" else if (data.adaptiveOn) onText else offText
                "P" -> "P:" + if (!data.connected) "--" else if (data.peltierOn) onText else offText
                "S" -> "S:" + if (!data.connected) "--" else if (data.fanOn) data.speed.toString() else offText
                else -> ""
            }
        }

        // AI-METHOD / METRIC-WIDTH-CONTRACT
        // Calculate width from the localized presentation value and current display style/scale.
        private fun itemWidth(metric: String): Float {
            if (config.style == "icons") {
                return dp(21f * config.size) + dp(4f * config.size) + textPaint.measureText(itemText(metric))
            }
            return textPaint.measureText(itemText(metric))
        }

        // AI-METHOD / METRIC-HEIGHT-CONTRACT
        // Return the scaled minimum row height for native HUD measurement.
        private fun itemHeight(metric: String): Float {
            return max(dp(18f * config.size), textPaint.textSize)
        }

        // AI-METHOD / DRAW-CONTRACT
        // Draw a compact HUD, center the metric group within its own box, and contrast text/icons
        // against the selected background. WindowManager position remains freely draggable.
        override fun onDraw(canvas: Canvas) {
            super.onDraw(canvas)
            val scale = config.size
            val radius = dp(12f * scale)
            val isWhiteBackground = config.backgroundColor == "white"
            val foreground = if (isWhiteBackground) Color.rgb(24, 27, 32) else Color.WHITE
            val background = if (isWhiteBackground) Color.WHITE else Color.rgb(10, 10, 12)
            textPaint.color = foreground
            iconPaint.color = foreground
            fillPaint.color = foreground
            bgPaint.color = Color.argb(
                (config.opacity.coerceIn(0.0f, 1.0f) * 255f).roundToInt(),
                Color.red(background),
                Color.green(background),
                Color.blue(background),
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
            val padY = dp(5f * scale)
            val gap = dp(5f * scale)
            val fontMetrics = textPaint.fontMetrics
            val centeredBaseline = (height - fontMetrics.ascent - fontMetrics.descent) / 2f
            if (config.horizontal) {
                val contentWidth = metrics.sumOf { itemWidth(it).toDouble() }.toFloat() +
                    gap * (metrics.size - 1).coerceAtLeast(0)
                var cursor = (width - contentWidth) / 2f
                for (metric in metrics) {
                    drawMetric(canvas, metric, cursor, centeredBaseline, scale)
                    cursor += itemWidth(metric) + gap
                }
            } else {
                var cursor = padY
                for (metric in metrics) {
                    val itemH = itemHeight(metric)
                    val baseline = cursor + (itemH - fontMetrics.descent - fontMetrics.ascent) / 2f
                    // Use one left edge for every row; varying text lengths must not alter alignment.
                    val leftX = dp(8f * scale)
                    drawMetric(canvas, metric, leftX, baseline, scale)
                    cursor += itemH + gap
                }
            }
        }

        // AI-METHOD / METRIC-DRAW-CONTRACT
        // Draw one metric as letters or icon+value; status words are localized at itemText().
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

        // AI-METHOD / ICON-CONTRACT
        // Draw a stable functional icon for the metric identifier without encoding device behavior.
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

        // AI-METHOD / GESTURE-CONTRACT
        // Support drag, pinch resize, and tap orientation switching; persist geometry after interaction.
        override fun onTouchEvent(event: MotionEvent): Boolean {
            scaleDetector.onTouchEvent(event)
            when (event.actionMasked) {
                MotionEvent.ACTION_DOWN -> {
                    downRawX = event.rawX
                    downRawY = event.rawY
                    downX = this@FloatingMonitorService.layoutParams.x
                    downY = this@FloatingMonitorService.layoutParams.y
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
                        this@FloatingMonitorService.layoutParams.x = downX + dx.roundToInt()
                        this@FloatingMonitorService.layoutParams.y = downY + dy.roundToInt()
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
