import 'package:flutter/material.dart';
import '../models/slider_state.dart';
import '../models/sub_menu_item.dart';

class InteractiveSubMenuCarousel extends StatefulWidget {
  final List<SubMenuItem> items;
  final SliderState currentState;
  final int? selectedIndex;
  final Function(int) onTap;
  final String mainTitle;
  final Color activeColor;

  const InteractiveSubMenuCarousel({
    super.key,
    required this.items,
    required this.currentState,
    this.selectedIndex,
    required this.onTap,
    required this.mainTitle,
    required this.activeColor,
  });

  @override
  State<InteractiveSubMenuCarousel> createState() =>
      _InteractiveSubMenuCarouselState();
}

class _InteractiveSubMenuCarouselState extends State<InteractiveSubMenuCarousel>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _fadeController;
  bool _isExpanded = false;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });

    if (_isExpanded) {
      _slideController.forward();
      _fadeController.forward();
    } else {
      _slideController.reverse();
      _fadeController.reverse();
    }
  }

  void _onItemTap(int index) {
    setState(() => _currentIndex = index);
    widget.onTap(index);

    if (_isExpanded) {
      _toggleExpanded();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Ana başlık (sürüklenebilir)
        GestureDetector(
          onVerticalDragUpdate: (details) {
            if (details.delta.dy < -2 && !_isExpanded) {
              _toggleExpanded();
            } else if (details.delta.dy > 2 && _isExpanded) {
              _toggleExpanded();
            }
          },
          onTap: _toggleExpanded,
          child: AnimatedBuilder(
            animation: _slideController,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, -_slideController.value * 50),
                child: Opacity(
                  opacity: 1 - _fadeController.value,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: widget.activeColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: widget.activeColor.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.expand_more,
                              color: widget.activeColor,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              widget.mainTitle,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: widget.activeColor,
                              ),
                            ),
                            if (widget.selectedIndex != null) ...[
                              const SizedBox(width: 8),
                              Text(
                                '• ${widget.items[widget.selectedIndex!].label}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color:
                                      widget.activeColor.withValues(alpha: 0.7),
                                ),
                              ),
                            ],
                          ],
                        ),
                        Icon(
                          _isExpanded ? Icons.expand_less : Icons.expand_more,
                          color: widget.activeColor,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        // Carousel submenu
        const SizedBox(height: 8),
        AnimatedBuilder(
          animation: _slideController,
          builder: (context, child) {
            return Container(
              height: 80 + (_slideController.value * 120),
              child: Stack(
                children: [
                  // Normal görünüm (compact)
                  if (!_isExpanded) _buildCompactCarousel(),

                  // Genişletilmiş görünüm (expanded)
                  if (_isExpanded) _buildExpandedCarousel(),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildCompactCarousel() {
    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.items.length,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemBuilder: (context, index) {
          final isSelected = widget.selectedIndex == index;
          return GestureDetector(
            onTap: () => _onItemTap(index),
            child: Container(
              width: 100,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? widget.activeColor.withValues(alpha: 0.15)
                    : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? widget.activeColor.withValues(alpha: 0.5)
                      : Colors.grey.withValues(alpha: 0.3),
                  width: isSelected ? 2 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    widget.items[index].icon,
                    size: 24,
                    color: isSelected
                        ? widget.activeColor
                        : Colors.grey.withValues(alpha: 0.6),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.items[index].label,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.w500,
                      color: isSelected
                          ? widget.activeColor
                          : Colors.grey.withValues(alpha: 0.7),
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildExpandedCarousel() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // Genişletilmiş başlık
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: widget.activeColor.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.menu,
                  color: widget.activeColor,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  '${widget.mainTitle} Menü',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: widget.activeColor,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: _toggleExpanded,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: widget.activeColor.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: widget.activeColor,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Genişletilmiş carousel
          Expanded(
            child: PageView.builder(
              itemCount: widget.items.length,
              onPageChanged: (index) {
                setState(() => _currentIndex = index);
              },
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => _onItemTap(index),
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          widget.activeColor.withValues(alpha: 0.1),
                          widget.activeColor.withValues(alpha: 0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: widget.activeColor.withValues(alpha: 0.3),
                        width: 2,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: widget.activeColor.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            widget.items[index].icon,
                            size: 48,
                            color: widget.activeColor,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          widget.items[index].label,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: widget.activeColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Seçmek için dokun',
                          style: TextStyle(
                            fontSize: 14,
                            color: widget.activeColor.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Sayfa göstergesi
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.items.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentIndex == index ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentIndex == index
                        ? widget.activeColor
                        : widget.activeColor.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
