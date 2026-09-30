package com.horizontalzzz.jexfyz

// AI ANDROID MEMORY:
// Native bridge for Flutter. MethodChannel names are contracts with lib/main.dart.
// BLE/GATT ownership stays in flutter_blue_plus; this class must not create a second BLE client.

import android.app.Notification
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.content.pm.PackageManager
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
    // Production release-integrity bridge.
    private val SECURITY_CHANNEL = "je_x_fyz/security"
    private val NOTIFICATION_CHANNEL = "je_x_fyz/notifications"

    // Register every MethodChannel operation consumed by Dart.
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
                    result.success(startBackgroundService())
                }

                "stopBackgroundService" -> {
                    result.success(stopBackgroundService())
                }

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

                "requestNotificationPermission" -> {
                    result.success(requestNotificationPermission())
                }

                "showNotification" -> {
                    val args = call.arguments as? Map<*, *>
                    val title = args?.get("title")?.toString() ?: "JE X FYZ"
                    val body = args?.get("body")?.toString() ?: ""
                    val id = (args?.get("id") as? Number)?.toInt() ?: 2300
                    result.success(showUserNotification(title, body, id))
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
                else -> result.notImplemented()
            }
        }
    }

    // Start foreground support for an already-active BLE session.
    private fun startBackgroundService(): Boolean {
        return try {
            val intent = Intent(this, JeForegroundService::class.java)
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
    private fun stopBackgroundService(): Boolean {
        return try {
            stopService(Intent(this, JeForegroundService::class.java))
        } catch (_: Exception) {
            false
        }
    }

    // Compare the installed release certificate with the configured official certificate.
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

    // Android exposes battery temperature in tenths of a degree Celsius.
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
    private fun isLocationServiceEnabled(): Boolean {
        return try {
            val manager = getSystemService(Context.LOCATION_SERVICE) as LocationManager
            manager.isLocationEnabled
        } catch (_: Exception) {
            false
        }
    }

    // Launch Android Location settings.
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

    private fun ensureNotificationChannel() {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) return
        val manager = getSystemService(NotificationManager::class.java)
        val channel = NotificationChannel(
            NOTIFICATION_CHANNEL,
            "JE X FYZ Alerts",
            NotificationManager.IMPORTANCE_DEFAULT
        ).apply {
            description = "Important JE X FYZ safety, firmware, and Bluetooth notifications."
            setShowBadge(true)
        }
        manager.createNotificationChannel(channel)
    }

    private fun requestNotificationPermission(): Boolean {
        ensureNotificationChannel()
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.TIRAMISU) return true
        if (checkSelfPermission(Manifest.permission.POST_NOTIFICATIONS) ==
            PackageManager.PERMISSION_GRANTED
        ) {
            return true
        }
        requestPermissions(arrayOf(Manifest.permission.POST_NOTIFICATIONS), 2304)
        return false
    }

    private fun showUserNotification(title: String, body: String, id: Int): Boolean {
        ensureNotificationChannel()
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU &&
            checkSelfPermission(Manifest.permission.POST_NOTIFICATIONS) !=
            PackageManager.PERMISSION_GRANTED
        ) {
            return false
        }
        return try {
            val notification = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                Notification.Builder(this, NOTIFICATION_CHANNEL)
            } else {
                @Suppress("DEPRECATION")
                Notification.Builder(this)
            }
                .setSmallIcon(R.drawable.jexfyzicon)
                .setContentTitle(title)
                .setContentText(body)
                .setAutoCancel(true)
                .setShowWhen(true)
                .setPriority(Notification.PRIORITY_DEFAULT)
                .build()
            getSystemService(NotificationManager::class.java)
                .notify(id, notification)
            true
        } catch (_: Exception) {
            false
        }
    }

    // Launch Android Bluetooth settings.
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
