import 'package:flutter/material.dart';
import '../../core/app_mode.dart';
import 'package:animate_do/animate_do.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';

class UIModeWrapper extends StatelessWidget {
  final Widget child;
  final UIMode mode;
  final bool animate;

  const UIModeWrapper({
    super.key,
    required this.child,
    required this.mode,
    this.animate = true,
  });

  @override
  Widget build(BuildContext context) {
    // PREMIUM MODE: Multi-layered effects and blurs
    if (mode == UIMode.premiumMode) {
      if (!animate) return child;
      return FadeInUp(
        duration: const Duration(milliseconds: 400),
        child: child,
      );
    }

    // PERFORMANCE MODE: Force repaint boundary for static/heavy content
    if (mode == UIMode.performanceMode) {
      return RepaintBoundary(child: child);
    }

    // LIGHT MODE: Default simple rendering
    return child;
  }
}

class PremiumButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final UIMode mode;

  const PremiumButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.mode,
  });

  @override
  Widget build(BuildContext context) {
    if (mode == UIMode.premiumMode) {
      return Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Colors.pinkAccent, Colors.purpleAccent]),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.pink.withValues(alpha: 0.3), blurRadius: 12, spreadRadius: 2)],
        ),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: Text(text, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
      );
    }

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(text),
    );
  }
}

class GlassCard extends StatelessWidget {
  final Widget child;
  final UIMode mode;

  const GlassCard({super.key, required this.child, required this.mode});

  @override
  Widget build(BuildContext context) {
    if (mode == UIMode.premiumMode) {
      return GlassContainer(
        blur: 15,
        opacity: 0.1,
        borderRadius: BorderRadius.circular(20),
        child: Padding(padding: const EdgeInsets.all(20), child: child),
      );
    }

    return Card(child: Padding(padding: const EdgeInsets.all(20), child: child));
  }
}
