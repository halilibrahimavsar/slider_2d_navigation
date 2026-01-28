import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:slider_2d_navigation/widgets/vertical_mini_crousel.dart';
import 'dart:ui' as ui;
import '../models/slider_state.dart';
import '../models/mini_button_data.dart';
import '../models/sub_menu_item.dart';
import '../constants/slider_constants.dart';
import '../utils/slider_state_helper.dart';
import '../widgets/mini_buttons_overlay.dart';
import '../widgets/state_section.dart';

class DynamicSliderButton extends StatefulWidget {
  final AnimationController controller;
  final ValueChanged<double>? onValueChanged;
  final ValueChanged<SliderState>? onTap;
  final Map<SliderState, List<MiniButtonData>> miniButtons;
  final Map<SliderState, List<SubMenuItem>> subMenuItems;

  const DynamicSliderButton({
    super.key,
    required this.controller,
    this.onValueChanged,
    this.onTap,
    this.miniButtons = const {},
    this.subMenuItems = const {},
  });

  @override
  State<DynamicSliderButton> createState() => _DynamicSliderButtonState();
}

class _DynamicSliderButtonState extends State<DynamicSliderButton>
    with TickerProviderStateMixin {
  bool _dragging = false;
  double _widgetWidth = 0.0;
  bool _showMiniButtons = false;
  OverlayEntry? _overlayEntry;
  final GlobalKey _knobKey = GlobalKey();
  SliderState? _lastState;
  late FixedExtentScrollController _carouselController;

  @override
  void initState() {
    super.initState();
    _carouselController = FixedExtentScrollController();
    _lastState = _getCurrentState(widget.controller.value);
    widget.controller.addListener(_handleControllerChange);
  }

  @override
  void dispose() {
    _removeMiniButtons();
    _carouselController.dispose();
    widget.controller.removeListener(_handleControllerChange);
    super.dispose();
  }

  void _handleControllerChange() {
    if (_dragging && _showMiniButtons) {
      _hideMiniButtons();
    }

    final currentState = _getCurrentState(widget.controller.value);
    if (_lastState != currentState) {
      HapticFeedback.heavyImpact();
      _lastState = currentState;

      // State değiştiğinde carousel'ı ilk öğeye sıfırla
      _carouselController.animateToItem(
        0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    }
  }

  SliderState _getCurrentState(double value) {
    return SliderStateHelper.getStateFromValue(
        value, SliderState.values.length);
  }

  Color _getActiveColor(double value) {
    final state = _getCurrentState(value);
    return SliderStateHelper.getStateColor(state);
  }

  String _getStateLabel(SliderState state) {
    return SliderStateHelper.getStateLabel(state);
  }

  void _showMiniButtonsOverlay() {
    final state = _getCurrentState(widget.controller.value);
    final buttons = widget.miniButtons[state] ?? [];
    if (buttons.isEmpty) return;

    final RenderBox? renderBox =
        _knobKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final position = renderBox.localToGlobal(Offset.zero);
    final sliderValue = widget.controller.value;

    _overlayEntry = OverlayEntry(
      builder: (context) => Material(
        type: MaterialType.transparency,
        child: MiniButtonsOverlay(
          position: position,
          knobSize: Size(SliderConstants.knobWidth, SliderConstants.knobHeight),
          buttons: buttons,
          sliderValue: sliderValue,
          onButtonTap: (index) {
            buttons[index].onTap();
            _hideMiniButtons();
          },
          onDismiss: _hideMiniButtons,
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideMiniButtons() {
    setState(() => _showMiniButtons = false);
    _removeMiniButtons();
  }

  void _removeMiniButtons() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _toggleMiniButtons() {
    if (_showMiniButtons) {
      _hideMiniButtons();
    } else {
      setState(() => _showMiniButtons = true);
      _showMiniButtonsOverlay();
    }
  }

  void _navigateToState(double target) {
    widget.controller.animateTo(
      target,
      duration: SliderConstants.animationDuration,
      curve: SliderConstants.animationCurve,
    );
    HapticFeedback.mediumImpact();
  }

  Widget _buildKnob(
    double value,
    double knobLeft,
    Color activeColor,
    List<SubMenuItem> subItems,
  ) {
    final state = _getCurrentState(value);
    final rawSubItems = widget.subMenuItems[state] ?? [];

    String knobLabel = _getStateLabel(state);

    // Carousel listesini oluştur: Başlık + Alt Menü Öğeleri
    List<SubMenuItem> carouselItems = [];
    if (rawSubItems.isNotEmpty) {
      carouselItems = [
        SubMenuItem(
            onTap: () {},
            label: knobLabel,
            icon: Icons.title), // Başlık öğesi (Index 0)
        ...rawSubItems
      ];
    }

    return Positioned(
      left: knobLeft,
      top: SliderConstants.knobPadding,
      child: GestureDetector(
        key: _knobKey,
        onHorizontalDragStart: (_) => setState(() => _dragging = true),
        onHorizontalDragUpdate: (details) {
          final newValue = (widget.controller.value +
                  details.delta.dx / (_widgetWidth - SliderConstants.knobWidth))
              .clamp(0.0, 1.0);
          widget.controller.value = newValue;
          widget.onValueChanged?.call(newValue);
        },
        onHorizontalDragEnd: (_) {
          setState(() => _dragging = false);
          final target = SliderStateHelper.getTargetValueForState(
            state,
            SliderState.values.length,
          );
          _navigateToState(target);
          HapticFeedback.heavyImpact();
        },
        // DİKEY SÜRÜKLEME (SUB MENU KONTROLÜ)
        onVerticalDragUpdate: (details) {
          if (carouselItems.isEmpty) return;
          // Parmağın tersine hareket etmesi doğal scroll hissidir
          final double newOffset =
              _carouselController.offset - details.delta.dy;
          _carouselController.jumpTo(newOffset);
        },
        onVerticalDragEnd: (details) {
          if (carouselItems.isEmpty) return;
          // En yakın öğeye hizala (Snap)
          final double itemHeight = VerticalMiniCarousel.itemHeight;
          int targetIndex = (_carouselController.offset / itemHeight).round();

          // Sınırları kontrol et
          targetIndex = targetIndex.clamp(0, carouselItems.length - 1);

          _carouselController.animateToItem(
            targetIndex,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutBack,
          );
        },
        onTap: () {
          _toggleMiniButtons();
          widget.onTap?.call(state);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: SliderConstants.knobHeight,
          width: SliderConstants.knobWidth,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(SliderConstants.knobHeight / 2),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                activeColor,
                activeColor.withValues(alpha: 0.8),
              ],
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
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              // 🟦 CAM / GLASS KNOB (SADECE ARKA PLAN)
              ClipRRect(
                borderRadius:
                    BorderRadius.circular(SliderConstants.knobHeight / 2),
                child: BackdropFilter(
                  filter: ui.ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Container(
                    height: SliderConstants.knobHeight,
                    width: SliderConstants.knobWidth,
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(SliderConstants.knobHeight / 2),
                      color: Colors.white.withValues(alpha: 0.2),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.3),
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
              ),

              // 🟣 CAROUSEL — Knob'un içinde ortalanmış
              Positioned(
                // Knob yüksekliğinden Carousel yüksekliğini çıkarıp 2'ye bölerek ortalıyoruz
                top: (SliderConstants.knobHeight -
                        VerticalMiniCarousel.totalHeight) /
                    2,
                height: VerticalMiniCarousel.totalHeight,
                left: 0,
                right: 0,
                child: IgnorePointer(
                  // Artık her zaman ignore ediyoruz çünkü kontrolü üstteki GestureDetector yapıyor
                  ignoring: true,
                  child: ShaderMask(
                    shaderCallback: (rect) {
                      return LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          activeColor, // Üst kısım (Dışarıda) - Renkli
                          activeColor,
                          Colors.white, // Orta kısım (Knob içi) - Beyaz
                          Colors.white,
                          activeColor,
                          activeColor, // Alt kısım (Dışarıda) - Renkli
                        ],
                        // Geçiş noktaları: %40 ile %60 arası tam merkezdir
                        stops: const [0.0, 0.35, 0.42, 0.58, 0.65, 1.0],
                      ).createShader(rect);
                    },
                    blendMode: BlendMode.srcIn,
                    child: VerticalMiniCarousel(
                      controller: _carouselController,
                      physics: const NeverScrollableScrollPhysics(),
                      onTap: (index) {
                        // Başlık öğesi (Index 0) için ontap tetikleme
                        if (index > 0 && index < carouselItems.length) {
                          carouselItems[index].onTap();
                          HapticFeedback.lightImpact();
                        }
                      },
                      children: carouselItems.map((item) {
                        return Center(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              item.label,
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: SliderConstants.knobLabelStyle.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -0.6,
                                color: Colors.white, // Maskeleme için baz renk
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (index) {
                        HapticFeedback.selectionClick();
                      },
                    ),
                  ),
                ),
              ),

              // ➕ PLUS ICON
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
                      )
                    ],
                  ),
                  child: Icon(
                    Icons.add,
                    color: activeColor,
                    size: 20,
                  ),
                ),
              ),

              // 🏷 LABEL
              // Eğer carousel doluysa (alt menü varsa), başlık zaten carousel içinde (Index 0) olacağı için
              // buradaki sabit etiketi gizliyoruz. Sadece alt menü yoksa gösteriyoruz.
              AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: carouselItems.isNotEmpty ? 0.0 : 1.0,
                child: Center(
                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 200),
                    style: SliderConstants.knobLabelStyle.copyWith(
                      fontSize: _dragging ? 12 : 10,
                      color: Colors.white,
                      shadows: [
                        Shadow(color: Colors.black26, blurRadius: 2),
                      ],
                    ),
                    child: Text(knobLabel),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      _widgetWidth = constraints.maxWidth;
      return AnimatedBuilder(
        animation: widget.controller,
        builder: (context, child) {
          final value = widget.controller.value;
          final state = _getCurrentState(value);
          final activeColor = _getActiveColor(value);
          final subItems = widget.subMenuItems[state] ?? [];
          final sectionWidth = _widgetWidth / SliderState.values.length;

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: SliderConstants.sliderHeight,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Slider background
                    Positioned(
                      top: SliderConstants.trackPadding,
                      bottom: SliderConstants.trackPadding,
                      left: 0,
                      right: 0,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          borderRadius: SliderConstants.trackBorderRadius,
                          color: activeColor.withValues(alpha: 0.08),
                          boxShadow: [
                            BoxShadow(
                              color: activeColor.withValues(alpha: 0.15),
                              blurRadius: 20,
                              spreadRadius: 2,
                            )
                          ],
                        ),
                      ),
                    ),
                    // Slider headers
                    for (int i = 0; i < SliderState.values.length; i++)
                      Positioned(
                        left: i * sectionWidth,
                        top: 0,
                        bottom: 0,
                        child: StateSection(
                          targetState: SliderState.values[i],
                          isActive: state == SliderState.values[i],
                          onTap: () {
                            if (state == SliderState.values[i]) {
                              widget.onTap?.call(SliderState.values[i]);
                            }
                            final target =
                                SliderStateHelper.getTargetValueForState(
                                    SliderState.values[i],
                                    SliderState.values.length);
                            _navigateToState(target);
                          },
                          sectionWidth: sectionWidth,
                        ),
                      ),
                    _buildKnob(
                      value,
                      SliderConstants.trackPadding +
                          (value * (_widgetWidth - SliderConstants.knobWidth)),
                      activeColor,
                      subItems,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      );
    });
  }
}
