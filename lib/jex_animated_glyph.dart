import 'package:flutter/material.dart';

/// Static glyph for navigation, settings, and action affordances.
///
/// These controls do not represent live telemetry, so they must not run decorative
/// idle loops. Data-driven status indicators use JexAnimatedIcon in main.dart.
class JexAnimatedGlyph extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size;

  const JexAnimatedGlyph({
    super.key,
    required this.icon,
    required this.color,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Icon(
        icon,
        size: size,
        color: color,
      ),
    );
  }
}
