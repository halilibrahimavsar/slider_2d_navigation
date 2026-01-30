import 'package:flutter/material.dart';

enum SliderState { savedMoney, transactions, debt }

class MiniButtonData {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const MiniButtonData({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });
}

class SubMenuItem {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const SubMenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });
}
