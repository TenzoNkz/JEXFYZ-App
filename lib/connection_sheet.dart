// AI-MEMORY / FILE CONTRACT
// Owns the manual Connection sheet UI, platform permission/status display and lifecycle refresh.
// Scan ownership and all scanner commands remain injected from Dashboard through callbacks.
// This widget observes FlutterBluePlus results but does not own BLE connection or P1 session state.

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import 'app_settings.dart' show JexText, appLanguageNotifier;
import 'connection_scan_state.dart';
import 'jex_animated_glyph.dart';
import 'jex_design_tokens.dart';

class ConnectionSheetContent extends StatefulWidget {
  final Future<bool> Function() onScan;
  final Future<void> Function(BluetoothDevice device) onConnect;
  final VoidCallback onDeviceSelected;
  final Future<void> Function() onOpenBluetoothSettings;
  final Future<void> Function() onOpenLocationSettings;
  final String serviceUuid;

  const ConnectionSheetContent({
    required this.onScan,
    required this.onConnect,
    required this.onDeviceSelected,
    required this.onOpenBluetoothSettings,
    required this.onOpenLocationSettings,
    required this.serviceUuid,
  });

  @override
  State<ConnectionSheetContent> createState() => _ConnectionSheetContentState();
}

class _ConnectionSheetContentState extends State<ConnectionSheetContent>
    with WidgetsBindingObserver {
  static const MethodChannel _channel = MethodChannel('je_x_fyz/battery_temp');

  Timer? _refreshTimer;
  bool _statusRefreshInFlight = false;
  bool _scanAttempted = false;
  bool _scanRequestInFlight = false;
  int _scanGeneration = 0;
  String? _scanErrorKey;
  BluetoothAdapterState _adapterState = BluetoothAdapterState.unknown;
  PermissionStatus _scanPermission = PermissionStatus.denied;
  PermissionStatus _connectPermission = PermissionStatus.denied;
  PermissionStatus _locationPermission = PermissionStatus.denied;
  bool _locationServiceEnabled = false;
  int _androidSdk = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    unawaited(_refreshStatus());
    _startStatusRefresh();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) unawaited(_requestScan());
    });
  }

  void _startStatusRefresh() {
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(
      const Duration(seconds: 3),
      (_) => unawaited(_refreshStatus()),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(_refreshStatus());
      _startStatusRefresh();
    } else {
      _refreshTimer?.cancel();
      _refreshTimer = null;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _refreshTimer?.cancel();
    super.dispose();
  }

  Future<void> _requestScan() async {
    if (!mounted || _scanRequestInFlight) return;
    setState(() {
      _scanAttempted = true;
      _scanRequestInFlight = true;
      _scanGeneration++;
      _scanErrorKey = null;
    });

    try {
      final started = await widget.onScan();
      if (!mounted) return;
      if (!started) {
        await _refreshStatus();
        if (!mounted) return;
        setState(() => _scanErrorKey = 'connectionAccessRequired');
      }
    } catch (error) {
      debugPrint('Connection scan: $error');
      if (mounted) setState(() => _scanErrorKey = 'scanFailed');
    } finally {
      if (mounted) setState(() => _scanRequestInFlight = false);
    }
  }

  Future<void> _refreshStatus() async {
    if (!Platform.isAndroid || !mounted || _statusRefreshInFlight) return;
    _statusRefreshInFlight = true;
    try {
      final adapter = await FlutterBluePlus.adapterState.first;
      final scan = await Permission.bluetoothScan.status;
      final connect = await Permission.bluetoothConnect.status;
      final location = await Permission.locationWhenInUse.status;
      final sdk = await _getAndroidSdkInt();

      bool locationService = false;
      try {
        locationService =
            await _channel.invokeMethod<bool>('isLocationServiceEnabled') ??
            false;
      } catch (_) {}

      if (!mounted) return;
      setState(() {
        _adapterState = adapter;
        _scanPermission = scan;
        _connectPermission = connect;
        _locationPermission = location;
        _androidSdk = sdk;
        _locationServiceEnabled = locationService;
      });
    } catch (e) {
      debugPrint('Connection status: $e');
    } finally {
      _statusRefreshInFlight = false;
    }
  }

  Future<int> _getAndroidSdkInt() async {
    try {
      return await _channel.invokeMethod<int>('getAndroidSdkInt') ?? 0;
    } catch (e) {
      debugPrint('Android SDK check: $e');
      return 0;
    }
  }

  bool get _bluetoothDenied =>
      !_scanPermission.isGranted || !_connectPermission.isGranted;

  bool get _bluetoothOn =>
      !_bluetoothDenied && _adapterState == BluetoothAdapterState.on;

  bool get _locationDenied =>
      _androidSdk > 0 && _androidSdk <= 30 && !_locationPermission.isGranted;

  bool get _locationOn => _locationServiceEnabled && !_locationDenied;

  Color _statusColor(bool on, bool denied) {
    if (denied) return const Color(0xFFFF6B7A);
    if (on) return const Color(0xFF63E6BE);
    return const Color(0xFFFFB74D);
  }

  Widget _indicator({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final indicatorBackground = dark ? const Color(0xFF191A22) : Colors.white;
    final indicatorForeground = dark ? Colors.white : const Color(0xFF16181D);
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Container(
            height: 42,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: indicatorBackground,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: color.withValues(alpha: 0.55),
                width: 1.1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                JexAnimatedGlyph(icon: icon, size: 18, color: color),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: indicatorForeground,
                      fontSize: 9.5,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _tapBluetooth() async {
    if (_bluetoothDenied) {
      // Explicit user action retries the Nearby Devices permission request.
      // Never redirect to App Settings merely because the previous request was denied.
      await _requestScan();
    } else {
      // Bluetooth power remains a manual OS action when the adapter is off.
      await widget.onOpenBluetoothSettings();
    }
    await Future<void>.delayed(const Duration(milliseconds: 250));
    await _refreshStatus();
  }

  Future<void> _tapLocation() async {
    if (_locationDenied) {
      await openAppSettings();
    } else {
      await widget.onOpenLocationSettings();
    }
    await Future<void>.delayed(const Duration(milliseconds: 250));
    await _refreshStatus();
  }

  @override
  Widget build(BuildContext context) {
    final lang = appLanguageNotifier.value;
    final scheme = Theme.of(context).colorScheme;
    final btColor = _statusColor(_bluetoothOn, _bluetoothDenied);
    final locationColor = _statusColor(_locationOn, _locationDenied);
    final locationRequired = _androidSdk > 0 && _androidSdk <= 30;

    return Material(
      color: scheme.jexSurface,
      child: Column(
        children: [
          Container(
            height: 60,
            padding: const EdgeInsets.fromLTRB(16, 6, 6, 4),
            decoration: BoxDecoration(
              color: scheme.jexElevatedSurface,
              border: Border(bottom: BorderSide(color: scheme.jexOutline)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    JexText.of('connection', lang),
                    style: TextStyle(
                      color: scheme.jexForeground,
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.15,
                    ),
                  ),
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints.tightFor(
                    width: 42,
                    height: 42,
                  ),
                  onPressed: () => Navigator.pop(context),
                  icon: JexAnimatedGlyph(
                    icon: PhosphorIconsRegular.x,
                    color: scheme.jexMutedForeground,
                    size: 22,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 8),
            child: Row(
              children: [
                _indicator(
                  label: _bluetoothOn
                      ? JexText.of('bluetoothOn', lang)
                      : JexText.of('bluetoothOff', lang),
                  icon: _bluetoothOn
                      ? PhosphorIconsRegular.bluetooth
                      : PhosphorIconsRegular.bluetoothSlash,
                  color: btColor,
                  onTap: _tapBluetooth,
                ),
                const SizedBox(width: 8),
                _indicator(
                  label: _locationOn
                      ? JexText.of('locationOn', lang)
                      : JexText.of('locationOff', lang),
                  icon: _locationOn
                      ? PhosphorIconsRegular.mapPin
                      : PhosphorIconsRegular.mapPin,
                  color: locationColor,
                  onTap: _tapLocation,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 8, 6),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    JexText.of('devices', lang),
                    style: TextStyle(
                      color: scheme.jexMutedForeground,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints.tightFor(
                    width: 40,
                    height: 40,
                  ),
                  tooltip: JexText.of('scan', lang),
                  onPressed: _requestScan,
                  icon: JexAnimatedGlyph(
                    icon: PhosphorIconsRegular.arrowClockwise,
                    color: const Color(0xFF5C9DFF),
                    size: 22,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<bool>(
              stream: FlutterBluePlus.isScanning,
              initialData: FlutterBluePlus.isScanningNow,
              builder: (context, scanSnapshot) {
                final pluginScanning =
                    scanSnapshot.data ?? FlutterBluePlus.isScanningNow;
                return StreamBuilder<List<ScanResult>>(
                  key: ValueKey<int>(_scanGeneration),
                  stream: FlutterBluePlus.onScanResults,
                  initialData: const [],
                  builder: (context, snapshot) {
                    final filtered = (snapshot.data ?? const <ScanResult>[])
                        .where((r) {
                          final serviceMatch = r.advertisementData.serviceUuids
                              .any(
                                (uuid) =>
                                    uuid.toString().toLowerCase() ==
                                    widget.serviceUuid,
                              );
                          final name = r.device.platformName
                              .trim()
                              .toLowerCase();
                          final advName = r.advertisementData.advName
                              .trim()
                              .toLowerCase();
                          return serviceMatch ||
                              name == 'je x fyz' ||
                              advName == 'je x fyz';
                        })
                        .toList();

                    if (filtered.isEmpty) {
                      final permissionRequired =
                          _bluetoothDenied || _locationDenied;
                      final bluetoothUnavailable =
                          _adapterState != BluetoothAdapterState.on ||
                          (locationRequired && !_locationServiceEnabled);
                      final scanning =
                          !_scanAttempted ||
                          _scanRequestInFlight ||
                          pluginScanning;
                      final errorKey = snapshot.hasError
                          ? 'scanFailed'
                          : _scanErrorKey;
                      final messageKey = connectionScanEmptyStateMessageKey(
                        permissionRequired: permissionRequired,
                        bluetoothUnavailable: bluetoothUnavailable,
                        scanning: scanning,
                        errorKey: errorKey,
                      );
                      final unavailable =
                          permissionRequired || bluetoothUnavailable;
                      final failed = errorKey == 'scanFailed';

                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            JexAnimatedGlyph(
                              icon: unavailable || failed
                                  ? PhosphorIconsRegular.bluetoothSlash
                                  : PhosphorIconsRegular.bluetooth,
                              color: unavailable
                                  ? btColor
                                  : failed
                                  ? scheme.error
                                  : const Color(0xFF5C9DFF),
                              size: 32,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              JexText.of(messageKey, lang),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: failed
                                    ? scheme.error
                                    : scheme.jexMutedForeground,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 10),
                            FilledButton.icon(
                              onPressed: unavailable || scanning
                                  ? null
                                  : _requestScan,
                              icon: JexAnimatedGlyph(
                                icon: PhosphorIconsRegular.arrowClockwise,
                                color: Theme.of(context).colorScheme.jexAccentForeground,
                                size: 16,
                              ),
                              label: Text(JexText.of('scan', lang)),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.fromLTRB(8, 2, 8, 12),
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) => Divider(
                        color: scheme.jexOutline.withValues(alpha: .55),
                        height: 1,
                      ),
                      itemBuilder: (_, index) {
                        final result = filtered[index];
                        final displayName = connectionDeviceDisplayName(
                          advertisedName: result.advertisementData.advName,
                          platformName: result.device.platformName,
                          fallback: JexText.of('device', lang),
                        );
                        return ListTile(
                          dense: true,
                          leading: JexAnimatedGlyph(
                            icon: PhosphorIconsRegular.bluetooth,
                            color: const Color(0xFF63E6BE),
                            size: 19,
                          ),
                          title: Text(
                            displayName,
                            style: TextStyle(
                              color: scheme.jexForeground,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          onTap: () async {
                            if (!context.mounted) return;
                            widget.onDeviceSelected();
                            Navigator.pop(context);
                            await widget.onConnect(result.device);
                          },
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
