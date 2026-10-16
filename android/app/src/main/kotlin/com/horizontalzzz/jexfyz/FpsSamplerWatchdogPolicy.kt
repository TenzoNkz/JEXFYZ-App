package com.horizontalzzz.jexfyz

/**
 * Time budgets for detecting a sampler that stopped progressing. This policy is pure so
 * startup and poll-stall boundaries can be unit-tested without an Android device.
 */
internal object FpsSamplerWatchdogPolicy {
    const val CHECK_INTERVAL_MS = 5_000L
    const val STARTING_STALL_TIMEOUT_MS = 60_000L
    const val SAMPLE_STALL_TIMEOUT_MS = 30_000L

    fun timeoutMs(status: String): Long? = when (status) {
        "starting" -> STARTING_STALL_TIMEOUT_MS
        "active", "waiting_for_frames", "foreground_unknown", "no_layer_data", "sample_invalid" ->
            SAMPLE_STALL_TIMEOUT_MS
        else -> null
    }

    fun failureStatusIfStalled(status: String, idleMs: Long): String? {
        val timeout = timeoutMs(status) ?: return null
        if (idleMs < timeout) return null
        return if (status == "starting") "sampler_start_timeout" else "sampler_stalled"
    }
}
