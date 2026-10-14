package com.horizontalzzz.jexfyz

import android.app.Notification
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.os.Build

// Android status-bar small icons are monochrome masks. Use the dedicated X glyph there
// and the original full-color JE X FYZ launcher image as the large icon.
internal fun Notification.Builder.setJexNotificationBranding(context: Context): Notification.Builder {
    setSmallIcon(R.drawable.ic_notification)
    val source = BitmapFactory.decodeResource(context.resources, R.drawable.jexfyzicon)
    if (source != null) {
        val scaled = Bitmap.createScaledBitmap(source, 96, 96, true)
        setLargeIcon(scaled)
        if (scaled !== source) source.recycle()
    }
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
