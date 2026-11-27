// Shared Dashboard presentation primitives.
// These widgets contain no device state, BLE/P1 ownership, persistence or commands.
import 'package:flutter/material.dart';

import 'jex_design_tokens.dart';

/// The established Dashboard surface treatment shared by control and temperature tabs.
class JexDashboardCard extends StatelessWidget {
  const JexDashboardCard({super.key, required this.child, this.padding});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final dark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: padding ?? const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: scheme.jexSurface,
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: scheme.jexOutline.withValues(alpha: .78)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: dark ? .24 : .07),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }
}

/// Animated, keyed Dashboard tab content. Reduced motion keeps a short fade but
/// removes positional movement; outgoing tabs cannot receive input or semantics.
class JexDashboardTabTransition extends StatelessWidget {
  const JexDashboardTabTransition({
    super.key,
    required this.tabId,
    required this.child,
  });

  final int tabId;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final duration = Duration(milliseconds: reduceMotion ? 90 : 210);

    return AnimatedSwitcher(
      duration: duration,
      reverseDuration: duration,
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      layoutBuilder: (currentChild, previousChildren) => Stack(
        alignment: Alignment.topCenter,
        children: [
          for (final previousChild in previousChildren)
            Positioned.fill(
              child: IgnorePointer(
                child: ExcludeSemantics(child: previousChild),
              ),
            ),
          if (currentChild != null) currentChild,
        ],
      ),
      transitionBuilder: (child, animation) {
        final slide = Tween<Offset>(
          begin: const Offset(0, .015),
          end: Offset.zero,
        ).animate(animation);
        return FadeTransition(
          opacity: animation,
          child: reduceMotion
              ? child
              : SlideTransition(position: slide, child: child),
        );
      },
      child: KeyedSubtree(key: ValueKey<int>(tabId), child: child),
    );
  }
}

/// Shared Dashboard section heading using the active semantic theme roles.
class JexDashboardSectionTitle extends StatelessWidget {
  const JexDashboardSectionTitle(this.title, {super.key, this.subtitle});

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 6, 4, 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              letterSpacing: .60,
              color: scheme.jexForeground,
            ),
          ),
          if (subtitle != null && subtitle!.trim().isNotEmpty) ...[
            const SizedBox(height: 3),
            Text(
              subtitle!,
              style: TextStyle(
                color: scheme.jexMutedForeground,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}