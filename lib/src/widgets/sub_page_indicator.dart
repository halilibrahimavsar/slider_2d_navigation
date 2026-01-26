import 'package:flutter/material.dart';
import '../models/sub_page_model.dart';

/// Alt sayfa göstergesi
/// Alt sayfaları tag şeklinde gösterir
class SubPageIndicator extends StatelessWidget {
  /// Gösterilecek alt sayfalar
  final List<SubPage> subPages;

  /// Seçili alt sayfa indeksi (-1 ise hiçbiri seçili değil)
  final int selectedIndex;

  /// Aktif renk
  final Color activeColor;

  /// Seçim callback'i
  final Function(int) onSelect;

  const SubPageIndicator({
    super.key,
    required this.subPages,
    required this.selectedIndex,
    required this.activeColor,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    if (subPages.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: 12,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: List.generate(subPages.length, (index) {
        final isSelected = selectedIndex == index;
        final subPage = subPages[index];

        return GestureDetector(
          onTap: () => onSelect(index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color:
                  isSelected
                      ? activeColor.withValues(alpha: 0.1)
                      : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
              border:
                  isSelected
                      ? Border.all(
                        color: activeColor.withValues(alpha: 0.3),
                        width: 1,
                      )
                      : Border.all(color: Colors.transparent),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  subPage.icon,
                  size: 16,
                  color:
                      isSelected
                          ? activeColor
                          : Colors.grey.withValues(alpha: 0.6),
                ),
                const SizedBox(width: 6),
                Text(
                  subPage.label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color:
                        isSelected
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
