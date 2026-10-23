package com.horizontalzzz.jexfyz

// AI-MEMORY / FILE CONTRACT
// File: MainActivity.kt
// Owns: Flutter MethodChannel host bridge and Android Settings/system utility entry points.
// Overlay contract: Activity opens public Android overlay settings; FloatingMonitorService owns
// the actual WindowManager overlay and foreground service.
// Cross-OEM strategy: use public Settings actions with explicit fallback, never hidden APIs or
// hardcoded vendor AppOps as the default path.
// BLE contract: this file must not create a second BLE/GATT client.
// Build target: compileSdk 37 / targetSdk 36 / minSdk 24.

// AI ANDROID MEMORY:
// Native bridge for Flutter. MethodChannel names are contracts with lib/main.dart.
// BLE/GATT ownership stays in flutter_blue_plus; this class must not create a second BLE client.

import android.app.Notification
import android.content.Context
import android.content.pm.PackageManager
import android.content.Intent
import android.content.IntentFilter
import android.net.Uri
import android.os.Bundle
import android.location.LocationManager
import android.os.BatteryManager
import android.os.Build
import android.provider.Settings
import android.util.Base64
import android.app.NotificationChannel
import android.app.NotificationManager
import android.Manifest
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

// Native host for the JE Cooler Flutter application.
class MainActivity : FlutterActivity() {

    // Battery/location/settings/background-service bridge.
    private val CHANNEL = "je_x_fyz/battery_temp"
    // Dedicated Floating Monitor bridge. Flutter's FloatingBridge uses this exact channel.
    private val FLOATING_CHANNEL = "je_x_fyz/floating"
    // Production release-integrity bridge.
    private val SECURITY_CHANNEL = "je_x_fyz/security"
    private val NOTIFICATION_CHANNEL = "je_x_fyz/notifications"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "getBatteryTemperature" -> {
                    result.success(readBatteryTemperature())
                }

                "openLocationSettings" -> {
                    result.success(openLocationSettings())
                }

                "isLocationServiceEnabled" -> {
                    result.success(isLocationServiceEnabled())
                }

                "getAndroidSdkInt" -> {
                    result.success(Build.VERSION.SDK_INT)
                }

                "openBluetoothSettings" -> {
                    result.success(openBluetoothSettings())
                }

                "startBackgroundService" -> {
                    val args = call.arguments as? Map<*, *>
                    val language = args?.get("language")?.toString() ?: "english"
                    result.success(startBackgroundService(language))
                }

                "stopBackgroundService" -> {
                    result.success(stopBackgroundService())
                }

                else -> result.notImplemented()
            }
        }

        // AI-METHOD / FLOATING-CHANNEL-CONTRACT
        // Keep every Floating Monitor method on the channel declared by FloatingBridge.
        // This prevents MissingPluginException caused by mixing overlay calls with the
        // battery/system utility channel.
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            FLOATING_CHANNEL
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "hasOverlayPermission" -> {
                    result.success(Settings.canDrawOverlays(this))
                }

                "openOverlaySettings" -> {
                    result.success(openOverlaySettings())
                }

                "startFloatingMonitor" -> {
                    val json = call.arguments?.toString() ?: "{}"
                    result.success(FloatingMonitorService.start(this, json))
                }

                "stopFloatingMonitor" -> {
                    FloatingMonitorService.stop(this)
                    result.success(true)
                }

                "updateFloatingConfig" -> {
                    FloatingMonitorService.updateConfig(
                        this,
                        call.arguments?.toString() ?: "{}"
                    )
                    result.success(true)
                }

                "updateFloatingData" -> {
                    FloatingMonitorService.updateData(
                        this,
                        call.arguments?.toString() ?: "{}"
                    )
                    result.success(true)
                }

                "getFloatingRuntimeState" -> {
                    result.success(FloatingMonitorService.runtimeState(this))
                }

                else -> result.notImplemented()
            }
        }

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            SECURITY_CHANNEL
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "isOfficialBuild" -> result.success(isOfficialBuild())
                "openDeveloperContact" -> result.success(openDeveloperContact())
                else -> result.notImplemented()
            }
        }

        // AI-METHOD / NOTIFICATION-CHANNEL-CONTRACT
        // Flutter notification calls use this exact dedicated channel.
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            NOTIFICATION_CHANNEL
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "requestNotificationPermission" -> {
                    val args = call.arguments as? Map<*, *>
                    val language = args?.get("language")?.toString() ?: "english"
                    result.success(requestNotificationPermission(language))
                }

                "updateNotificationChannelLanguage" -> {
                    val args = call.arguments as? Map<*, *>
                    val language = args?.get("language")?.toString() ?: "english"
                    ensureNotificationChannel(language)
                    result.success(true)
                }

                "showNotification" -> {
                    val args = call.arguments as? Map<*, *>
                    val language = args?.get("language")?.toString() ?: "english"
                    val defaultTitle = if (language.equals("indonesia", ignoreCase = true)) "Perangkat" else "Device"
                    val title = args?.get("title")?.toString() ?: defaultTitle
                    val body = args?.get("body")?.toString() ?: ""
                    val id = (args?.get("id") as? Number)?.toInt() ?: 2300
                    result.success(showUserNotification(title, body, id, language))
                }

                else -> result.notImplemented()
            }
        }
    }

    // Start foreground support for an already-active BLE session.
    // AI-METHOD / BACKGROUND-SERVICE-CONTRACT
    // Start the existing BLE-support foreground service without taking BLE ownership away from Flutter.
    private fun startBackgroundService(language: String): Boolean {
        return try {
            val intent = Intent(this, JeForegroundService::class.java).apply {
                putExtra(JeForegroundService.EXTRA_LANGUAGE, language)
            }
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                startForegroundService(intent)
            } else {
                startService(intent)
            }
            true
        } catch (_: Exception) {
            false
        }
    }

    // Stop foreground support after BLE teardown.
    // AI-METHOD / BACKGROUND-SERVICE-CONTRACT
    // Stop the existing BLE-support foreground service after the Flutter BLE session ends.
    private fun stopBackgroundService(): Boolean {
        return try {
            stopService(Intent(this, JeForegroundService::class.java))
        } catch (_: Exception) {
            false
        }
    }

    // Compare the installed release certificate with the configured official certificate.
    // AI-METHOD / RELEASE-INTEGRITY-CONTRACT
    // Verify the installed release certificate against the configured production signing identity.
    private fun isOfficialBuild(): Boolean {
        // Local debug builds are intentionally allowed for development.
        if (BuildConfig.DEBUG) {
            return true
        }

        val expected = BuildConfig.OFFICIAL_SIGNING_CERT_B64.trim()
        if (expected.isEmpty()) {
            // A release APK without the configured production signing identity
            // is never treated as an official build.
            return false
        }

        return try {
            val signatures = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
                val packageInfo = packageManager.getPackageInfo(
                    packageName,
                    PackageManager.GET_SIGNING_CERTIFICATES
                )
                packageInfo.signingInfo?.apkContentsSigners?.toList().orEmpty()
            } else {
                @Suppress("DEPRECATION")
                packageManager.getPackageInfo(
                    packageName,
                    PackageManager.GET_SIGNATURES
                ).signatures?.toList().orEmpty()
            }

            signatures.any { signature ->
                val actual = Base64.encodeToString(
                    signature.toByteArray(),
                    Base64.NO_WRAP
                )
                actual == expected
            }
        } catch (_: Exception) {
            false
        }
    }

    // Open the developer contact URL from the intentionally terse warning screen.
    // Keep the account out of rendered UI; Android may route the URL to Telegram or a browser.
    private fun openDeveloperContact(): Boolean {
        return try {
            startActivity(Intent(Intent.ACTION_VIEW, Uri.parse("https://t.me/horizontalzzz")))
            true
        } catch (_: Exception) {
            false
        }
    }

    // Android exposes battery temperature in tenths of a degree Celsius.
    // AI-METHOD / BATTERY-TEMPERATURE-CONTRACT
    // Read Android battery temperature in Celsius; return -1.0 for unavailable/invalid readings.
    private fun readBatteryTemperature(): Double {
        return try {
            val filter = IntentFilter(Intent.ACTION_BATTERY_CHANGED)
            val batteryIntent = registerReceiver(null, filter)

            val rawTemp = batteryIntent?.getIntExtra(
                BatteryManager.EXTRA_TEMPERATURE,
                Int.MIN_VALUE
            ) ?: Int.MIN_VALUE

            if (rawTemp == Int.MIN_VALUE) {
                return -1.0
            }

            val temperature = rawTemp / 10.0

            if (temperature < 0.0 || temperature > 100.0) {
                -1.0
            } else {
                temperature
            }
        } catch (_: Exception) {
            -1.0
        }
    }

    // Legacy Android BLE scanning compatibility check.
    // AI-METHOD / LOCATION-CONTRACT
    // Report the public Android location-service state used by legacy BLE scanning checks.
    private fun isLocationServiceEnabled(): Boolean {
        return try {
            val manager = getSystemService(Context.LOCATION_SERVICE) as LocationManager
            manager.isLocationEnabled
        } catch (_: Exception) {
            false
        }
    }

    // Launch Android Location settings.
    // AI-METHOD / LOCATION-SETTINGS-CONTRACT
    // Open the public Android location settings page; return false only when Activity launch fails.
    private fun openLocationSettings(): Boolean {
        return try {
            val intent = Intent(Settings.ACTION_LOCATION_SOURCE_SETTINGS)
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            startActivity(intent)
            true
        } catch (_: Exception) {
            false
        }
    }

    // Open the most appropriate public Android Settings page for overlay permission.
    // OEM Settings implementations vary, so use a small public-API fallback ladder
    // instead of depending on one Settings activity.
    // AI-METHOD / OVERLAY-SETTINGS-CONTRACT
    // Try public overlay Settings in order: app-specific overlay, generic overlay, then App Details.
    // resolveActivity() prevents avoidable failures; try/catch protects OEM Settings implementations.
    private fun openOverlaySettings(): Boolean {
        val intents = listOf(
            Intent(
                Settings.ACTION_MANAGE_OVERLAY_PERMISSION,
                android.net.Uri.parse("package:$packageName")
            ),
            Intent(Settings.ACTION_MANAGE_OVERLAY_PERMISSION),
            Intent(
                Settings.ACTION_APPLICATION_DETAILS_SETTINGS,
                android.net.Uri.parse("package:$packageName")
            ),
        )

        for (intent in intents) {
            try {
                if (intent.resolveActivity(packageManager) == null) continue
                startActivity(intent)
                return true
            } catch (_: Exception) {
                // Try the next public fallback on OEM implementations that reject
                // or fail to resolve the previous Settings activity.
            }
        }

        return false
    }

    // AI-METHOD / NOTIFICATION-CHANNEL-CONTRACT
    // Create the user-alert notification channel once; safe to call repeatedly.
    private fun ensureNotificationChannel(language: String = "english") {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) return
        val manager = getSystemService(NotificationManager::class.java)
        val indonesia = language.equals("indonesia", ignoreCase = true)
        val channel = NotificationChannel(
            NOTIFICATION_CHANNEL,
            if (indonesia) "Notifikasi perangkat" else "Device alerts",
            NotificationManager.IMPORTANCE_DEFAULT
        ).apply {
            description = if (indonesia)
                "Peringatan keselamatan, firmware, dan Bluetooth dari perangkat."
            else
                "Safety, firmware, and Bluetooth alerts from your device."
            setShowBadge(true)
        }
        manager.createNotificationChannel(channel)
    }

    // AI-METHOD / NOTIFICATION-PERMISSION-CONTRACT
    // Request POST_NOTIFICATIONS on Android 13+; older versions require no runtime prompt.
    private fun requestNotificationPermission(language: String = "english"): Boolean {
        ensureNotificationChannel(language)
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.TIRAMISU) return true
        if (checkSelfPermission(Manifest.permission.POST_NOTIFICATIONS) ==
            PackageManager.PERMISSION_GRANTED
        ) {
            return true
        }
        requestPermissions(arrayOf(Manifest.permission.POST_NOTIFICATIONS), 2304)
        return false
    }

    // AI-METHOD / USER-NOTIFICATION-CONTRACT
    // Publish one user notification when POST_NOTIFICATIONS is granted.
    private fun showUserNotification(title: String, body: String, id: Int, language: String): Boolean {
        ensureNotificationChannel(language)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU &&
            checkSelfPermission(Manifest.permission.POST_NOTIFICATIONS) !=
            PackageManager.PERMISSION_GRANTED
        ) {
            // Ask on the first real notification attempt rather than dropping alerts silently.
            requestNotificationPermission(language)
            return false
        }
        return try {
            val notification = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                Notification.Builder(this, NOTIFICATION_CHANNEL)
            } else {
                @Suppress("DEPRECATION")
                Notification.Builder(this)
            }
                .setJexNotificationBranding(this)
                .setContentTitle(title)
                .setContentText(body)
                .setAutoCancel(true)
                .setShowWhen(true)
                .setPriority(Notification.PRIORITY_DEFAULT)
                .setCategory(Notification.CATEGORY_EVENT)
                .setContentIntent(jexNotificationContentIntent(this, id))
                .build()
            getSystemService(NotificationManager::class.java)
                .notify(id, notification)
            true
        } catch (_: Exception) {
            false
        }
    }

    // Launch Android Bluetooth settings.
    // AI-METHOD / BLUETOOTH-SETTINGS-CONTRACT
    // Open the public Android Bluetooth settings page without creating a second BLE implementation.
    private fun openBluetoothSettings(): Boolean {
        return try {
            val intent = Intent(Settings.ACTION_BLUETOOTH_SETTINGS)
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            startActivity(intent)
            true
        } catch (_: Exception) {
            false
        }
    }
}
