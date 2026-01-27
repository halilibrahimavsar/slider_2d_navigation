import 'package:flutter/material.dart';

class VerticalMiniCarousel extends StatefulWidget {
  final List<Widget> children;
  final ValueChanged<int>? onChanged;
  final FixedExtentScrollController? controller;
  final ScrollPhysics? physics;

  // Dışarıdan erişim için statik sabitler
  static const double itemHeight = 48.0;
  static const double totalHeight = itemHeight * 4;

  const VerticalMiniCarousel({
    super.key,
    required this.children,
    this.onChanged,
    this.controller,
    this.physics,
  });

  @override
  State<VerticalMiniCarousel> createState() => _VerticalMiniCarouselState();
}

class _VerticalMiniCarouselState extends State<VerticalMiniCarousel> {
  late final FixedExtentScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? FixedExtentScrollController();
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: VerticalMiniCarousel.totalHeight,
      child: ListWheelScrollView.useDelegate(
        controller: _controller,
        itemExtent: VerticalMiniCarousel.itemHeight,
        perspective: 0.009,
        diameterRatio: 1.5,
        physics: widget.physics ?? const FixedExtentScrollPhysics(),
        onSelectedItemChanged: widget.onChanged,
        // Seçili olmayanları hafif silikleştir
        childDelegate: ListWheelChildBuilderDelegate(
          childCount: widget.children.length,
          builder: (context, index) {
            return GestureDetector(
              onTap: () {
                // Tıklanan öğeyi merkeze getir
                _controller.animateToItem(
                  index,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              child: Center(
                child: SizedBox(
                  height: VerticalMiniCarousel.itemHeight,
                  child: widget.children[index],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
