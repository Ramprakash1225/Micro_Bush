import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../constants/branding.dart';

/// Centered logo watermark. Side color and size updated to match app theme.
class LogoWatermark extends StatelessWidget {
  const LogoWatermark({super.key});

  @override
  Widget build(BuildContext context) {
    // Slightly larger center image (240x240)
    const double logoSize = 240;
    const double containerSize = 320;

    final logo = Opacity(
      opacity: 0.35,
      child: Image.asset(
        Branding.logoWatermarkPath,
        width: logoSize,
        height: logoSize,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
      ),
    );

    return Positioned.fill(
      child: Center(
        child: IgnorePointer(
          child: Container(
            width: containerSize,
            height: containerSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFE8EEF5), // Soft blue-gray side color
              border: Border.all(
                color: Branding.primaryColor.withValues(alpha: 0.2),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Branding.primaryColor.withValues(alpha: 0.06),
                  blurRadius: 40,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Center(
              child: kIsWeb
                  ? ClipOval(child: logo)
                  : ClipOval(
                      child: ImageFiltered(
                        imageFilter: ImageFilter.blur(sigmaX: 1.2, sigmaY: 1.2),
                        child: logo,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
