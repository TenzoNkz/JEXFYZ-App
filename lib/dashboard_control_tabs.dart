// AI-MEMORY / FILE CONTRACT
// Presentation builders for Dashboard Voltage, Control, Adaptive and LED tabs.
// The enclosing library retains all Dashboard state, command, BLE/GATT and P1 ownership.
part of 'main.dart';

extension _DashboardControlTabsBuilder on _DashboardScreenState {
  // AI-METHOD: _buildVoltageTab — Build the fixed three-level VOLTAGE selector.
  // The selector intentionally matches the physical voltage hierarchy:
  // 5V Low Mode -> 9V Mid Mode -> 12V High Mode.
  // AI-METHOD / VOLTAGE-UI-CONTRACT
  // Voltage stays vertical. Each row is a custom single-select toggle; only one can be active.
  Widget _buildVoltageTab({Key? key}) {
    final locked =
        !connected ||
        adaptiveOn ||
        voltageGuardActive ||
        (voltageLockKnown && voltageLockActive);
    final lang = appLanguageNotifier.value;

    return KeyedSubtree(
      key: key,
      child: this._smoothList(
        storageKey: 'voltage',
        padding: const EdgeInsets.fromLTRB(2, 0, 2, 18),
        children: [
          JexDashboardSectionTitle(JexText.of('voltage', lang)),
          if (voltageLockKnown && voltageLockActive)
            JexDashboardCard(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  Icon(
                    PhosphorIconsRegular.lock,
                    color: Theme.of(context).colorScheme.jexAccent,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      voltage == '5V'
                          ? JexText.phrase(
                              'Locked at 5V. Voltage selection is disabled.',
                              'Terkunci di 5V. Pemilihan tegangan dinonaktifkan.',
                            )
                          : JexText.phrase(
                              'Lock active — safely returning to 5V. The value below remains actual device telemetry.',
                              'Kunci aktif — perangkat sedang kembali ke 5V dengan aman. Nilai di bawah tetap mengikuti telemetri aktual.',
                            ),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.jexMutedForeground,
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          JexDashboardCard(
            padding: const EdgeInsets.all(9),
            child: Column(
              children: [
                _voltageChoiceCustom('5V', JexText.of('lowMode', lang), locked),
                const SizedBox(height: 8),
                _voltageChoiceCustom('9V', JexText.of('midMode', lang), locked),
                const SizedBox(height: 8),
                _voltageChoiceCustom(
                  '12V',
                  JexText.of('highMode', lang),
                  locked,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _voltageChoiceCustom(String target, String mode, bool locked) {
    final active = voltage == target;
    final scheme = Theme.of(context).colorScheme;
    return Semantics(
      container: true,
      label: '$target, $mode',
      button: true,
      selected: active,
      enabled: !locked,
      onTap: locked ? null : () => _requestVoltage(target),
      child: ExcludeSemantics(
        child: InkWell(
          onTap: locked ? null : () => _requestVoltage(target),
          borderRadius: BorderRadius.circular(18),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOutCubic,
            constraints: const BoxConstraints(
              minHeight: jexSubmenuRowMinHeight,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              // Geometry intentionally mirrors CONTROL/_switchRow. The row stays neutral;
              // selection is represented only by the shared toggle on the right.
              color: scheme.jexElevatedSurface.withValues(alpha: .26),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: scheme.jexOutline.withValues(alpha: .68),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: scheme.jexElevatedSurface.withValues(alpha: .72),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    target,
                    style: TextStyle(
                      color: jexVoltageIndicatorColor(target),
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    mode,
                    style: TextStyle(
                      color: scheme.jexMutedForeground,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                JexDashboardToggle(
                  semanticLabel: null,
                  value: active,
                  enabled: !locked,
                  accent: scheme.jexAccent,
                  showCheck: false,
                  onChanged: (_) async => _requestVoltage(target),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // AI-METHOD / CONTROL-TAB CONTRACT
  // Render Peltier and Fan switches from authoritative telemetry.
  // Fan Speed is always presented. Its value becomes OFF/MATI when Fan is OFF,
  // while the editable slider remains gated by connected + manual + 12V + Fan ON.
  // AI-METHOD / CONTROL-UI-CONTRACT
  // Compact custom device controls; no long separators or default Material tiles.
  Widget _buildControlTab({Key? key}) {
    final speedEnabled = connected && !adaptiveOn && voltage == '12V' && fanOn;
    final lang = appLanguageNotifier.value;
    final scheme = Theme.of(context).colorScheme;

    return KeyedSubtree(
      key: key,
      child: this._smoothList(
        storageKey: 'control',
        padding: const EdgeInsets.fromLTRB(2, 0, 2, 18),
        children: [
          JexDashboardSectionTitle(JexText.of('control', lang)),
          JexDashboardCard(
            padding: const EdgeInsets.all(9),
            child: Column(
              children: [
                this._switchRow(
                  title: JexText.of('peltier', lang),
                  showStateLabel: false,
                  showCheck: false,
                  neutralRow: true,
                  subtitle: '',
                  icon: PhosphorIconsRegular.snowflake,
                  animatedKind: JexAnimatedIconKind.peltier,
                  animationColor: const Color(0xFF18DFFF),
                  animationLevel: peltierOn ? 1.0 : 0.0,
                  voltageLevel: jexVoltageAnimationLevel(voltage),
                  value: peltierOn,
                  enabled: connected && runtimeOutputsKnown && !adaptiveOn,
                  stateKnown: runtimeOutputsKnown,
                  onChanged: _togglePeltier,
                ),
                const SizedBox(height: 8),
                this._switchRow(
                  title: JexText.of('fan', lang),
                  showStateLabel: false,
                  showCheck: false,
                  neutralRow: true,
                  subtitle: '',
                  icon: PhosphorIconsRegular.fan,
                  animatedKind: JexAnimatedIconKind.fan,
                  animationColor: const Color(0xFF38E3AD),
                  animationLevel: fanSpeed / 100,
                  voltageLevel: jexVoltageAnimationLevel(voltage),
                  value: fanOn,
                  enabled:
                      connected &&
                      runtimeOutputsKnown &&
                      !adaptiveOn &&
                      !peltierOn,
                  stateKnown: runtimeOutputsKnown,
                  onChanged: _toggleFan,
                ),
                const SizedBox(height: 10),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                  decoration: BoxDecoration(
                    color: scheme.jexElevatedSurface.withValues(alpha: .25),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: scheme.jexOutline.withValues(alpha: .70),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          JexAnimatedIcon(
                            kind: JexAnimatedIconKind.speed,
                            size: 25,
                            color: const Color(0xFFFFCD38),
                            connected: connected,
                            active: connected && runtimeOutputsKnown && fanOn,
                            valueKnown: connected && runtimeOutputsKnown,
                            level: runtimeOutputsKnown && fanOn
                                ? fanSpeed / 100
                                : 0.0,
                            voltageLevel: jexVoltageAnimationLevel(voltage),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              JexText.of('fanSpeedLabel', lang),
                              style: TextStyle(
                                color: scheme.jexForeground,
                                fontSize: 13,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                          Text(
                            !connected || !runtimeOutputsKnown || !fanOn
                                ? JexText.of('off', lang)
                                : '$fanSpeed%',
                            style: TextStyle(
                              color: fanOn
                                  ? scheme.jexAccent
                                  : scheme.jexMutedForeground,
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                      if (fanOn) ...[
                        const SizedBox(height: 3),
                        Slider(
                          min: 50,
                          max: 100,
                          divisions: 5,
                          value: fanSpeedDraft.clamp(50, 100).toDouble(),
                          activeColor: scheme.jexAccent,
                          inactiveColor: scheme.jexForeground.withValues(
                            alpha: .10,
                          ),
                          onChanged: speedEnabled
                              ? (v) => _updateDashboardPresentation(
                                  () => fanSpeedDraft = ((v / 10).round() * 10)
                                      .clamp(50, 100)
                                      .toInt(),
                                )
                              : null,
                          onChangeEnd: speedEnabled ? _setFanSpeed : null,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // AI-METHOD: _buildAdaptiveTab — Build ADAPTIVE submenu.
  // AI-METHOD / ADAPTIVE-UI-CONTRACT
  // Custom profile selection replaces Material RadioListTile while preserving commands/state.
  Widget _buildAdaptiveTab({Key? key}) {
    final lang = appLanguageNotifier.value;
    final locked =
        adaptiveOn ||
        adaptiveTransitioning ||
        (voltageLockKnown && voltageLockActive);
    final group = adaptiveProfile == 'HOTSIDE_BATTERY'
        ? 'HOTSIDE_BATTERY'
        : 'HOTSIDE';

    return KeyedSubtree(
      key: key,
      child: this._smoothList(
        storageKey: 'adaptive',
        padding: const EdgeInsets.fromLTRB(2, 0, 2, 18),
        children: [
          JexDashboardSectionTitle(JexText.of('adaptive', lang)),
          JexDashboardCard(
            padding: const EdgeInsets.all(9),
            child: this._switchRow(
              title: JexText.of('adaptiveSwitch', lang),
              showStateLabel: false,
              showCheck: false,
              neutralRow: true,
              subtitle: '',
              icon: PhosphorIconsRegular.sparkle,
              animatedKind: JexAnimatedIconKind.adaptive,
              animationColor: const Color(0xFFC05BFF),
              animationLevel: adaptiveOn ? 1.0 : 0.0,
              voltageLevel: jexVoltageAnimationLevel(voltage),
              value: adaptiveOn,
              enabled:
                  connected &&
                  runtimeOutputsKnown &&
                  !(voltageLockKnown && voltageLockActive),
              stateKnown: runtimeOutputsKnown,
              onChanged: _toggleAdaptive,
            ),
          ),
          if (voltageLockKnown && voltageLockActive)
            JexDashboardCard(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  Icon(
                    PhosphorIconsRegular.lock,
                    color: Theme.of(context).colorScheme.jexAccent,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      JexText.phrase(
                        'Adaptive Mode is forced OFF while Lock Voltage is active.',
                        'Mode Adaptif dipaksa MATI selama Kunci Tegangan aktif.',
                      ),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.jexMutedForeground,
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          JexDashboardSectionTitle(JexText.of('adaptiveProfile', lang)),
          JexDashboardCard(
            padding: const EdgeInsets.all(9),
            child: Column(
              children: [
                _adaptiveProfileRow(
                  value: 'HOTSIDE',
                  title: JexText.of('hotsideProtection', lang),
                  icon: PhosphorIconsRegular.thermometer,
                  selected: group == 'HOTSIDE',
                  locked: locked,
                ),
                const SizedBox(height: 8),
                _adaptiveProfileRow(
                  value: 'HOTSIDE_BATTERY',
                  title: JexText.of('hotsideBattery', lang),
                  icon: PhosphorIconsRegular.batteryHigh,
                  selected: group == 'HOTSIDE_BATTERY',
                  locked: locked,
                ),
              ],
            ),
          ),
          if (locked)
            JexDashboardCard(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  const Icon(
                    PhosphorIconsRegular.lock,
                    size: 19,
                    color: Colors.orangeAccent,
                  ),
                  const SizedBox(width: 9),
                  Expanded(
                    child: Text(
                      JexText.of('lockedAdaptive', lang),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.jexMutedForeground,
                        fontSize: 10.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _adaptiveProfileRow({
    required String value,
    required String title,
    required IconData icon,
    required bool selected,
    required bool locked,
  }) {
    return JexAdaptiveProfileChoice(
      title: title,
      icon: icon,
      selected: selected,
      locked: locked,
      enabled: connected && !locked,
      onTap: () => unawaited(_setAdaptiveProfile(value)),
    );
  }

  // AI-METHOD: _buildLedTab — Build LED/RGB/brightness/color controls.
  // AI-METHOD / LED-UI-CONTRACT
  // Custom LED control surface. The preview mirrors the physical 4-left/4-right strip and follows firmware phase telemetry.
  Widget _buildLedTab({Key? key}) {
    final lang = appLanguageNotifier.value;
    final modeNames = <String>[
      JexText.of('ledModeStatic', lang),
      JexText.of('ledModeBreath', lang),
      JexText.of('ledModeComet', lang),
      JexText.of('ledModeDualChase', lang),
      JexText.of('leftRight', lang),
      JexText.of('ledModeRainbow', lang),
    ];
    final modeIndex = ledModeDisplayIndex(rgbMode);
    final supportedMode = modeIndex >= 0;
    final previewMode = supportedMode ? rgbMode : 1;
    final modeName = supportedMode
        ? modeNames[modeIndex]
        : JexText.of('ledModeUnsupported', lang);
    final colorEnabled = connected && supportedMode && rgbMode != 7;
    final scheme = Theme.of(context).colorScheme;

    return KeyedSubtree(
      key: key,
      child: this._smoothList(
        storageKey: 'led',
        padding: const EdgeInsets.fromLTRB(2, 0, 2, 18),
        children: [
          JexDashboardSectionTitle(JexText.of('led', lang)),
          JexDashboardCard(
            padding: const EdgeInsets.all(9),
            child: Column(
              children: [
                this._switchRow(
                  title: JexText.of('power', lang),
                  showStateLabel: false,
                  showCheck: false,
                  neutralRow: true,
                  subtitle: '',
                  icon: PhosphorIconsBold.lightbulb,
                  animatedKind: JexAnimatedIconKind.led,
                  value: rgbOn,
                  enabled: connected && runtimeOutputsKnown,
                  stateKnown: runtimeOutputsKnown,
                  onChanged: _setRgb,
                ),
                const SizedBox(height: 9),
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 9, 10, 10),
                  decoration: BoxDecoration(
                    color: scheme.jexElevatedSurface.withValues(alpha: .22),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: scheme.jexOutline.withValues(alpha: .68),
                    ),
                  ),
                  child: Column(
                    children: [
                      JexLedStripPreview(
                        mode: previewMode,
                        colorHex: rgbColor.toUpperCase(),
                        active: rgbOn && connected && supportedMode,
                        ledPhaseMs: ledPhaseMs,
                        ledCycleMs: ledCycleMs,
                        ledSyncRevision: ledSyncRevision,
                        modeName: modeName,
                        previousEnabled:
                            connected && (modeIndex < 0 || modeIndex > 0),
                        nextEnabled:
                            connected &&
                            (modeIndex < 0 ||
                                modeIndex < supportedLedModeIds.length - 1),
                        onPrevious: () =>
                            _setMode(modeIndex < 0 ? 1 : modeIndex - 1),
                        onNext: () =>
                            _setMode(modeIndex < 0 ? 2 : modeIndex + 1),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 9),
                Container(
                  padding: const EdgeInsets.fromLTRB(11, 8, 11, 7),
                  decoration: BoxDecoration(
                    color: scheme.jexElevatedSurface.withValues(alpha: .20),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: scheme.jexOutline.withValues(alpha: .60),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        PhosphorIconsRegular.sun,
                        size: 19,
                        color: scheme.jexMutedForeground,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Slider(
                          min: 1,
                          max: 100,
                          divisions: 99,
                          value: brightness.clamp(1, 100).toDouble(),
                          activeColor: scheme.jexAccent,
                          inactiveColor: scheme.jexForeground.withValues(
                            alpha: .10,
                          ),
                          onChanged: connected
                              ? (v) => _updateDashboardPresentation(
                                  () => brightness = v.round(),
                                )
                              : null,
                          onChangeEnd: connected ? _setBrightness : null,
                        ),
                      ),
                      SizedBox(
                        width: 40,
                        child: Text(
                          '$brightness%',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: scheme.jexForeground,
                            fontSize: 11,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Opacity(
            opacity: colorEnabled ? 1 : .45,
            child: InkWell(
              onTap: colorEnabled ? _showLedColorPicker : null,
              borderRadius: BorderRadius.circular(18),
              child: Container(
                child: JexDashboardCard(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 11,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: colorEnabled
                              ? ledPaletteColor(rgbColor.toUpperCase())
                              : scheme.jexElevatedSurface,
                          borderRadius: BorderRadius.circular(11),
                          border: Border.all(
                            color: rgbColor.toUpperCase() == '#FFFFFF'
                                ? scheme.outline
                                : Colors.transparent,
                          ),
                        ),
                      ),
                      const SizedBox(width: 11),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              JexText.of('color', lang),
                              style: TextStyle(
                                color: scheme.jexForeground,
                                fontSize: 13,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 1),
                            Text(
                              ledColorDisplayName(rgbColor, lang),
                              style: TextStyle(
                                color: scheme.jexMutedForeground,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        PhosphorIconsRegular.caretRight,
                        color: scheme.jexMutedForeground,
                        size: 22,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
