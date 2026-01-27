import 'package:flutter/material.dart';
import '../models/slider_state.dart';
import '../models/sub_menu_item.dart';
import '../constants/slider_constants.dart';
import '../utils/slider_state_helper.dart';

class SubMenuTags extends StatelessWidget {
  final List<SubMenuItem> items;
  final SliderState currentState;
  final int? selectedIndex;
  final Function(int) onTap;

  const SubMenuTags({
    super.key,
    required this.items,
    required this.currentState,
    this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    final activeColor = SliderStateHelper.getStateColor(currentState);

    return Wrap(
      spacing: SliderConstants.subMenuSpacing,
      runSpacing: SliderConstants.subMenuRunSpacing,
      alignment: WrapAlignment.center,
      children: List.generate(items.length, (index) {
        final isSelected = selectedIndex == index;
        return GestureDetector(
          onTap: () => onTap(index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: SliderConstants.subMenuPadding,
            decoration: BoxDecoration(
              color: isSelected
                  ? activeColor.withValues(alpha: 0.1)
                  : Colors.transparent,
              borderRadius: SliderConstants.subMenuBorderRadius,
              border: isSelected
                  ? Border.all(
                      color: activeColor.withValues(alpha: 0.3), width: 1)
                  : Border.all(color: Colors.transparent),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  items[index].icon,
                  size: 16,
                  color: isSelected
                      ? activeColor
                      : Colors.grey.withValues(alpha: 0.6),
                ),
                const SizedBox(width: 6),
                Text(
                  items[index].label,
                  style: SliderConstants.subMenuTextStyle.copyWith(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color: isSelected
                        ? activeColor
                        : Colors.grey.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
