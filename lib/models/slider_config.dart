import 'package:flutter/material.dart';
import 'mini_button_data.dart';
import 'sub_menu_item.dart';

class SliderConfig {
  final String label;
  final IconData icon;
  final Color color;
  final List<MiniButtonData> miniButtons;
  final List<SubMenuItem> subMenuItems;

  const SliderConfig({
    required this.label,
    required this.icon,
    required this.color,
    this.miniButtons = const [],
    this.subMenuItems = const [],
  });
}
