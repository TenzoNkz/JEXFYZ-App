package com.horizontalzzz.jexfyz

import android.os.Bundle
import android.os.SystemClock
import android.system.Os
import androidx.annotation.Keep
import java.io.ByteArrayOutputStream
import java.nio.charset.Charset
import java.util.concurrent.atomic.AtomicBoolean

/** Restricted FPS bridge in Shizuku's approved Shell/Root process. No caller command is accepted. */
@Keep
class FpsShizukuUserService : IFpsShizukuUserService.Stub() {
    override fun executeFpsOperation(operation: Int): Bundle {
        val arguments = when (operation) {
            OP_START_CAPTURE -> listOf("SurfaceFlinger", "--timestats", "-clear", "-enable")
            OP_STOP_CAPTURE -> listOf("SurfaceFlinger", "--timestats", "-disable")
            OP_READ_FOREGROUND_ACTIVITY -> listOf("activity", "activities")
            OP_READ_SURFACEFLINGER_STATS -> listOf("SurfaceFlinger", "--timestats", "-dump")
            OP_READ_FOREGROUND_WINDOW -> listOf("window", "displays")
            else -> return result("", false, "unsupported_fps_operation")
        }
        return runFixedDumpsys(arguments)
    }

    @Keep
    override fun destroy() { System.exit(0) }

    override fun exit() { destroy() }

    private fun result(output: String, ok: Boolean, error: String? = null): Bundle =
        Bundle().apply {
            putString("output", output)
            putBoolean("ok", ok)
            putString("error", error)
            putInt("uid", runCatching { Os.getuid() }.getOrDefault(-1))
        }

    private fun runFixedDumpsys(arguments: List<String>): Bundle {
        val process = try {
            ProcessBuilder(listOf("/system/bin/dumpsys") + arguments)
                .redirectErrorStream(true)
                .start()
        } catch (_: Exception) {
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
            return result(snapshot(sink, sinkLock), false, "dumpsys_interrupted")
        }

        val output = snapshot(sink, sinkLock)
        if (timedOut.get()) return result(output, false, "dumpsys_timeout")
        if (oversized.get()) return result(output, false, "dumpsys_output_too_large")
        if (output.contains("Permission Denial", ignoreCase = true) ||
            output.contains("Permission denial", ignoreCase = true)
        ) return result(output, false, "surfaceflinger_blocked")
        if (exitCode != 0) return result(output, false, "dumpsys_exit_$exitCode")
        return result(output, true)
    }

    private fun snapshot(sink: ByteArrayOutputStream, lock: Any): String =
        synchronized(lock) { sink.toString(Charset.forName("UTF-8").name()) }

    companion object {
        const val OP_START_CAPTURE = 1
        const val OP_STOP_CAPTURE = 2
        const val OP_READ_FOREGROUND_ACTIVITY = 3
        const val OP_READ_SURFACEFLINGER_STATS = 4
        const val OP_READ_FOREGROUND_WINDOW = 5
        private const val COMMAND_TIMEOUT_MS = 2500L
        private const val MAX_OUTPUT_BYTES = 2 * 1024 * 1024
    }
}
