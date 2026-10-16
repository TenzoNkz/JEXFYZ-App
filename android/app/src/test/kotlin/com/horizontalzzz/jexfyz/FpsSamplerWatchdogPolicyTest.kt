package com.horizontalzzz.jexfyz

import org.junit.Assert.assertEquals
import org.junit.Assert.assertNull
import org.junit.Test

class FpsSamplerWatchdogPolicyTest {
    @Test
    fun startupGetsLongerBudgetThanSteadyStatePolling() {
        assertEquals(60_000L, FpsSamplerWatchdogPolicy.timeoutMs("starting"))
        assertEquals(30_000L, FpsSamplerWatchdogPolicy.timeoutMs("active"))
    }

    @Test
    fun reportsStartupTimeoutOnlyAtTheBoundary() {
        assertNull(FpsSamplerWatchdogPolicy.failureStatusIfStalled("starting", 59_999L))
        assertEquals(
            "sampler_start_timeout",
            FpsSamplerWatchdogPolicy.failureStatusIfStalled("starting", 60_000L),
        )
    }

    @Test
    fun detectsStalledFramePollingAndKeepsDistinctStatus() {
        assertNull(FpsSamplerWatchdogPolicy.failureStatusIfStalled("waiting_for_frames", 29_999L))
        assertEquals(
            "sampler_stalled",
            FpsSamplerWatchdogPolicy.failureStatusIfStalled("waiting_for_frames", 30_000L),
        )
        assertEquals(
            "sampler_stalled",
            FpsSamplerWatchdogPolicy.failureStatusIfStalled("active", 45_000L),
        )
    }

    @Test
    fun keepsForegroundAndMissingLayerStatesUnderWatchdog() {
        assertEquals(30_000L, FpsSamplerWatchdogPolicy.timeoutMs("foreground_unknown"))
        assertEquals(30_000L, FpsSamplerWatchdogPolicy.timeoutMs("no_layer_data"))
    }

    @Test
    fun doesNotWatchTerminalOrDisabledStates() {
        assertNull(FpsSamplerWatchdogPolicy.timeoutMs("monitor_off"))
        assertNull(FpsSamplerWatchdogPolicy.timeoutMs("shizuku_permission_missing"))
        assertNull(FpsSamplerWatchdogPolicy.failureStatusIfStalled("sampler_poll_exception", 90_000L))
    }
}
