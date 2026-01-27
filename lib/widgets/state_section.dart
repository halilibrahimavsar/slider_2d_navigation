import 'package:flutter/material.dart';
import '../models/slider_state.dart';
import '../utils/slider_state_helper.dart';
import '../constants/slider_constants.dart';

class StateSection extends StatelessWidget {
  final SliderState targetState;
  final bool isActive;
  final VoidCallback onTap;
  final double sectionWidth;

  const StateSection({
    super.key,
    required this.targetState,
    required this.isActive,
    required this.onTap,
    required this.sectionWidth,
  });

  @override
  Widget build(BuildContext context) {
    final label = SliderStateHelper.getStateLabel(targetState);
    final icon = SliderStateHelper.getStateIcon(targetState);
    final baseColor = SliderStateHelper.getStateColor(targetState);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.translucent,
      child: Container(
        width: sectionWidth,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        color: Colors.transparent,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: isActive ? 0.0 : 1.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isActive ? baseColor : baseColor.withValues(alpha: 0.9),
                size: isActive ? 24 : 20,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: (isActive
                        ? SliderConstants.activeStateLabelStyle
                        : SliderConstants.stateLabelStyle)
                    .copyWith(
                  color:
                      isActive ? baseColor : baseColor.withValues(alpha: 0.4),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
