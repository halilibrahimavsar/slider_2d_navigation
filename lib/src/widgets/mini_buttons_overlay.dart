import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:ui';
import '../models/main_page_model.dart';

/// Mini butonların overlay olarak gösterildiği widget
class MiniButtonsOverlay extends StatefulWidget {
  /// Slider button pozisyonu
  final Offset position;

  /// Slider button boyutu
  final Size knobSize;

  /// Gösterilecek butonlar
  final List<MiniButtonData> buttons;

  /// Slider'ın yatay değeri (sol/sağ kenar optimizasyonu için)
  final double sliderValue;

  /// Butona tıklandığında çağrılacak callback
  final Function(int) onButtonTap;

  /// Overlay kapatma callback'i
  final VoidCallback onDismiss;

  const MiniButtonsOverlay({
    super.key,
    required this.position,
    required this.knobSize,
    required this.buttons,
    required this.sliderValue,
    required this.onButtonTap,
    required this.onDismiss,
  });

  @override
  State<MiniButtonsOverlay> createState() => _MiniButtonsOverlayState();
}

class _MiniButtonsOverlayState extends State<MiniButtonsOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onDismiss,
      behavior: HitTestBehavior.opaque,
      child: Stack(
        children: [
          // Arka plan blur efekti
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(color: Colors.black.withValues(alpha: 0.2)),
          ),

          // Mini butonlar
          ...List.generate(widget.buttons.length, (index) {
            // Temel açı yukarı doğru (90 derece)
            double baseAngle = math.pi / 2;
            double spread = 0.8;

            // Sol kenardaysa sola aç, sağ kenardaysa sağa aç
            if (widget.sliderValue < 0.2) {
              baseAngle -= 0.3;
            } else if (widget.sliderValue > 0.8) {
              baseAngle += 0.3;
            }

            // Butonları yay şeklinde yerleştir
            double angle =
                baseAngle + (index - (widget.buttons.length - 1) / 2) * spread;
            double distance = 90.0;

            double offsetX = math.cos(angle) * distance;
            double offsetY = -math.sin(angle) * distance;

            return AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final curvedValue = Curves.easeOutBack.transform(
                  _controller.value,
                );
                return Positioned(
                  left:
                      widget.position.dx +
                      widget.knobSize.width / 2 +
                      (offsetX * curvedValue) -
                      30,
                  top:
                      widget.position.dy +
                      widget.knobSize.height / 2 +
                      (offsetY * curvedValue) -
                      30,
                  child: Opacity(
                    opacity: _controller.value,
                    child: GestureDetector(
                      onTap: () => widget.onButtonTap(index),
                      child: SizedBox(
                        width: 60,
                        height: 80,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Buton ikonu
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    widget.buttons[index].color,
                                    widget.buttons[index].color.withValues(
                                      alpha: 0.7,
                                    ),
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: widget.buttons[index].color
                                        .withValues(alpha: 0.4),
                                    blurRadius: 15,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Icon(
                                widget.buttons[index].icon,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            const SizedBox(height: 6),

                            // Buton etiketi
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.1),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                              child: Text(
                                widget.buttons[index].label,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: widget.buttons[index].color,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }),
        ],
      ),
    );
  }
}
