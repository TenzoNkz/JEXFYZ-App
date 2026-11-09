package com.horizontalzzz.jexfyz

// AI ANDROID MEMORY:
// This service only backs an already-active JE X FYZ BLE session when Flutter
// is backgrounded. It must never create a second GATT/BLE client.

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.Service
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.IBinder

// Connected-device foreground service used by the Flutter client.
class JeForegroundService : Service() {

    companion object {
        private const val CHANNEL_ID = "je_x_fyz_background"
        private const val NOTIFICATION_ID = 2110
        const val EXTRA_LANGUAGE = "language"

        // Keep channel labels current even while the foreground service is stopped.
        fun updateNotificationChannelLanguage(context: Context, language: String) {
            if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) return
            val manager = context.getSystemService(NotificationManager::class.java)
            val indonesia = language.equals("indonesia", ignoreCase = true)
            val channel = NotificationChannel(
                CHANNEL_ID,
                if (indonesia) "Layanan latar belakang perangkat" else "Device background service",
                NotificationManager.IMPORTANCE_LOW
            ).apply {
                description = if (indonesia)
                    "Menjaga koneksi Bluetooth perangkat tetap aktif saat aplikasi berada di latar belakang."
                else
                    "Keeps the device Bluetooth connection active while the app is in the background."
                setShowBadge(false)
                setSound(null, null)
                enableVibration(false)
            }
            manager.createNotificationChannel(channel)
        }
    }

    // Create the notification channel once for this service process.
    override fun onCreate() {
        super.onCreate()
        createNotificationChannel()
    }

    // Promote the service into connected-device foreground mode.
    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        val language = intent?.getStringExtra(EXTRA_LANGUAGE) ?: "english"
        createNotificationChannel(language)
        val notification = buildNotification(language)

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            startForeground(
                NOTIFICATION_ID,
                notification,
                android.content.pm.ServiceInfo.FOREGROUND_SERVICE_TYPE_CONNECTED_DEVICE
            )
        } else {
            startForeground(NOTIFICATION_ID, notification)
        }

        return START_NOT_STICKY
    }

    // Service is intentionally started rather than bound.
    override fun onBind(intent: Intent?): IBinder? = null

    // Define the low-importance persistent BLE-session notification.
    private fun createNotificationChannel(language: String = "english") {
        updateNotificationChannelLanguage(this, language)
    }

    // Build the ongoing foreground notification.
    private fun buildNotification(language: String): Notification {
        val builder = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            Notification.Builder(this, CHANNEL_ID)
        } else {
            @Suppress("DEPRECATION")
            Notification.Builder(this)
        }
        val indonesia = language.equals("indonesia", ignoreCase = true)
        val content = if (indonesia) {
            "Bluetooth terhubung · sesi perangkat aktif"
        } else {
            "Bluetooth connected · device session active"
        }

        return builder
            .setJexNotificationBranding(this)
            .setContentTitle(if (indonesia) "Perangkat" else "Device")
            .setContentText(content)
            .setOngoing(true)
            .setShowWhen(false)
            .setCategory(Notification.CATEGORY_SERVICE)
            .setContentIntent(jexNotificationContentIntent(this, NOTIFICATION_ID))
            .setPriority(Notification.PRIORITY_LOW)
            .build()
    }
}
