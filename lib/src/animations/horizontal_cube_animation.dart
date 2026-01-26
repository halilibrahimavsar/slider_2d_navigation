import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Yatay 3D Küp Animasyonu
/// 3 ana sayfa arasında geçiş için kullanılır (sola-sağa)
class HorizontalCubeAnimation extends StatelessWidget {
  /// Animasyon controller'ı (0.0 - 1.0)
  final AnimationController controller;

  /// Sol sayfa widget'ı (value = 0.0)
  final Widget leftWidget;

  /// Orta sayfa widget'ı (value = 0.5)
  final Widget centerWidget;

  /// Sağ sayfa widget'ı (value = 1.0)
  final Widget rightWidget;

  const HorizontalCubeAnimation({
    super.key,
    required this.controller,
    required this.leftWidget,
    required this.centerWidget,
    required this.rightWidget,
  });

  Matrix4 _perspective() => Matrix4.identity()..setEntry(3, 2, 0.001);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final double value = controller.value;

        final Widget outgoingWidget;
        final Widget incomingWidget;
        final double phaseValue;

        if (value < 0.5) {
          // FAZ 1: Sol -> Orta (0.0 - 0.5)
          outgoingWidget = leftWidget;
          incomingWidget = centerWidget;
          phaseValue = value * 2;
        } else {
          // FAZ 2: Orta -> Sağ (0.5 - 1.0)
          outgoingWidget = centerWidget;
          incomingWidget = rightWidget;
          phaseValue = (value - 0.5) * 2;
        }

        final outgoingRotation = Tween(
          begin: 0.0,
          end: math.pi / 2.2,
        ).transform(phaseValue);
        final outgoingOffset = Tween<Offset>(
          begin: Offset.zero,
          end: const Offset(-1.0, 0.0),
        ).transform(phaseValue);

        final incomingRotation = Tween(
          begin: -math.pi / 2.2,
          end: 0.0,
        ).transform(phaseValue);
        final incomingOffset = Tween<Offset>(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).transform(phaseValue);

        return Stack(
          alignment: Alignment.center,
          children: [
            // Çıkan widget (sola kayıyor)
            Visibility(
              visible: phaseValue < 0.95,
              child: FractionalTranslation(
                translation: outgoingOffset,
                child: Transform(
                  alignment: Alignment.centerRight,
                  transform: _perspective()..rotateY(outgoingRotation),
                  child: outgoingWidget,
                ),
              ),
            ),
            // Giren widget (sağdan geliyor)
            Visibility(
              visible: phaseValue > 0.05,
              child: FractionalTranslation(
                translation: incomingOffset,
                child: Transform(
                  alignment: Alignment.centerLeft,
                  transform: _perspective()..rotateY(incomingRotation),
                  child: incomingWidget,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
