import 'dart:math' as math;

import 'package:flutter/material.dart';

class JexAnimatedGlyph extends StatefulWidget {
  final IconData icon;
  final Color color;
  final double size;
  final bool active;
  final bool warning;

  const JexAnimatedGlyph({
    super.key,
    required this.icon,
    required this.color,
    this.size = 24,
    this.active = true,
    this.warning = false,
  });

  @override
  State<JexAnimatedGlyph> createState() => _JexAnimatedGlyphState();
}

class _JexAnimatedGlyphState extends State<JexAnimatedGlyph>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        final phase = controller.value * math.pi * 2;
        final strength = widget.active ? 1.0 : 0.35;
        final pulse = math.sin(phase) * strength;
        final scale = 1 + pulse * 0.016;
        final dy = pulse * widget.size * 0.008;
        final alpha = widget.warning
            ? 0.72 + 0.28 * (0.5 + 0.5 * math.sin(phase * 2))
            : 1.0;
        return Transform.translate(
          offset: Offset(0, dy),
          child: Transform.scale(
            scale: scale,
            child: Icon(
              widget.icon,
              size: widget.size,
              color: widget.color.withValues(alpha: alpha),
            ),
          ),
        );
      },
    );
  }
}
