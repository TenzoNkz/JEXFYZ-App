package com.horizontalzzz.jexfyz

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.RemoteInput
import android.app.Service
import android.content.Context
import android.content.Intent
import android.content.pm.ServiceInfo
import android.net.nsd.NsdManager
import android.net.nsd.NsdServiceInfo
import android.os.Build
import android.os.Handler
import android.os.IBinder
import android.os.Looper
import android.provider.Settings
import com.flyfishxu.kadb.Kadb
import kotlinx.coroutines.runBlocking
import java.util.concurrent.Executors

/**
 * A user-started Android 11+ Wireless Debugging flow.
 *
 * The only remote shell command is the fixed DUMP permission grant used by the existing FPS
 * sampler. There is no Flutter API for arbitrary ADB commands, remote hosts, or remote ports.
 * A fresh six-digit code is entered by the user in this service's ongoing notification.
 */
class WirelessAdbPairingService : Service() {
    private enum class Stage {
        IDLE, DISCOVERING_PAIR, WAITING_CODE, PAIRING, DISCOVERING_CONNECT, GRANTING, FAILED, FINISHED
    }

    companion object {
        private const val ACTION_START = "com.horizontalzzz.jexfyz.adbpair.START"
        private const val ACTION_SUBMIT_CODE = "com.horizontalzzz.jexfyz.adbpair.SUBMIT_CODE"
        private const val ACTION_CANCEL = "com.horizontalzzz.jexfyz.adbpair.CANCEL"
        private const val EXTRA_LANGUAGE = "language"
        private const val EXTRA_PORT = "pairing_port"
        private const val EXTRA_CODE = "pairing_code"

        private const val PAIRING_TYPE = "_adb-tls-pairing._tcp."
        private const val CONNECT_TYPE = "_adb-tls-connect._tcp."
        private const val LOOPBACK = "127.0.0.1"
        private const val GRANT_DUMP_COMMAND = "pm grant com.horizontalzzz.jexfyz android.permission.DUMP"

        private const val CHANNEL_ID = "je_cooler_wireless_adb_pairing"
        private const val RESULT_CHANNEL_ID = "je_cooler_wireless_adb_result"
        private const val NOTIFICATION_ID = 2341
        private const val RESULT_NOTIFICATION_ID = 2342
        private const val REQUEST_CODE_INPUT = 2343
        private const val REQUEST_CODE_CANCEL = 2344
        private const val REQUEST_CODE_SETTINGS = 2345
        private const val REQUEST_CODE_RETRY = 2346

        private const val DISCOVERY_TIMEOUT_MS = 30_000L
        private const val CODE_ENTRY_TIMEOUT_MS = 90_000L
        private const val CONNECT_TIMEOUT_MS = 30_000L

        fun start(context: Context, language: String): Boolean {
            if (Build.VERSION.SDK_INT < Build.VERSION_CODES.R) return false
            return try {
                val intent = Intent(context, WirelessAdbPairingService::class.java)
                    .setAction(ACTION_START)
                    .putExtra(EXTRA_LANGUAGE, language)
                context.startForegroundService(intent)
                true
            } catch (_: Exception) {
                false
            }
        }
    }

    private lateinit var nsdManager: NsdManager
    private val handler = Handler(Looper.getMainLooper())
    private val worker = Executors.newSingleThreadExecutor()
    private var language = "english"
    private var discoveryListener: NsdManager.DiscoveryListener? = null
    private var currentServiceType: String? = null
    private val resolvingNames = mutableSetOf<String>()
    private var pairingPort = 0
    @Volatile private var stage = Stage.IDLE
    private var timeoutRunnable: Runnable? = null

    override fun onCreate() {
        super.onCreate()
        nsdManager = getSystemService(Context.NSD_SERVICE) as NsdManager
        createNotificationChannels()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        when (intent?.action ?: ACTION_START) {
            ACTION_CANCEL -> {
                cancelPairing()
                return START_NOT_STICKY
            }
            ACTION_SUBMIT_CODE -> {
                intent?.getStringExtra(EXTRA_LANGUAGE)?.let { language = it }
                handlePairingCode(intent)
            }
            ACTION_START -> {
                intent?.getStringExtra(EXTRA_LANGUAGE)?.let { language = it }
                if (stage == Stage.IDLE || stage == Stage.FAILED || stage == Stage.FINISHED) {
                    startAsForeground(
                        buildOngoingNotification(
                            text("Starting Wireless debugging pairing…", "Memulai pairing Wireless debugging…"),
                            allowCodeInput = false,
                            port = 0,
                            allowRetry = false,
                        ),
                    )
                    startPairingDiscovery()
                } else {
                    startAsForeground(
                        buildOngoingNotification(
                            stageMessage(),
                            allowCodeInput = stage == Stage.WAITING_CODE,
                            port = pairingPort,
                            allowRetry = stage == Stage.FAILED,
                        ),
                    )
                }
            }
            else -> return START_NOT_STICKY
        }
        return START_NOT_STICKY
    }

    private fun startPairingDiscovery() {
        cancelTimeout()
        stopDiscovery()
        pairingPort = 0
        stage = Stage.DISCOVERING_PAIR
        updateOngoing(
            text(
                "Open Developer options → Wireless debugging → Pair device with pairing code. Keep the pairing dialog open; a code field will appear in this notification.",
                "Buka Opsi developer → Wireless debugging → Pasangkan perangkat dengan kode pairing. Biarkan dialog tetap terbuka; kolom kode akan muncul di notifikasi ini.",
            ),
            allowCodeInput = false,
            port = 0,
            allowRetry = false,
        )
        beginDiscovery(PAIRING_TYPE)
        scheduleTimeout(Stage.DISCOVERING_PAIR, DISCOVERY_TIMEOUT_MS)
    }

    private fun handlePairingCode(intent: Intent?) {
        val code = RemoteInput.getResultsFromIntent(intent)
            ?.getCharSequence(EXTRA_CODE)
            ?.toString()
            ?.trim()
            .orEmpty()
        val requestedPort = intent?.getIntExtra(EXTRA_PORT, 0) ?: 0
        if (!code.matches(Regex("[0-9]{6}"))) {
            updateOngoing(
                text("Enter the current six-digit Android pairing code.", "Masukkan kode pairing enam digit Android yang sedang aktif."),
                allowCodeInput = stage == Stage.WAITING_CODE,
                port = pairingPort,
                allowRetry = false,
            )
            return
        }
        if (stage != Stage.WAITING_CODE || requestedPort !in 1..65535 || requestedPort != pairingPort) {
            updateOngoing(
                text(
                    "That pairing code expired. Reopen Android’s pairing-code dialog and try again.",
                    "Kode pairing sudah kedaluwarsa. Buka kembali dialog kode pairing Android lalu coba lagi.",
                ),
                allowCodeInput = false,
                port = 0,
                allowRetry = true,
            )
            stage = Stage.FAILED
            return
        }

        cancelTimeout()
        stage = Stage.PAIRING
        updateOngoing(
            text("Pairing with this phone…", "Melakukan pairing dengan HP ini…"),
            allowCodeInput = false,
            port = 0,
            allowRetry = false,
        )

        worker.execute {
            try {
                WirelessAdbIdentityStore.ensureLoaded(applicationContext)
                runBlocking {
                    Kadb.pair(LOOPBACK, requestedPort, code, "JE Cooler")
                }
                handler.post {
                    if (stage != Stage.PAIRING) return@post
                    pairingPort = 0
                    stage = Stage.DISCOVERING_CONNECT
                    updateOngoing(
                        text(
                            "Pairing was accepted. Finding this phone’s ADB connection endpoint to enable FPS access…",
                            "Pairing diterima. Mencari endpoint koneksi ADB HP ini untuk mengaktifkan akses FPS…",
                        ),
                        allowCodeInput = false,
                        port = 0,
                        allowRetry = false,
                    )
                    beginDiscovery(CONNECT_TYPE)
                    scheduleTimeout(Stage.DISCOVERING_CONNECT, CONNECT_TIMEOUT_MS)
                }
            } catch (_: Throwable) {
                handler.post {
                    if (stage != Stage.PAIRING) return@post
                    pairingPort = 0
                    stage = Stage.FAILED
                    stopDiscovery()
                    updateOngoing(
                        text(
                            "Pairing failed or the code expired. Reopen “Pair device with pairing code”, then tap Pair again.",
                            "Pairing gagal atau kode kedaluwarsa. Buka kembali “Pasangkan perangkat dengan kode pairing”, lalu tekan Pair lagi.",
                        ),
                        allowCodeInput = false,
                        port = 0,
                        allowRetry = true,
                    )
                }
            }
        }
    }

    private fun beginDiscovery(serviceType: String) {
        stopDiscovery()
        currentServiceType = serviceType
        resolvingNames.clear()
        val listener = object : NsdManager.DiscoveryListener {
            override fun onDiscoveryStarted(serviceType: String) = Unit

            override fun onServiceFound(serviceInfo: NsdServiceInfo) {
                if (discoveryListener !== this || currentServiceType != serviceType) return
                val name = serviceInfo.serviceName?.trim().orEmpty()
                if (name.isBlank() || !resolvingNames.add(name)) return
                try {
                    @Suppress("DEPRECATION")
                    nsdManager.resolveService(serviceInfo, object : NsdManager.ResolveListener {
                        override fun onResolveFailed(info: NsdServiceInfo, errorCode: Int) {
                            resolvingNames.remove(info.serviceName)
                        }

                        override fun onServiceResolved(info: NsdServiceInfo) {
                            resolvingNames.remove(info.serviceName)
                            if (discoveryListener !== listener || currentServiceType != serviceType) return
                            if (info.port !in 1..65535) return
                            when (serviceType.trimEnd('.')) {
                                PAIRING_TYPE.trimEnd('.') -> {
                                    if (stage != Stage.DISCOVERING_PAIR) return
                                    pairingPort = info.port
                                    stage = Stage.WAITING_CODE
                                    cancelTimeout()
                                    stopDiscovery()
                                    updateOngoing(
                                        text(
                                            "Pairing service found. Enter the six-digit code currently shown by Android in this notification.",
                                            "Layanan pairing ditemukan. Masukkan kode enam digit yang sedang ditampilkan Android melalui notifikasi ini.",
                                        ),
                                        allowCodeInput = true,
                                        port = pairingPort,
                                        allowRetry = false,
                                    )
                                    scheduleTimeout(Stage.WAITING_CODE, CODE_ENTRY_TIMEOUT_MS)
                                }
                                CONNECT_TYPE.trimEnd('.') -> {
                                    if (stage != Stage.DISCOVERING_CONNECT) return
                                    cancelTimeout()
                                    stopDiscovery()
                                    stage = Stage.GRANTING
                                    updateOngoing(
                                        text("Enabling the requested Game FPS access…", "Mengaktifkan akses FPS Game yang diminta…"),
                                        allowCodeInput = false,
                                        port = 0,
                                        allowRetry = false,
                                    )
                                    worker.execute { connectAndGrant(info.port) }
                                }
                            }
                        }
                    })
                } catch (_: Exception) {
                    resolvingNames.remove(name)
                }
            }

            override fun onServiceLost(serviceInfo: NsdServiceInfo) {
                resolvingNames.remove(serviceInfo.serviceName)
            }

            override fun onDiscoveryStopped(serviceType: String) = Unit

            override fun onStartDiscoveryFailed(serviceType: String, errorCode: Int) {
                if (discoveryListener !== this) return
                discoveryListener = null
                currentServiceType = null
                resolvingNames.clear()
                stage = Stage.FAILED
                cancelTimeout()
                updateOngoing(
                    text(
                        "Android did not start local Wireless debugging discovery. Check Wi-Fi and Wireless debugging, then tap Pair again.",
                        "Penemuan Wireless debugging lokal gagal dimulai. Periksa Wi-Fi dan Wireless debugging, lalu tekan Pair lagi.",
                    ),
                    allowCodeInput = false,
                    port = 0,
                    allowRetry = true,
                )
            }

            override fun onStopDiscoveryFailed(serviceType: String, errorCode: Int) {
                if (discoveryListener === this) {
                    discoveryListener = null
                    currentServiceType = null
                }
            }
        }

        discoveryListener = listener
        try {
            nsdManager.discoverServices(serviceType, NsdManager.PROTOCOL_DNS_SD, listener)
        } catch (_: Exception) {
            discoveryListener = null
            currentServiceType = null
            stage = Stage.FAILED
            cancelTimeout()
            updateOngoing(
                text("Could not start local discovery. Check Wi-Fi and retry pairing.", "Penemuan lokal tidak dapat dimulai. Periksa Wi-Fi lalu ulangi pairing."),
                allowCodeInput = false,
                port = 0,
                allowRetry = true,
            )
        }
    }

    private fun connectAndGrant(port: Int) {
        try {
            check(port in 1..65535) { "ADB connection port is invalid" }
            WirelessAdbIdentityStore.ensureLoaded(applicationContext)
            val response = Kadb.create(LOOPBACK, port, connectTimeout = 5_000, socketTimeout = 15_000)
                .use { client -> client.shell(GRANT_DUMP_COMMAND) }
            check(response.exitCode == 0 && !response.allOutput.contains("Failure", ignoreCase = true)) {
                "Android rejected the fixed FPS permission request"
            }

            var permissionGranted = false
            repeat(10) {
                if (checkSelfPermission("android.permission.DUMP") == android.content.pm.PackageManager.PERMISSION_GRANTED) {
                    permissionGranted = true
                    return@repeat
                }
                Thread.sleep(200)
            }
            check(permissionGranted) { "Android did not confirm the DUMP permission" }

            handler.post {
                if (stage != Stage.GRANTING) return@post
                finishWithResult(
                    success = true,
                    message = text(
                        "Game FPS access is enabled. Return to JE Cooler and tap Check access. The code was used only for this local phone; ADB access remains paired until you forget JE Cooler in Wireless debugging or revoke ADB authorizations.",
                        "Akses FPS Game sudah aktif. Kembali ke JE Cooler lalu tekan Periksa akses. Kode hanya digunakan untuk HP ini; ADB tetap dipasangkan sampai kamu melupakan JE Cooler di Wireless debugging atau mencabut semua otorisasi ADB.",
                    ),
                )
            }
        } catch (_: Throwable) {
            handler.post {
                if (stage != Stage.GRANTING) return@post
                finishWithResult(
                    success = false,
                    message = text(
                        "ADB pairing was accepted, but Android did not confirm the DUMP permission. Try again or use Manual ADB setup; some OEM builds block development permissions.",
                        "Pairing ADB diterima, tetapi Android tidak mengonfirmasi izin DUMP. Coba lagi atau gunakan Atur ADB Manual; sebagian ROM menolak izin khusus pengembangan.",
                    ),
                )
            }
        }
    }

    private fun scheduleTimeout(expectedStage: Stage, timeoutMs: Long) {
        cancelTimeout()
        val runnable = Runnable {
            if (stage != expectedStage) return@Runnable
            when (expectedStage) {
                Stage.DISCOVERING_PAIR -> {
                    stopDiscovery()
                    stage = Stage.FAILED
                    updateOngoing(
                        text(
                            "Pairing service not found. Keep the Android pairing-code dialog open and tap Pair again.",
                            "Layanan pairing tidak ditemukan. Biarkan dialog kode pairing Android terbuka lalu tekan Pair lagi.",
                        ),
                        allowCodeInput = false,
                        port = 0,
                        allowRetry = true,
                    )
                }
                Stage.WAITING_CODE -> startPairingDiscovery()
                Stage.DISCOVERING_CONNECT -> finishWithResult(
                    success = false,
                    message = text(
                        "Pairing succeeded, but this phone’s ADB connection endpoint was not found. Keep Wireless debugging enabled and retry.",
                        "Pairing berhasil, tetapi endpoint koneksi ADB HP ini tidak ditemukan. Tetap aktifkan Wireless debugging lalu coba lagi.",
                    ),
                )
                else -> Unit
            }
        }
        timeoutRunnable = runnable
        handler.postDelayed(runnable, timeoutMs)
    }

    private fun cancelTimeout() {
        timeoutRunnable?.let(handler::removeCallbacks)
        timeoutRunnable = null
    }

    private fun stopDiscovery() {
        val listener = discoveryListener
        discoveryListener = null
        currentServiceType = null
        resolvingNames.clear()
        if (listener != null) {
            try {
                nsdManager.stopServiceDiscovery(listener)
            } catch (_: Exception) {
            }
        }
    }

    private fun stageMessage(): String = when (stage) {
        Stage.DISCOVERING_PAIR -> text("Searching for Android’s pairing service…", "Mencari layanan pairing Android…")
        Stage.WAITING_CODE -> text("Enter the pairing code from Android in this notification.", "Masukkan kode pairing Android melalui notifikasi ini.")
        Stage.PAIRING -> text("Pairing with this phone…", "Melakukan pairing dengan HP ini…")
        Stage.DISCOVERING_CONNECT -> text("Pairing accepted. Finding ADB connection service…", "Pairing diterima. Mencari layanan koneksi ADB…")
        Stage.GRANTING -> text("Enabling requested Game FPS access…", "Mengaktifkan akses FPS Game…")
        Stage.FAILED -> text("Pairing needs attention. Tap Pair again to retry.", "Pairing perlu diperiksa. Tekan Pair lagi untuk mengulang.")
        Stage.FINISHED -> text("Pairing flow finished.", "Alur pairing selesai.")
        Stage.IDLE -> text("Ready to pair.", "Siap melakukan pairing.")
    }

    private fun createNotificationChannels() {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) return
        val manager = getSystemService(NotificationManager::class.java)
        manager.createNotificationChannel(
            NotificationChannel(
                CHANNEL_ID,
                text("JE Cooler Wireless ADB", "ADB Nirkabel JE Cooler"),
                NotificationManager.IMPORTANCE_HIGH,
            ).apply {
                description = text(
                    "User-started Wireless debugging pairing for Game FPS access.",
                    "Pairing Wireless debugging yang dimulai pengguna untuk akses FPS Game.",
                )
                setShowBadge(false)
                enableVibration(false)
                setSound(null, null)
            },
        )
        manager.createNotificationChannel(
            NotificationChannel(
                RESULT_CHANNEL_ID,
                text("JE Cooler ADB results", "Hasil ADB JE Cooler"),
                NotificationManager.IMPORTANCE_DEFAULT,
            ).apply {
                description = text(
                    "Result of the user-started local ADB pairing flow.",
                    "Hasil alur pairing ADB lokal yang dimulai pengguna.",
                )
                setShowBadge(false)
            },
        )
    }

    private fun startAsForeground(notification: Notification) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
            startForeground(
                NOTIFICATION_ID,
                notification,
                ServiceInfo.FOREGROUND_SERVICE_TYPE_SPECIAL_USE,
            )
        } else {
            startForeground(NOTIFICATION_ID, notification)
        }
    }

    private fun buildOngoingNotification(
        message: String,
        allowCodeInput: Boolean,
        port: Int,
        allowRetry: Boolean,
    ): Notification {
        val cancelIntent = Intent(this, WirelessAdbPairingService::class.java).setAction(ACTION_CANCEL)
        val cancelPending = servicePendingIntent(cancelIntent, REQUEST_CODE_CANCEL, mutable = false)
        val settingsIntent = Intent(Settings.ACTION_APPLICATION_DEVELOPMENT_SETTINGS)
            .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        val settingsPending = PendingIntent.getActivity(
            this,
            REQUEST_CODE_SETTINGS,
            settingsIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or immutableFlag(),
        )

        val builder = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            Notification.Builder(this, CHANNEL_ID)
        } else {
            @Suppress("DEPRECATION")
            Notification.Builder(this)
        }
        builder
            .setSmallIcon(R.drawable.ic_notification)
            .setContentTitle(text("JE Cooler · Wireless ADB", "JE Cooler · ADB Nirkabel"))
            .setContentText(message)
            .setStyle(Notification.BigTextStyle().bigText(message))
            .setCategory(Notification.CATEGORY_SERVICE)
            .setVisibility(Notification.VISIBILITY_PRIVATE)
            .setOngoing(true)
            .setOnlyAlertOnce(true)
            .setShowWhen(false)
            .setContentIntent(PendingIntent.getActivity(
                this,
                NOTIFICATION_ID,
                Intent(this, MainActivity::class.java).addFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP),
                PendingIntent.FLAG_UPDATE_CURRENT or immutableFlag(),
            ))
            .addAction(
                Notification.Action.Builder(
                    R.drawable.ic_notification,
                    text("Developer options", "Opsi developer"),
                    settingsPending,
                ).build(),
            )
            .addAction(
                Notification.Action.Builder(
                    R.drawable.ic_notification,
                    text("Cancel pairing", "Batalkan pairing"),
                    cancelPending,
                ).build(),
            )

        if (allowRetry) {
            val retryIntent = Intent(this, WirelessAdbPairingService::class.java)
                .setAction(ACTION_START)
                .putExtra(EXTRA_LANGUAGE, language)
            val retryPending = servicePendingIntent(retryIntent, REQUEST_CODE_RETRY, mutable = false)
            builder.addAction(
                Notification.Action.Builder(
                    R.drawable.ic_notification,
                    text("Pair again", "Pairing lagi"),
                    retryPending,
                ).build(),
            )
        }

        if (allowCodeInput && port in 1..65535) {
            val codeIntent = Intent(this, WirelessAdbPairingService::class.java)
                .setAction(ACTION_SUBMIT_CODE)
                .putExtra(EXTRA_PORT, port)
                .putExtra(EXTRA_LANGUAGE, language)
            val codePending = servicePendingIntent(codeIntent, REQUEST_CODE_INPUT, mutable = true)
            val remoteInput = RemoteInput.Builder(EXTRA_CODE)
                .setLabel(text("Six-digit pairing code", "Kode pairing enam digit"))
                .setAllowFreeFormInput(true)
                .build()
            builder.addAction(
                Notification.Action.Builder(
                    R.drawable.ic_notification,
                    text("Enter pairing code", "Masukkan kode pairing"),
                    codePending,
                ).addRemoteInput(remoteInput).build(),
            )
        }
        return builder.build()
    }

    private fun servicePendingIntent(intent: Intent, requestCode: Int, mutable: Boolean): PendingIntent {
        var flags = PendingIntent.FLAG_UPDATE_CURRENT
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            flags = flags or if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S && mutable) {
                PendingIntent.FLAG_MUTABLE
            } else {
                PendingIntent.FLAG_IMMUTABLE
            }
        }
        return PendingIntent.getForegroundService(this, requestCode, intent, flags)
    }

    private fun immutableFlag(): Int =
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) PendingIntent.FLAG_IMMUTABLE else 0

    private fun updateOngoing(message: String, allowCodeInput: Boolean, port: Int, allowRetry: Boolean) {
        try {
            getSystemService(NotificationManager::class.java)
                .notify(NOTIFICATION_ID, buildOngoingNotification(message, allowCodeInput, port, allowRetry))
        } catch (_: Exception) {
        }
    }

    private fun finishWithResult(success: Boolean, message: String) {
        stopDiscovery()
        cancelTimeout()
        pairingPort = 0
        stage = Stage.FINISHED
        val title = if (success) {
            text("Game FPS access enabled", "Akses FPS Game aktif")
        } else {
            text("Game FPS setup needs attention", "Pengaturan FPS Game perlu diperiksa")
        }
        val builder = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            Notification.Builder(this, RESULT_CHANNEL_ID)
        } else {
            @Suppress("DEPRECATION")
            Notification.Builder(this)
        }
        val notification = builder
            .setSmallIcon(R.drawable.ic_notification)
            .setContentTitle(title)
            .setContentText(message)
            .setStyle(Notification.BigTextStyle().bigText(message))
            .setCategory(Notification.CATEGORY_STATUS)
            .setAutoCancel(true)
            .setShowWhen(false)
            .setContentIntent(PendingIntent.getActivity(
                this,
                RESULT_NOTIFICATION_ID,
                Intent(this, MainActivity::class.java).addFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP),
                PendingIntent.FLAG_UPDATE_CURRENT or immutableFlag(),
            ))
            .build()
        try {
            getSystemService(NotificationManager::class.java).notify(RESULT_NOTIFICATION_ID, notification)
        } catch (_: Exception) {
        }
        stopForeground(STOP_FOREGROUND_REMOVE)
        stopSelf()
    }

    private fun cancelPairing() {
        cancelTimeout()
        stopDiscovery()
        stage = Stage.IDLE
        pairingPort = 0
        stopForeground(STOP_FOREGROUND_REMOVE)
        stopSelf()
    }

    private fun text(english: String, indonesian: String): String =
        if (language.equals("indonesia", ignoreCase = true)) indonesian else english

    override fun onBind(intent: Intent?): IBinder? = null

    override fun onDestroy() {
        cancelTimeout()
        stopDiscovery()
        worker.shutdownNow()
        super.onDestroy()
    }
}
