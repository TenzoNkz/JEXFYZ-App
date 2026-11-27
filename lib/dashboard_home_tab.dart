// AI-MEMORY / FILE CONTRACT
// Home layout and presentation only. Dashboard State remains the owner of
// telemetry, notifications, BLE/P1/session, persistence and device commands.
part of 'main.dart';

extension _DashboardHomeTabBuilder on _DashboardScreenState {
  // AI-METHOD / HOME-CONTRACT
  // Build Home from live firmware/phone telemetry. Power states use JexText;
  // Fan Speed remains visible; its presentation reports OFF/MATI when Fan is OFF.
  // This function owns presentation only, not device-state authority.
  Widget _buildHomeArea(double height) {
    final batteryValue = connected && phoneBatteryValid
        ? phoneBatteryTemp
        : '--';
    final hotValue = connected ? hotsideTemp : '--';
    final voltageValue = connected && voltage != '--' ? voltage : '--';
    final adaptiveValue = connected
        ? JexText.of(adaptiveOn ? 'on' : 'off', appLanguageNotifier.value)
        : '--';
    final headerDark = appThemeNotifier.value != AppThemePreset.light;
    final headerForeground = headerDark
        ? const Color(0xFFF7F8FC)
        : const Color(0xFF16181D);

    return SizedBox(
      width: double.infinity,
      height: height,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 4, 12, 5),
        child: Column(
          children: [
            SizedBox(
              height: 48,
              child: Row(
                children: [
                  SizedBox(
                    width: 48,
                    child: Center(
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints.tightFor(
                          width: 48,
                          height: 48,
                        ),
                        tooltip: connected
                            ? JexText.of(
                                'disconnect',
                                appLanguageNotifier.value,
                              )
                            : JexText.of(
                                'bluetooth',
                                appLanguageNotifier.value,
                              ),
                        icon: JexAnimatedIcon(
                          kind: JexAnimatedIconKind.bluetooth,
                          color: connected
                              ? const Color(0xFF4D8CFF)
                              : headerForeground,
                          size: 25,
                          connected: connected,
                          active: jexIconAnimationPermitted(
                            connected: connected,
                            kind: JexAnimatedIconKind.bluetooth,
                            stateActive: true,
                          ),
                        ),
                        onPressed: connected ? _disconnect : _showBluetoothMenu,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          headerName,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: headerForeground,
                            fontWeight: FontWeight.w900,
                            fontSize: 19,
                            letterSpacing: 0.2,
                          ),
                        ),
                        SizedBox(height: 1),
                        Text(
                          JexText.of(
                            'developedByHorizon',
                            appLanguageNotifier.value,
                          ),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: headerDark
                                ? const Color(0xFF737986)
                                : const Color(0xFF40444D),
                            fontWeight: FontWeight.w700,
                            fontSize: 6.8,
                            letterSpacing: 1.25,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 48,
                    child: Center(
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints.tightFor(
                          width: 48,
                          height: 48,
                        ),
                        tooltip: JexText.of(
                          'settings',
                          appLanguageNotifier.value,
                        ),
                        icon: JexAnimatedGlyph(
                          icon: PhosphorIconsRegular.gear,
                          color: headerForeground,
                          size: 25,
                        ),
                        onPressed: _openSettings,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 2),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 10,
                    child: FractionallySizedBox(
                      widthFactor: 0.96,
                      alignment: Alignment.centerLeft,
                      child: Transform.translate(
                        offset: const Offset(-3, 0),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 2, right: 4),
                          child: Column(
                            children: [
                              _homeMetric(
                                JexText.of('batteryTemperature'),
                                batteryValue,
                                batteryValue == '--' ? '' : '°C',
                                color: jexThermalBatteryColor(batteryValue),
                                icon: PhosphorIconsRegular.batteryHigh,
                                animatedKind: JexAnimatedIconKind.battery,
                                continuousLoop: false,
                                level: jexThermalBatteryLevel(batteryValue),
                                warning: jexThermalBatteryFireActive(
                                  batteryValue,
                                ),
                              ),
                              _homeMetric(
                                JexText.of('hotsideTemperature'),
                                hotValue,
                                hotValue == '--' ? '' : '°C',
                                color: jexHotsideTemperatureColor(
                                  hotValue,
                                  hotLimit: hotLimit.toDouble(),
                                ),
                                icon: PhosphorIconsRegular.thermometer,
                                animatedKind: JexAnimatedIconKind.hotside,
                                continuousLoop: false,
                                level: jexTemperatureIndicatorLevel(
                                  hotValue,
                                  minC: 30,
                                  maxC: hotLimit.toDouble(),
                                  fallback: 0,
                                ),
                                warning:
                                    connected &&
                                    jexHotsideFireActive(
                                      hotValue,
                                      hotLimit: hotLimit.toDouble(),
                                    ),
                              ),
                              _homeMetric(
                                JexText.of('voltageIndicator'),
                                voltageValue,
                                '',
                                color: jexVoltageIndicatorColor(voltageValue),
                                icon: PhosphorIconsRegular.lightning,
                                animatedKind: JexAnimatedIconKind.voltage,
                                continuousLoop: false,
                                level: jexVoltageEnergyLevel(voltageValue),
                                voltageLevel: jexVoltageAnimationLevel(
                                  voltageValue,
                                ),
                              ),
                              _homeMetric(
                                JexText.of('adaptiveMode'),
                                adaptiveValue,
                                '',
                                color: const Color(0xFFC05BFF),
                                icon: PhosphorIconsRegular.sparkle,
                                animatedKind: JexAnimatedIconKind.adaptive,
                                animationActive:
                                    connected &&
                                    runtimeOutputsKnown &&
                                    adaptiveOn,
                                level: adaptiveOn ? 1.0 : 0.0,
                              ),
                              _homeStateChip(
                                label: JexText.of('peltierSwitch'),
                                value: peltierOn,
                                icon: PhosphorIconsRegular.snowflake,
                                color: const Color(0xFF18DFFF),
                                animatedKind: JexAnimatedIconKind.peltier,
                              ),
                              _homeStateChip(
                                label: JexText.of('fanSwitch'),
                                value: fanOn,
                                icon: PhosphorIconsRegular.fan,
                                color: const Color(0xFF38E3AD),
                                animatedKind: JexAnimatedIconKind.fan,
                              ),
                              _homeFanSpeed(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    // Give the cooler more horizontal room without compressing
                    // the telemetry column enough to break its compact labels.
                    flex: 14,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final imageHeight = (constraints.maxHeight * 0.99)
                              .clamp(240.0, 430.0)
                              .toDouble();
                          return Padding(
                            padding: const EdgeInsets.only(left: 2, right: 0),
                            // Uniform enlargement keeps the square cooler artwork
                            // undistorted and lets its right edge stay aligned.
                            child: Transform.scale(
                              scale: 1.08,
                              alignment: Alignment.centerRight,
                              child: Image.asset(
                                'assets/jexfyzcooler.png',
                                width: double.infinity,
                                height: imageHeight,
                                fit: BoxFit.contain,
                                alignment: Alignment.centerRight,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 2),
            _homeNotify(),
          ],
        ),
      ),
    );
  }
}
