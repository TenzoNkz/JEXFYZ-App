# AI SHRINKING MEMORY
# Release builds use R8/resource shrinking.
# Keep the native Activity because Android entry-point and MethodChannel access
# depend on this class remaining reachable after optimization.
# JE X FYZ release shrinking/obfuscation
# Keep the launcher Activity and its MethodChannels reachable.
-keep class com.horizontalzzz.jexfyz.MainActivity { *; }
# Shizuku dynamically creates the FPS UserService and invokes the generated AIDL Binder.
-keep class com.horizontalzzz.jexfyz.FpsShizukuUserService { *; }
-keep interface com.horizontalzzz.jexfyz.IFpsShizukuUserService { *; }
-keep class com.horizontalzzz.jexfyz.IFpsShizukuUserService$Stub { *; }
