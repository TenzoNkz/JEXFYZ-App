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
    final scheme = Theme.of(context).colorScheme;
    final accent = scheme.jexAccent;
    final lang = appLanguageNotifier.value;
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: rowFill,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: rowBorder),
      ),
      child: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: 42,
            height: 42,
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
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: animatedKind == null
                  ? Icon(
                      icon,
                      size: 21,
                      color: value ? accent : scheme.jexMutedForeground,
                    )
                  : JexAnimatedIcon(
                      kind: animatedKind,
                      size: 22,
                      color: animationColor ?? accent,
                      connected: connected,
                      active: jexIconAnimationPermitted(
                        connected: connected,
                        kind: animatedKind,
                        stateActive: stateKnown && value,
                      ),
                      level: animationLevel,
                      voltageLevel: voltageLevel,
                    ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ExcludeSemantics(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title.toUpperCase(),
                    style: TextStyle(
                      fontSize: 13,
                      letterSpacing: .35,
                      fontWeight: FontWeight.w900,
                      color: scheme.jexForeground,
                    ),
                  ),
                  if (subtitle.trim().isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 10.5,
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
            const SizedBox(width: 8),
            ExcludeSemantics(
              child: Text(
                stateKnown
                    ? JexText.of(value ? 'on' : 'off', lang)
                    : JexText.of('off', lang),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  color: value ? accent : scheme.jexMutedForeground,
                ),
              ),
            ),
            const SizedBox(width: 8),
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
