package com.horizontalzzz.jexfyz

internal data class FpsTimeStatsLayer(
    val name: String,
    val totalFrames: Long,
    val averageFps: Double,
    val packageName: String? = null,
) {
    val hasUsableSample: Boolean
        get() = totalFrames >= 2L && averageFps.isFinite() && averageFps in 0.0..480.0

    val prefersSurfaceLayer: Boolean
        get() = name.contains("SurfaceView", ignoreCase = true) ||
            name.contains("BLAST", ignoreCase = true)
}

internal object FpsTimeStatsParser {
    private val layerNamePattern = Regex("""^\s*layerName\s*=\s*(.*?)\s*$""")
    private val framePattern = Regex("""^\s*totalFrames\s*=\s*(\d+)\s*$""")
    private val averageFpsPattern = Regex("""^\s*averageFPS\s*=\s*(\S+)\s*$""")
    private val packagePattern = Regex("""^\s*packageName\s*=\s*(.*?)\s*$""")

    fun parseLines(output: String): List<FpsTimeStatsLayer> {
        val parsed = mutableListOf<FpsTimeStatsLayer>()
        var currentName: String? = null
        var waitingForName = false
        var currentFrames: Long? = null
        var currentFps = Double.NaN
        var currentPackage: String? = null

        fun flush() {
            val name = currentName?.trim()?.trim('"', ',')?.takeIf { it.isNotEmpty() } ?: return
            val frames = currentFrames ?: return
            parsed.add(FpsTimeStatsLayer(name, frames, currentFps, currentPackage))
        }

        for (raw in output.lineSequence()) {
            val line = raw.trim()
            if (line.isEmpty()) continue
            val nameMatch = layerNamePattern.matchEntire(line)
            if (nameMatch != null) {
                flush()
                val rawName = nameMatch.groupValues[1].trim().trim('"', ',')
                currentName = rawName.takeIf { it.isNotEmpty() }
                waitingForName = currentName == null
                currentFrames = null
                currentFps = Double.NaN
                currentPackage = null
                continue
            }

            if (waitingForName) {
                if (!line.startsWith("totalFrames") &&
                    !line.startsWith("averageFPS") &&
                    !line.startsWith("packageName")
                ) {
                    currentName = line.trim('"', ',').takeIf { it.isNotEmpty() }
                    waitingForName = currentName == null
                    continue
                }
            }
            if (currentName == null) continue

            val frameMatch = framePattern.matchEntire(line)
            if (frameMatch != null) {
                currentFrames = frameMatch.groupValues[1].toLongOrNull()
                continue
            }
            val fpsMatch = averageFpsPattern.matchEntire(line)
            if (fpsMatch != null) {
                currentFps = fpsMatch.groupValues[1].toDoubleOrNull() ?: Double.NaN
                continue
            }
            val packageMatch = packagePattern.matchEntire(line)
            if (packageMatch != null) {
                currentPackage = packageMatch.groupValues[1].trim().trim('"', ',')
                    .takeIf { it.isNotEmpty() && it != "null" }
            }
        }
        flush()
        return parsed.distinctBy { it.name }
    }
}
