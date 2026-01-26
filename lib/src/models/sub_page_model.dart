import 'package:flutter/material.dart';

/// Alt sayfa modeli
/// Her ana sayfanın birden fazla alt sayfası olabilir
class SubPage {
  /// Alt sayfa kimliği
  final String id;

  /// Alt sayfa etiketi (gösterilecek isim)
  final String label;

  /// Alt sayfa ikonu
  final IconData icon;

  /// Alt sayfa widget'ı
  final Widget widget;

  /// Alt sayfa seçildiğinde çağrılacak callback
  final VoidCallback? onTap;

  const SubPage({
    required this.id,
    required this.label,
    required this.icon,
    required this.widget,
    this.onTap,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubPage && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
