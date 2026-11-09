# R8/ProGuard keep rules for Android integration points that require stable runtime discovery.
# Keep this file aligned with the native bridge/services and validate any rule change in an authorized App Build.

# AI SHRINKING MEMORY
# Release builds use R8/resource shrinking.
# Keep the native Activity because Android entry-point and MethodChannel access
# depend on this class remaining reachable after optimization.
# JE X FYZ release shrinking/obfuscation
# Keep the launcher Activity and its MethodChannels reachable.
-keep class com.horizontalzzz.jexfyz.MainActivity { *; }
