package com.horizontalzzz.jexfyz

import android.app.Notification
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.os.Build

// The monochrome JE X FYZ monogram is the sole notification icon. Intentionally no large icon.
@Suppress("UNUSED_PARAMETER")
internal fun Notification.Builder.setJexNotificationBranding(context: Context): Notification.Builder {
    setSmallIcon(R.drawable.ic_notification)
    return this
}

// A notification tap returns to JE Cooler without starting a new BLE client.
internal fun jexNotificationContentIntent(
    context: Context,
    requestCode: Int,
): PendingIntent {
    val intent = Intent(context, MainActivity::class.java).apply {
        flags = Intent.FLAG_ACTIVITY_CLEAR_TOP or Intent.FLAG_ACTIVITY_SINGLE_TOP
    }
    val flags = PendingIntent.FLAG_UPDATE_CURRENT or
        (if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) PendingIntent.FLAG_IMMUTABLE else 0)
    return PendingIntent.getActivity(context, requestCode, intent, flags)
}
