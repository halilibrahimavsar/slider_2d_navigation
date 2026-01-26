import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import '../controllers/slider_2d_controller.dart';
import '../models/main_page_model.dart';
import 'mini_buttons_overlay.dart';
import 'sub_page_indicator.dart';

/// 2D Slider Button
/// Yatay: Ana sayfalar arası geçiş
/// Dikey: Alt sayfalar arası geçiş
class SliderButton2D extends StatefulWidget {
  /// Controller
  final Slider2DController controller;

  const SliderButton2D({super.key, required this.controller});

  @override
  State<SliderButton2D> createState() => _SliderButton2DState();
}

class _SliderButton2DState extends State<SliderButton2D> {
  bool _dragging = false;
  double _widgetWidth = 0.0;
  OverlayEntry? _overlayEntry;
  final GlobalKey _knobKey = GlobalKey();

  // Dikey sürükleme için
  double _dragStartY = 0.0;
  double _currentDragY = 0.0;
  bool _isVerticalDrag = false;
  static const double _verticalDragThreshold = 40.0;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onControllerChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerChanged);
    _removeMiniButtons();
    super.dispose();
  }

  void _onControllerChanged() {
    if (mounted) {
      setState(() {});

      // Sürüklerken mini butonları gizle
      if (_dragging && widget.controller.state.showMiniButtons) {
        widget.controller.hideMiniButtons();
      }
    }
  }

  Color _getActiveColor() {
    final mainPage = widget.controller.currentMainPage;
    return mainPage.color;
  }

  String _getKnobLabel() {
    final state = widget.controller.state;
    final mainPage = widget.controller.currentMainPage;

    // Alt sayfadaysa alt sayfa adını göster
    if (!state.isOnMainPage) {
      final subPage = widget.controller.currentSubPage;
      if (subPage != null) {
        return subPage.label.toUpperCase();
      }
    }

    // Ana sayfadaysa ana sayfa adını göster
    return mainPage.label.toUpperCase();
  }

  void _showMiniButtonsOverlay() {
    final buttons = widget.controller.currentMainPage.miniButtons;
    if (buttons.isEmpty) return;

    final RenderBox? renderBox =
        _knobKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;
    final sliderValue = widget.controller.horizontalController.value;

    _overlayEntry = OverlayEntry(
      builder: (context) => Material(
        type: MaterialType.transparency,
        child: MiniButtonsOverlay(
          position: position,
          knobSize: size,
          buttons: buttons,
          sliderValue: sliderValue,
          onButtonTap: (index) {
            buttons[index].onTap();
            widget.controller.hideMiniButtons();
            _removeMiniButtons();
          },
          onDismiss: () {
            widget.controller.hideMiniButtons();
            _removeMiniButtons();
          },
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeMiniButtons() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _handleDragStart(DragStartDetails details) {
    setState(() {
      _dragging = true;
      _dragStartY = details.globalPosition.dy;
      _currentDragY = 0.0;
      _isVerticalDrag = false;
    });
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    final deltaX = details.delta.dx;
    final deltaY = details.delta.dy;

    _currentDragY += deltaY;

    // Dikey mi yatay mı belirleniyor
    if (!_isVerticalDrag && _currentDragY.abs() > _verticalDragThreshold) {
      _isVerticalDrag = true;
      HapticFeedback.mediumImpact();
    }

    if (_isVerticalDrag) {
      // Dikey sürükleme - henüz görsel feedback yok, sadece işaretle
      setState(() {});
    } else {
      // Yatay sürükleme
      double newValue = (widget.controller.horizontalController.value +
              deltaX / (_widgetWidth - 70))
          .clamp(0.0, 1.0);
      widget.controller.updateHorizontalValue(newValue);
    }
  }

  void _handleDragEnd(DragEndDetails details) {
    if (_isVerticalDrag) {
      // Dikey sürükleme bitti
      _handleVerticalDragEnd();
    } else {
      // Yatay sürükleme bitti
      _handleHorizontalDragEnd();
    }

    setState(() {
      _dragging = false;
      _isVerticalDrag = false;
      _currentDragY = 0.0;
    });
  }

  void _handleVerticalDragEnd() {
    final subPages = widget.controller.currentMainPage.subPages;
    if (subPages.isEmpty) return;

    final state = widget.controller.state;

    if (_currentDragY > _verticalDragThreshold) {
      // Aşağı sürüklendi
      if (state.isOnMainPage) {
        // Ana sayfadaysa ilk alt sayfaya git
        widget.controller.goToSubPage(0);
        HapticFeedback.heavyImpact();
      } else {
        // Alt sayfadaysa bir sonraki alt sayfaya git
        final nextIndex = state.subPageIndex + 1;
        if (nextIndex < subPages.length) {
          widget.controller.goToSubPage(nextIndex);
          HapticFeedback.heavyImpact();
        }
      }
    } else if (_currentDragY < -_verticalDragThreshold) {
      // Yukarı sürüklendi
      if (!state.isOnMainPage) {
        if (state.subPageIndex == 0) {
          // İlk alt sayfadaysa ana sayfaya dön
          widget.controller.goToMainPageLevel();
          HapticFeedback.heavyImpact();
        } else {
          // Bir önceki alt sayfaya git
          final prevIndex = state.subPageIndex - 1;
          widget.controller.goToSubPage(prevIndex);
          HapticFeedback.heavyImpact();
        }
      }
    }
  }

  void _handleHorizontalDragEnd() {
    final value = widget.controller.horizontalController.value;
    final targetIndex = value < 0.33 ? 0 : (value > 0.66 ? 2 : 1);
    widget.controller.goToMainPage(targetIndex);
    HapticFeedback.heavyImpact();
  }

  void _handleTap() {
    if (widget.controller.state.showMiniButtons) {
      widget.controller.hideMiniButtons();
      _removeMiniButtons();
    } else {
      widget.controller.toggleMiniButtons();
      _showMiniButtonsOverlay();
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        _widgetWidth = constraints.maxWidth;

        final state = widget.controller.state;
        final mainPage = widget.controller.currentMainPage;
        final activeColor = _getActiveColor();
        final knobLabel = _getKnobLabel();
        final subPages = mainPage.subPages;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ANA SLIDER
            SizedBox(
              height: 80,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Track (arka plan)
                  Positioned(
                    top: 5,
                    bottom: 5,
                    left: 0,
                    right: 0,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(35),
                        color: activeColor.withValues(alpha: 0.08),
                        boxShadow: [
                          BoxShadow(
                            color: activeColor.withValues(alpha: 0.15),
                            blurRadius: 20,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Ana sayfa bölümleri
                  ...List.generate(widget.controller.mainPages.length, (index) {
                    final page = widget.controller.mainPages[index];
                    final isActive = state.mainPageIndex == index;

                    return Positioned(
                      left: index * (_widgetWidth / 3),
                      top: 0,
                      bottom: 0,
                      child: _buildStateSection(
                        page,
                        isActive,
                        () => widget.controller.goToMainPage(index),
                      ),
                    );
                  }),

                  // Knob (gezici gösterge)
                  _buildKnob(activeColor, knobLabel),
                ],
              ),
            ),

            // ALT SAYFA GÖSTERGESİ
            if (subPages.isNotEmpty) ...[
              const SizedBox(height: 6),
              SubPageIndicator(
                subPages: subPages,
                selectedIndex: state.subPageIndex,
                activeColor: activeColor,
                onSelect: (index) {
                  if (state.subPageIndex == index) {
                    // Zaten seçiliyse ana sayfaya dön
                    widget.controller.goToMainPageLevel();
                  } else {
                    // Alt sayfaya git
                    widget.controller.goToSubPage(index);
                  }
                  HapticFeedback.selectionClick();
                },
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildStateSection(MainPage page, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.translucent,
      child: Container(
        width: _widgetWidth / 3,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        color: Colors.transparent,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: isActive ? 0.0 : 1.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                page.icon,
                color:
                    isActive ? page.color : page.color.withValues(alpha: 0.9),
                size: isActive ? 24 : 20,
              ),
              const SizedBox(height: 4),
              Text(
                page.label,
                style: TextStyle(
                  fontSize: isActive ? 11 : 10,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                  color:
                      isActive ? page.color : page.color.withValues(alpha: 0.4),
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKnob(Color activeColor, String label) {
    final value = widget.controller.horizontalController.value;

    return Positioned(
      left: 5 + (value * (_widgetWidth - 70)),
      top: 10,
      child: GestureDetector(
        key: _knobKey,
        onPanStart: _handleDragStart,
        onPanUpdate: _handleDragUpdate,
        onPanEnd: _handleDragEnd,
        onTap: _handleTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [activeColor, activeColor.withValues(alpha: 0.8)],
            ),
            boxShadow: [
              BoxShadow(
                color: activeColor.withValues(alpha: 0.6),
                blurRadius: _dragging ? 30 : 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              // Glassmorphism efekti
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.2),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.3),
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
              ),

              // + ikonu (üstte)
              Positioned(
                top: -12,
                child: Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(Icons.add, color: activeColor, size: 20),
                ),
              ),

              // Etiket
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                transitionBuilder: (child, animation) => FadeTransition(
                  opacity: animation,
                  child: ScaleTransition(scale: animation, child: child),
                ),
                child: AnimatedDefaultTextStyle(
                  key: ValueKey(label),
                  duration: const Duration(milliseconds: 200),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: _dragging ? 12 : 10,
                    fontWeight: FontWeight.bold,
                  ),
                  child: Text(label),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
