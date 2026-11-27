part of 'main.dart';

// Dashboard control-row, toggle and list presentation helpers.
// Dashboard state remains the single owner of device/session/command behavior.
extension _DashboardControlComponents on _DashboardScreenState {
  // AI-METHOD / SUBMENU-TOGGLE-CONTRACT
  // Full-custom switch row. No Material Switch/ListTile chrome is used here.
  Widget _switchRow({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required bool enabled,
    required Future<void> Function(bool) onChanged,
    bool stateKnown = true,
    JexAnimatedIconKind? animatedKind,
    int voltageLevel = 5,
    double animationLevel = 1.0,
    Color? animationColor,
    bool showStateLabel = true,
    bool showCheck = true,
    bool neutralRow = false,
  }) {
    return JexDashboardSwitchRow(
      title: title,
      subtitle: subtitle,
      icon: icon,
      value: value,
      enabled: enabled,
      onChanged: onChanged,
      stateKnown: stateKnown,
      animatedKind: animatedKind,
      voltageLevel: voltageLevel,
      animationLevel: animationLevel,
      animationColor: animationColor,
      showStateLabel: showStateLabel,
      showCheck: showCheck,
      neutralRow: neutralRow,
      connected: connected,
      language: appLanguageNotifier.value,
    );
  }

  Widget _smoothList({
    required List<Widget> children,
    required String storageKey,
    EdgeInsetsGeometry padding = const EdgeInsets.fromLTRB(2, 2, 2, 20),
  }) {
    return ListView(
      key: PageStorageKey<String>(storageKey),
      physics: const ClampingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      scrollCacheExtent: const ScrollCacheExtent.pixels(480),
      padding: padding,
      children: children,
    );
  }
}


/// Shared presentation for the Dashboard's Fan, Peltier, Adaptive and LED power rows.
/// Hardware/session ownership remains in Dashboard; this widget receives a state snapshot
/// and a guarded callback, and never reads telemetry or sends commands itself.
class JexDashboardSwitchRow extends StatelessWidget {
  const JexDashboardSwitchRow({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.value,
    required this.enabled,
    required this.onChanged,
    required this.connected,
    required this.language,
    this.stateKnown = true,
    this.animatedKind,
    this.voltageLevel = 5,
    this.animationLevel = 1.0,
    this.animationColor,
    this.showStateLabel = true,
    this.showCheck = true,
    this.neutralRow = false,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final bool value;
  final bool enabled;
  final Future<void> Function(bool) onChanged;
  final bool connected;
  final AppLanguage language;
  final bool stateKnown;
  final JexAnimatedIconKind? animatedKind;
  final int voltageLevel;
  final double animationLevel;
  final Color? animationColor;
  final bool showStateLabel;
  final bool showCheck;
  final bool neutralRow;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final accent = scheme.jexAccent;
    final lightTheme = Theme.of(context).brightness == Brightness.light;
    final rowFill = lightTheme
        ? const Color(0xFFF5F6F8)
        : (neutralRow
              ? scheme.jexElevatedSurface.withValues(alpha: .26)
              : (value
                    ? accent.withValues(alpha: .075)
                    : scheme.jexElevatedSurface.withValues(alpha: .34)));
    final rowBorder = lightTheme
        ? const Color(0xFFDDE1E7)
        : (neutralRow
              ? scheme.jexOutline.withValues(alpha: .68)
              : (value
                    ? accent.withValues(alpha: .28)
                    : scheme.jexOutline.withValues(alpha: .72)));

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOutCubic,
      constraints: const BoxConstraints(minHeight: jexSubmenuRowMinHeight),
      padding: const EdgeInsets.symmetric(
        horizontal: JexSpacingTokens.dashboardSwitchRowHorizontalInset,
        vertical: JexSpacingTokens.dashboardSwitchRowVerticalInset,
      ),
      decoration: BoxDecoration(
        color: rowFill,
        borderRadius: BorderRadius.circular(
          JexShapeTokens.dashboardSwitchRowRadius,
        ),
        border: Border.all(color: rowBorder),
      ),
      child: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: JexLayoutTokens.dashboardSwitchRowIconSize,
            height: JexLayoutTokens.dashboardSwitchRowIconSize,
            decoration: BoxDecoration(
              color: lightTheme
                  ? const Color(0xFFE9EBEF)
                  : (neutralRow
                        ? scheme.jexElevatedSurface.withValues(alpha: .72)
                        : (value
                              ? accent.withValues(alpha: .12)
                              : scheme.jexElevatedSurface.withValues(
                                  alpha: .72,
                                ))),
              borderRadius: BorderRadius.circular(
                JexShapeTokens.dashboardSwitchRowIconRadius,
              ),
            ),
            child: Center(
              child: animatedKind == null
                  ? Icon(
                      icon,
                      size: 21,
                      color: value ? accent : scheme.jexMutedForeground,
                    )
                  : JexAnimatedIcon(
                      kind: animatedKind!,
                      size: 22,
                      color: animationColor ?? accent,
                      connected: connected,
                      active: jexIconAnimationPermitted(
                        connected: connected,
                        kind: animatedKind!,
                        stateActive: stateKnown && value,
                      ),
                      level: animationLevel,
                      voltageLevel: voltageLevel,
                    ),
            ),
          ),
          const SizedBox(
            width: JexSpacingTokens.dashboardSwitchRowIconLabelGap,
          ),
          Expanded(
            child: ExcludeSemantics(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title.toUpperCase(),
                    style: TextStyle(
                      fontSize: JexTypographyTokens.dashboardSwitchRowTitle,
                      letterSpacing: .35,
                      fontWeight: FontWeight.w900,
                      color: scheme.jexForeground,
                    ),
                  ),
                  if (subtitle.trim().isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(
                        top: JexSpacingTokens.dashboardSwitchRowSubtitleTopGap,
                      ),
                      child: Text(
                        subtitle,
                        style: TextStyle(
                          fontSize:
                              JexTypographyTokens.dashboardSwitchRowSubtitle,
                          fontWeight: FontWeight.w600,
                          color: scheme.jexMutedForeground,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          if (showStateLabel) ...[
            const SizedBox(
              width: JexSpacingTokens.dashboardSwitchRowStateGap,
            ),
            ExcludeSemantics(
              child: Text(
                stateKnown
                    ? JexText.of(value ? 'on' : 'off', language)
                    : JexText.of('off', language),
                style: TextStyle(
                  fontSize: JexTypographyTokens.dashboardSwitchRowState,
                  fontWeight: FontWeight.w900,
                  color: value ? accent : scheme.jexMutedForeground,
                ),
              ),
            ),
            const SizedBox(
              width: JexSpacingTokens.dashboardSwitchRowStateGap,
            ),
          ],
          JexDashboardToggle(
            semanticLabel: subtitle.trim().isEmpty
                ? title
                : '$title, $subtitle',
            value: value,
            enabled: enabled,
            stateKnown: stateKnown,
            accent: accent,
            showCheck: showCheck,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

/// Accessible toggle used by Dashboard control rows.
/// The visible pill remains 54×32 dp; the hit target expands to 54×48 dp.
class JexDashboardToggle extends StatelessWidget {
  const JexDashboardToggle({
    super.key,
    this.semanticLabel,
    required this.value,
    required this.enabled,
    required this.accent,
    required this.onChanged,
    this.stateKnown = true,
    this.showCheck = true,
  });

  final String? semanticLabel;
  final bool value;
  final bool enabled;
  final Color accent;
  final Future<void> Function(bool value) onChanged;
  final bool stateKnown;
  final bool showCheck;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    // Offline fallback is a visual default only, not confirmed hardware telemetry.
    final displayedValue = stateKnown && value;
    final canActivate = enabled && stateKnown;
    void activate() {
      if (!canActivate) return;
      unawaited(onChanged(!displayedValue));
    }

    final target = SizedBox(
      width: jexSubmenuToggleWidth,
      height: JexLayoutTokens.minimumTouchTarget,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: canActivate ? activate : null,
        child: Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: jexSubmenuToggleWidth,
            height: jexSubmenuToggleHeight,
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: displayedValue
                  ? accent.withValues(alpha: .24)
                  : scheme.jexElevatedSurface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: displayedValue
                    ? accent.withValues(alpha: .52)
                    : scheme.jexOutline,
                width: 1.2,
              ),
            ),
            child: AnimatedAlign(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOutCubic,
              alignment: displayedValue
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: displayedValue
                      ? accent
                      : (enabled
                            ? scheme.jexMutedForeground
                            : scheme.jexMutedForeground.withValues(alpha: .32)),
                  shape: BoxShape.circle,
                  boxShadow: [
                    if (displayedValue)
                      BoxShadow(
                        color: accent.withValues(alpha: .20),
                        blurRadius: 7,
                        offset: const Offset(0, 2),
                      ),
                  ],
                ),
                child: displayedValue && showCheck
                    ? const Icon(
                        PhosphorIconsBold.check,
                        size: 15,
                        color: Colors.white,
                      )
                    : null,
              ),
            ),
          ),
        ),
      ),
    );
    final label = semanticLabel?.trim();
    if (label == null || label.isEmpty) {
      return ExcludeSemantics(child: target);
    }
    return Semantics(
      container: true,
      label: label,
      toggled: stateKnown ? displayedValue : null,
      enabled: canActivate,
      onTap: canActivate ? activate : null,
      excludeSemantics: true,
      child: target,
    );
  }
}

/// Presentation-only Adaptive profile choice. Dashboard owns the profile value
/// and supplies the guarded callback; this widget only exposes its selected state.
class JexAdaptiveProfileChoice extends StatelessWidget {
  const JexAdaptiveProfileChoice({
    super.key,
    required this.title,
    required this.icon,
    required this.selected,
    required this.locked,
    required this.enabled,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final bool selected;
  final bool locked;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final accent = scheme.jexAccent;
    final effectiveTap = enabled ? onTap : null;

    // Screen readers need the selected profile state, not only the visual tick.
    return Semantics(
      container: true,
      label: title,
      button: true,
      selected: selected,
      enabled: enabled,
      onTap: effectiveTap,
      child: ExcludeSemantics(
        child: InkWell(
          onTap: effectiveTap,
          borderRadius: BorderRadius.circular(17),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: selected
                  ? accent.withValues(alpha: .07)
                  : scheme.jexElevatedSurface.withValues(alpha: .24),
              borderRadius: BorderRadius.circular(17),
              border: Border.all(
                color: selected
                    ? accent.withValues(alpha: .30)
                    : scheme.jexOutline.withValues(alpha: .68),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: selected
                        ? accent.withValues(alpha: .11)
                        : scheme.jexElevatedSurface.withValues(alpha: .62),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Icon(
                    icon,
                    size: 21,
                    color: locked
                        ? scheme.jexMutedForeground.withValues(alpha: .35)
                        : (selected ? accent : scheme.jexMutedForeground),
                  ),
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: locked
                          ? scheme.jexMutedForeground.withValues(alpha: .45)
                          : scheme.jexForeground,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: selected
                        ? accent.withValues(alpha: .14)
                        : scheme.jexElevatedSurface,
                    border: Border.all(
                      color: selected ? accent : scheme.jexOutline,
                      width: selected ? 2 : 1,
                    ),
                  ),
                  child: selected
                      ? Icon(PhosphorIconsBold.check, size: 17, color: accent)
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
