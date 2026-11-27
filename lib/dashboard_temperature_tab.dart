// AI-MEMORY / FILE CONTRACT
// Dashboard Temperature tab presentation only. The enclosing library retains
// private access to Dashboard callbacks and Theme/localization state; this part
// must not own BLE, P1, persistence, session state or physical command behavior.
part of 'main.dart';

extension _DashboardTemperatureTabBuilder on _DashboardScreenState {
  // AI-METHOD / TEMPERATURE-UI-CONTRACT
  // Compact thermal controls with consistent custom +/- buttons and no long dividers.
  Widget _buildTemperatureTab({Key? key}) {
    final locked = adaptiveOn || adaptiveTransitioning;
    final midLow = battery5Limit;
    final midHigh = battery12Limit;
    final lang = appLanguageNotifier.value;

    return KeyedSubtree(
      key: key,
      child: this._smoothList(
        storageKey: 'temperature',
        padding: const EdgeInsets.fromLTRB(2, 0, 2, 18),
        children: [
          JexDashboardSectionTitle(JexText.of('thermal', lang)),
          JexDashboardCard(
            padding: const EdgeInsets.all(11),
            child: _temperatureAdjuster(
              title: JexText.of('hotsideLimit'),
              value: hotLimitDraft,
              min: 40,
              max: 50,
              enabled: connected && !locked,
              onChanged: _setHotLimit,
            ),
          ),
          JexDashboardSectionTitle(JexText.of('batteryZones', lang)),
          JexDashboardCard(
            padding: const EdgeInsets.all(9),
            child: Column(
              children: [
                _temperatureAdjuster(
                  title: JexText.of('fiveVCeiling'),
                  value: battery5Draft,
                  min: 20,
                  max: 30,
                  enabled: connected && !locked,
                  // Keep the visible affordance aligned with the setter's 2°C
                  // minimum separation; otherwise an enabled tap is a no-op.
                  canIncrease: battery5Draft < battery12Limit - 2,
                  onChanged: (v) {
                    if (v < battery12Limit - 1) _setBattery5(v);
                  },
                ),
                const SizedBox(height: 8),
                _lockedZoneRow(
                  title: JexText.of('zone9v', lang),
                  value:
                      midLow.toString() +
                      '°C → 9V → ' +
                      midHigh.toString() +
                      '°C',
                ),
                const SizedBox(height: 8),
                _temperatureAdjuster(
                  title: JexText.of('twelveVFloor'),
                  value: battery12Draft,
                  min: 30,
                  max: 40,
                  enabled: connected && !locked,
                  canDecrease: battery12Draft > battery5Limit + 2,
                  onChanged: (v) {
                    if (v > battery5Limit + 1) _setBattery12(v);
                  },
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

  Widget _temperatureAdjuster({
    required String title,
    required int value,
    required int min,
    required int max,
    required bool enabled,
    required ValueChanged<int> onChanged,
    bool canDecrease = true,
    bool canIncrease = true,
  }) {
    final scheme = Theme.of(context).colorScheme;
    final accent = scheme.jexAccent;
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 150),
      opacity: enabled ? 1 : .48,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title.toUpperCase(),
                  style: TextStyle(
                    color: scheme.jexForeground,
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    letterSpacing: .35,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  JexText.of('range', appLanguageNotifier.value) +
                      ' ' +
                      min.toString() +
                      '–' +
                      max.toString() +
                      '°C',
                  style: TextStyle(
                    color: scheme.jexMutedForeground,
                    fontSize: 9.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          _temperatureButton(
            icon: PhosphorIconsRegular.minus,
            semanticLabel: JexText.phrase('Decrease $title', 'Kurangi $title'),
            enabled: enabled && canDecrease && value > min,
            onPressed: () => onChanged(value - 1),
          ),
          const SizedBox(width: 5),
          AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 72,
            padding: const EdgeInsets.symmetric(vertical: 9),
            decoration: BoxDecoration(
              color: scheme.jexElevatedSurface.withValues(alpha: .55),
              borderRadius: BorderRadius.circular(13),
              border: Border.all(color: scheme.jexOutline),
            ),
            child: Text(
              value.toString() + '°C',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: accent,
                fontSize: 14,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(width: 5),
          _temperatureButton(
            icon: PhosphorIconsRegular.plus,
            semanticLabel: JexText.phrase('Increase $title', 'Tambah $title'),
            enabled: enabled && canIncrease && value < max,
            onPressed: () => onChanged(value + 1),
          ),
        ],
      ),
    );
  }

  Widget _temperatureButton({
    required IconData icon,
    required String semanticLabel,
    required bool enabled,
    required VoidCallback onPressed,
  }) {
    final scheme = Theme.of(context).colorScheme;
    return SizedBox(
      width: JexLayoutTokens.minimumTouchTarget,
      height: JexLayoutTokens.minimumTouchTarget,
      child: MergeSemantics(
        child: Semantics(
          label: semanticLabel,
          button: true,
          enabled: enabled,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: enabled ? onPressed : null,
              borderRadius: BorderRadius.circular(12),
              child: Center(
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: enabled
                        ? scheme.jexElevatedSurface
                        : scheme.jexElevatedSurface.withValues(alpha: .48),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: scheme.jexOutline),
                  ),
                  child: Icon(
                    icon,
                    size: 19,
                    color: enabled
                        ? scheme.jexMutedForeground
                        : scheme.jexMutedForeground.withValues(alpha: .28),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _lockedZoneRow({required String title, required String value}) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: scheme.jexElevatedSurface.withValues(alpha: .24),
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: scheme.jexOutline.withValues(alpha: .68)),
      ),
      child: Row(
        children: [
          Icon(
            PhosphorIconsRegular.lock,
            size: 18,
            color: scheme.jexMutedForeground.withValues(alpha: .55),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title.toUpperCase(),
              style: TextStyle(
                color: scheme.jexMutedForeground,
                fontSize: 11.5,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: scheme.jexForeground,
              fontSize: 13,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}
