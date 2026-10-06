package com.horizontalzzz.jexfyz

// AI ANDROID MEMORY:
// This service only backs an already-active JE X FYZ BLE session when Flutter
// is backgrounded. It must never create a second GATT/BLE client.

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.Service
import android.content.Intent
import android.os.Build
import android.os.IBinder

// Connected-device foreground service used by the Flutter client.
class JeForegroundService : Service() {

    companion object {
        private const val CHANNEL_ID = "je_x_fyz_background"
        private const val NOTIFICATION_ID = 2101
    }

    // Create the notification channel once for this service process.
    override fun onCreate() {
        super.onCreate()
        createNotificationChannel()
    }

    // Promote the service into connected-device foreground mode.
    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        val notification = buildNotification()

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
    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) return

        val manager = getSystemService(NotificationManager::class.java)
        val channel = NotificationChannel(
            CHANNEL_ID,
            "JE X FYZ Background",
            NotificationManager.IMPORTANCE_LOW
        ).apply {
            description = "Keeps the JE X FYZ BLE session active while the app is in the background."
            setShowBadge(false)
            setSound(null, null)
            enableVibration(false)
        }
        manager.createNotificationChannel(channel)
    }

    // Build the ongoing foreground notification.
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
            .setContentText("")
            .setOngoing(true)
            .setShowWhen(false)
            .setPriority(Notification.PRIORITY_LOW)
            .build()
    }
}
