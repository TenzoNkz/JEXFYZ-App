--- a/lib/main.dart
+++ b/lib/main.dart
@@
-const Icon(PhosphorIconsBold.bluetooth_searching, color: Colors.blueAccent, size: 34),
+const Icon(PhosphorIconsRegular.bluetooth, color: Colors.blueAccent, size: 34),

@@
-const Icon(PhosphorIconsBold.lock_outline, color: Colors.black26),
+const Icon(PhosphorIconsRegular.lock, color: Colors.black26),

@@
-Icon(PhosphorIconsBold.lock_rounded, size: 18, color: Colors.orangeAccent),
+Icon(PhosphorIconsBold.lock, size: 18, color: Colors.orangeAccent),

@@
-Icon(connected ? PhosphorIconsBold.bluetooth_connected : PhosphorIconsBold.bluetooth, color: connected ? Colors.blueAccent : Colors.white, size: 26),
+Icon(connected ? PhosphorIconsBold.bluetoothConnected : PhosphorIconsBold.bluetooth, color: connected ? Colors.blueAccent : Colors.white, size: 26),
