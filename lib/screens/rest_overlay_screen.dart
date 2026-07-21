import 'package:flutter/material.dart';
import 'package:pomodoro_sczuw/services/l10n.dart';

class RestOverlayScreen extends StatelessWidget {
  const RestOverlayScreen({
    super.key,
    required this.tipIndex,
    required this.onDismiss,
  });

  final int tipIndex;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final l10n = L10n().t;
    final tips = [
      l10n.restOverlay_tip1,
      l10n.restOverlay_tip2,
      l10n.restOverlay_tip3,
      l10n.restOverlay_tip4,
    ];
    final tip = tips[tipIndex % tips.length];

    return Material(
      color: Colors.black.withValues(alpha: 0.82),
      child: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    l10n.restOverlay_title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.restOverlay_subtitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 28),
                  Text(
                    tip,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.75),
                      fontSize: 16,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 40),
                  FilledButton(
                    onPressed: onDismiss,
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black87,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    ),
                    child: Text(l10n.restOverlay_dismiss),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
