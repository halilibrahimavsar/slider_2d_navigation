import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;
import '../models/slider_state.dart';
import '../models/mini_button_data.dart';
import '../models/sub_menu_item.dart';
import '../constants/slider_constants.dart';
import '../utils/slider_state_helper.dart';
import '../widgets/mini_buttons_overlay.dart';
import '../widgets/sub_menu_tags.dart';
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
  int? _selectedSubMenuIndex;
  SliderState? _lastState;

  @override
  void initState() {
    super.initState();
    _lastState = _getCurrentState(widget.controller.value);
    widget.controller.addListener(_handleControllerChange);
  }

  @override
  void dispose() {
    _removeMiniButtons();
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
      _selectedSubMenuIndex = null;
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
    final size = renderBox.size;
    final sliderValue = widget.controller.value;

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

  Widget _buildKnob(double value, double knobLeft, Color activeColor) {
    final state = _getCurrentState(value);
    final subItems = widget.subMenuItems[state] ?? [];

    String knobLabel = _getStateLabel(state);
    if (_selectedSubMenuIndex != null &&
        _selectedSubMenuIndex! < subItems.length) {
      knobLabel = subItems[_selectedSubMenuIndex!].label.toUpperCase();
    }

    return Positioned(
      left: knobLeft,
      top: SliderConstants.knobPadding,
      child: GestureDetector(
        key: _knobKey,
        onHorizontalDragStart: (_) => setState(() => _dragging = true),
        onHorizontalDragUpdate: (details) {
          double newValue = (widget.controller.value +
                  details.delta.dx / (_widgetWidth - SliderConstants.knobWidth))
              .clamp(0.0, 1.0);
          widget.controller.value = newValue;
          widget.onValueChanged?.call(newValue);
        },
        onHorizontalDragEnd: (_) {
          setState(() => _dragging = false);
          final target = SliderStateHelper.getTargetValueForState(
              state, SliderState.values.length);
          _navigateToState(target);
          HapticFeedback.heavyImpact();
        },
        onTap: () {
          _toggleMiniButtons();
          widget.onTap?.call(state);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: SliderConstants.knobSize,
          width: SliderConstants.knobSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
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
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              ClipRRect(
                borderRadius:
                    BorderRadius.circular(SliderConstants.knobSize / 2),
                child: BackdropFilter(
                  filter: ui.ImageFilter.blur(sigmaX: 5, sigmaY: 5),
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
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                transitionBuilder: (child, animation) => FadeTransition(
                  opacity: animation,
                  child: ScaleTransition(scale: animation, child: child),
                ),
                child: AnimatedDefaultTextStyle(
                  key: ValueKey(knobLabel),
                  duration: const Duration(milliseconds: 200),
                  style: SliderConstants.knobLabelStyle.copyWith(
                    fontSize: _dragging ? 12 : 10,
                  ),
                  child: Text(knobLabel),
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
                              setState(() => _selectedSubMenuIndex = null);
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
                    ),
                  ],
                ),
              ),
              if (subItems.isNotEmpty) ...[
                const SizedBox(height: 6),
                SubMenuTags(
                  items: subItems,
                  currentState: state,
                  selectedIndex: _selectedSubMenuIndex,
                  onTap: (index) {
                    if (_selectedSubMenuIndex == index) {
                      setState(() => _selectedSubMenuIndex = null);
                      widget.onTap?.call(state);
                    } else {
                      setState(() => _selectedSubMenuIndex = index);
                      subItems[index].onTap();
                    }
                    HapticFeedback.selectionClick();
                  },
                ),
              ],
            ],
          );
        },
      );
    });
  }
}
