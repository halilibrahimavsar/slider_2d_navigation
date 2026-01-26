import 'package:flutter/material.dart';
import 'sub_page_model.dart';

/// Mini buton verisi (overlay'de görünecek hızlı aksiyonlar)
class MiniButtonData {
  /// Buton ikonu
  final IconData icon;

  /// Buton etiketi
  final String label;

  /// Buton rengi
  final Color color;

  /// Butona tıklandığında çağrılacak callback
  final VoidCallback onTap;

  const MiniButtonData({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });
}

/// Ana sayfa modeli
/// Yatay navigasyonda kullanılan ana sayfalar
class MainPage {
  /// Ana sayfa kimliği
  final String id;

  /// Ana sayfa etiketi (gösterilecek isim)
  final String label;

  /// Ana sayfa ikonu
  final IconData icon;

  /// Ana sayfa ana rengi
  final Color color;

  /// Ana sayfa ana widget'ı (varsayılan görünüm)
  final Widget mainWidget;

  /// Ana sayfanın alt sayfaları (dikey navigasyon için)
  final List<SubPage> subPages;

  /// Mini butonlar (overlay'de görünecek)
  final List<MiniButtonData> miniButtons;

  /// Ana sayfa seçildiğinde çağrılacak callback
  final VoidCallback? onTap;

  const MainPage({
    required this.id,
    required this.label,
    required this.icon,
    required this.color,
    required this.mainWidget,
    this.subPages = const [],
    this.miniButtons = const [],
    this.onTap,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MainPage && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
