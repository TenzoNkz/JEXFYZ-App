package com.horizontalzzz.jexfyz

import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertTrue
import org.junit.Test

class FpsTimeStatsParserTest {
    @Test
    fun parsesAverageFpsAndKeepsSurfaceViewBlastLayer() {
        val dump = """
            layerName = com.example.game/com.example.game.MainActivity#20
            totalFrames = 10
            averageFPS = 20.0
            layerName = SurfaceView[com.example.game/com.example.game.MainActivity](BLAST)#42
            totalFrames = 30
            averageFPS = 59.8
            packageName = com.example.game
            layerName = com.other.app/com.other.app.MainActivity#1
            totalFrames = 50
            averageFPS = 60.0
        """.trimIndent()
        val layers = FpsTimeStatsParser.parseLines(dump)
        assertEquals(3, layers.size)
        val surface = layers[1]
        assertEquals(59.8, surface.averageFps, 0.001)
        assertEquals("com.example.game", surface.packageName)
        assertTrue(surface.hasUsableSample)
        assertTrue(surface.prefersSurfaceLayer)
        assertFalse(layers[2].name.contains("com.example.game/"))
    }

    @Test
    fun supportsLayerNameOnFollowingLine() {
        val dump = """
            layerName =
            SurfaceView[com.example.game/com.example.game.MainActivity](BLAST)#42
            totalFrames = 30
            averageFPS = 59.8
        """.trimIndent()
        val layers = FpsTimeStatsParser.parseLines(dump)
        assertEquals(1, layers.size)
        assertTrue(layers.single().name.startsWith("SurfaceView["))
        assertEquals(59.8, layers.single().averageFps, 0.001)
    }

    @Test
    fun rejectsInsufficientOrInvalidSamplesWithoutInventingFps() {
        val dump = """
            layerName = com.example.game/com.example.game.MainActivity#0
            totalFrames = 1
            averageFPS = 60.0
            layerName = com.example.game/com.example.game.MainActivity#1
            totalFrames = 20
            averageFPS = NaN
            layerName = com.example.game/com.example.game.MainActivity#2
            totalFrames = 20
            averageFPS = 900.0
        """.trimIndent()
        val layers = FpsTimeStatsParser.parseLines(dump)
        assertEquals(3, layers.size)
        assertTrue(layers.none { it.hasUsableSample })
        assertFalse(layers.first().hasUsableSample)
    }

    @Test
    fun distinguishesStaticZeroFromMissingOrInvalidFps() {
        val staticLayer = FpsTimeStatsLayer("com.example.game/Main#1", 2L, 0.0)
        val missingLayer = FpsTimeStatsLayer("com.example.game/Main#2", 10L, Double.NaN)
        assertTrue(staticLayer.hasUsableSample)
        assertEquals(0.0, staticLayer.averageFps, 0.001)
        assertFalse(missingLayer.hasUsableSample)
    }
}
