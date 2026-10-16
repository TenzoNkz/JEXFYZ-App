package com.horizontalzzz.jexfyz

import android.os.Bundle
import android.os.SystemClock
import android.system.Os
import android.util.Log
import androidx.annotation.Keep
import java.io.ByteArrayOutputStream
import java.nio.charset.Charset
import java.util.concurrent.atomic.AtomicBoolean

/** Restricted FPS bridge in Shizuku's approved Shell/Root process. No caller command is accepted. */
@Keep
class FpsShizukuUserService : IFpsShizukuUserService.Stub() {
    init {
        Log.i(TAG, "user_service_started uid=${currentUid()}")
    }

    override fun executeFpsOperation(operation: Int): Bundle {
        val arguments = when (operation) {
            OP_START_CAPTURE -> listOf("SurfaceFlinger", "--timestats", "-clear", "-enable")
            OP_STOP_CAPTURE -> listOf("SurfaceFlinger", "--timestats", "-disable")
            OP_READ_FOREGROUND_ACTIVITY -> listOf("activity", "activities")
            OP_READ_SURFACEFLINGER_STATS -> listOf("SurfaceFlinger", "--timestats", "-dump", "-clear", "-maxlayers", "64")
            OP_READ_FOREGROUND_WINDOW -> listOf("window", "displays")
            OP_READ_FOREGROUND_WINDOW_FULL -> listOf("window")
            else -> return result("", false, "unsupported_fps_operation")
        }
        val name = operationName(arguments)
        Log.d(TAG, "operation_started id=$operation name=$name uid=${currentUid()}")
        return runFixedDumpsys(arguments, name)
    }

    @Keep
    override fun destroy() { System.exit(0) }

    override fun exit() { destroy() }

    private fun currentUid(): Int = runCatching { Os.getuid() }.getOrDefault(-1)

    private fun result(output: String, ok: Boolean, error: String? = null): Bundle =
        Bundle().apply {
            putString("output", output)
            putBoolean("ok", ok)
            putString("error", error)
            putInt("uid", currentUid())
        }

    private fun operationName(arguments: List<String>): String = when (arguments) {
        listOf("SurfaceFlinger", "--timestats", "-clear", "-enable") -> "capture_start"
        listOf("SurfaceFlinger", "--timestats", "-disable") -> "capture_stop"
        listOf("activity", "activities") -> "foreground_activity"
        listOf("SurfaceFlinger", "--timestats", "-dump", "-clear", "-maxlayers", "64") -> "surfaceflinger_stats"
        listOf("window", "displays") -> "foreground_window"
        listOf("window") -> "foreground_window_full"
        else -> "unknown_operation"
    }

    private fun runFixedDumpsys(arguments: List<String>, operation: String): Bundle {
        val startedAtMs = SystemClock.elapsedRealtime()
        val uid = currentUid()
        val process = try {
            ProcessBuilder(listOf("/system/bin/dumpsys") + arguments)
                .redirectErrorStream(true)
                .start()
        } catch (error: Exception) {
            Log.e(
                TAG,
                "command_start_failed operation=$operation uid=$uid exception=${error.javaClass.simpleName}",
            )
            return result("", false, "dumpsys_unavailable")
        }

        val sink = ByteArrayOutputStream()
        val sinkLock = Any()
        val timedOut = AtomicBoolean(false)
        val oversized = AtomicBoolean(false)
        val reader = Thread({
            try {
                process.inputStream.use { input ->
                    val buffer = ByteArray(8192)
                    while (true) {
                        val count = input.read(buffer)
                        if (count < 0) break
                        synchronized(sinkLock) {
                            if (sink.size() + count > MAX_OUTPUT_BYTES) {
                                oversized.set(true)
                                process.destroy()
                                break
                            }
                            sink.write(buffer, 0, count)
                        }
                    }
                }
            } catch (_: Exception) {
                // Process termination ends the reader.
            }
        }, "JEXFYZ-FPS-Dumpsys-Reader").apply { isDaemon = true }
        reader.start()

        var exitCode = -1
        val deadline = SystemClock.elapsedRealtime() + COMMAND_TIMEOUT_MS
        try {
            while (true) {
                if (oversized.get()) {
                    process.destroy()
                    break
                }
                try {
                    exitCode = process.exitValue()
                    break
                } catch (_: IllegalThreadStateException) {
                    if (SystemClock.elapsedRealtime() >= deadline) {
                        timedOut.set(true)
                        process.destroy()
                        break
                    }
                    Thread.sleep(15)
                }
            }
            reader.join(500)
        } catch (_: InterruptedException) {
            Thread.currentThread().interrupt()
            process.destroy()
            val output = snapshot(sink, sinkLock)
            Log.w(
                TAG,
                "command_interrupted operation=$operation uid=$uid outputChars=${output.length}",
            )
            return result(output, false, "dumpsys_interrupted")
        }

        val output = snapshot(sink, sinkLock)
        val elapsedMs = SystemClock.elapsedRealtime() - startedAtMs
        val permissionDenied = Regex(
            """permission\s+(?:denial|denied)|not allowed|requires\s+android\.permission\.DUMP""",
            RegexOption.IGNORE_CASE,
        ).containsMatchIn(output)
        val permissionError = if (operation == "capture_start" ||
            operation == "capture_stop" ||
            operation == "surfaceflinger_stats"
        ) {
            "surfaceflinger_blocked"
        } else {
            "dumpsys_permission_denied"
        }
        val error = when {
            timedOut.get() -> "dumpsys_timeout"
            oversized.get() -> "dumpsys_output_too_large"
            permissionDenied -> permissionError
            exitCode != 0 -> "dumpsys_exit_$exitCode"
            else -> null
        }
        Log.println(
            if (error == null) Log.DEBUG else Log.WARN,
            TAG,
            "command_finished operation=$operation uid=$uid exitCode=$exitCode " +
                "ok=${error == null} error=${error ?: "none"} outputChars=${output.length} durationMs=$elapsedMs",
        )
        return if (error == null) result(output, true) else result(output, false, error)
    }

    private fun snapshot(sink: ByteArrayOutputStream, lock: Any): String =
        synchronized(lock) { sink.toString(Charset.forName("UTF-8").name()) }

    companion object {
        const val OP_START_CAPTURE = 1
        const val OP_STOP_CAPTURE = 2
        const val OP_READ_FOREGROUND_ACTIVITY = 3
        const val OP_READ_SURFACEFLINGER_STATS = 4
        const val OP_READ_FOREGROUND_WINDOW = 5
        const val OP_READ_FOREGROUND_WINDOW_FULL = 6
        private const val COMMAND_TIMEOUT_MS = 5000L
        private const val TAG = "JexFpsDiag"
        private const val MAX_OUTPUT_BYTES = 2 * 1024 * 1024
    }
}
