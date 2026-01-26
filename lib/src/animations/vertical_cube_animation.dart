import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Dikey 3D Küp Animasyonu
/// Ana sayfa ile alt sayfalar arasında geçiş için kullanılır (yukarı-aşağı)
class VerticalCubeAnimation extends StatelessWidget {
  /// Animasyon controller'ı (0.0 - 1.0)
  /// 0.0 = Ana sayfa görünür
  /// 0.5 = Alt sayfa görünür
  /// 1.0 = Geçiş sırasında kullanılır
  final AnimationController controller;

  /// Üst widget (Ana sayfa)
  final Widget topWidget;

  /// Alt widget (Alt sayfa)
  final Widget bottomWidget;

  const VerticalCubeAnimation({
    super.key,
    required this.controller,
    required this.topWidget,
    required this.bottomWidget,
  });

  Matrix4 _perspective() => Matrix4.identity()..setEntry(3, 2, 0.001);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final double value = controller.value;

        if (value <= 0.05) {
          // Tamamen ana sayfa
          return topWidget;
        } else if (value >= 0.45 && value <= 0.55) {
          // Tamamen alt sayfa
          return bottomWidget;
        } else if (value < 0.5) {
          // Ana sayfadan alt sayfaya geçiş (0.0 -> 0.5)
          final phaseValue = value * 2; // 0.0 - 1.0'a normalize et

          final topRotation = Tween(
            begin: 0.0,
            end: math.pi / 2.2,
          ).transform(phaseValue);
          final topOffset = Tween<Offset>(
            begin: Offset.zero,
            end: const Offset(0.0, -1.0),
          ).transform(phaseValue);

          final bottomRotation = Tween(
            begin: -math.pi / 2.2,
            end: 0.0,
          ).transform(phaseValue);
          final bottomOffset = Tween<Offset>(
            begin: const Offset(0.0, 1.0),
            end: Offset.zero,
          ).transform(phaseValue);

          return Stack(
            alignment: Alignment.center,
            children: [
              // Ana sayfa (yukarı kayıyor)
              Visibility(
                visible: phaseValue < 0.95,
                child: FractionalTranslation(
                  translation: topOffset,
                  child: Transform(
                    alignment: Alignment.bottomCenter,
                    transform: _perspective()..rotateX(topRotation),
                    child: topWidget,
                  ),
                ),
              ),
              // Alt sayfa (aşağıdan geliyor)
              Visibility(
                visible: phaseValue > 0.05,
                child: FractionalTranslation(
                  translation: bottomOffset,
                  child: Transform(
                    alignment: Alignment.topCenter,
                    transform: _perspective()..rotateX(bottomRotation),
                    child: bottomWidget,
                  ),
                ),
              ),
            ],
          );
        } else {
          // Alt sayfadan ana sayfaya dönüş veya alt sayfalar arası geçiş (0.5 -> 1.0)
          final phaseValue = (value - 0.5) * 2; // 0.0 - 1.0'a normalize et

          final bottomRotation = Tween(
            begin: 0.0,
            end: math.pi / 2.2,
          ).transform(phaseValue);
          final bottomOffset = Tween<Offset>(
            begin: Offset.zero,
            end: const Offset(0.0, -1.0),
          ).transform(phaseValue);

          final topRotation = Tween(
            begin: -math.pi / 2.2,
            end: 0.0,
          ).transform(phaseValue);
          final topOffset = Tween<Offset>(
            begin: const Offset(0.0, 1.0),
            end: Offset.zero,
          ).transform(phaseValue);

          return Stack(
            alignment: Alignment.center,
            children: [
              // Alt sayfa (yukarı kayıyor)
              Visibility(
                visible: phaseValue < 0.95,
                child: FractionalTranslation(
                  translation: bottomOffset,
                  child: Transform(
                    alignment: Alignment.bottomCenter,
                    transform: _perspective()..rotateX(bottomRotation),
                    child: bottomWidget,
                  ),
                ),
              ),
              // Ana sayfa (aşağıdan geliyor)
              Visibility(
                visible: phaseValue > 0.05,
                child: FractionalTranslation(
                  translation: topOffset,
                  child: Transform(
                    alignment: Alignment.topCenter,
                    transform: _perspective()..rotateX(topRotation),
                    child: topWidget,
                  ),
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
