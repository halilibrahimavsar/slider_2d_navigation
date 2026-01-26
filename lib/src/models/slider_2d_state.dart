import 'package:flutter/foundation.dart';

/// Slider 2D navigasyon durumu
/// Hem yatay (ana sayfa) hem dikey (alt sayfa) pozisyonu tutar
@immutable
class Slider2DState {
  /// Ana sayfa indeksi (yatay pozisyon)
  /// 0, 1, 2... (soldan sağa)
  final int mainPageIndex;

  /// Alt sayfa indeksi (dikey pozisyon)
  /// -1: Ana sayfada
  /// 0, 1, 2...: Alt sayfa indeksi
  final int subPageIndex;

  /// Mini butonlar görünür mü?
  final bool showMiniButtons;

  const Slider2DState({
    this.mainPageIndex = 0,
    this.subPageIndex = -1,
    this.showMiniButtons = false,
  });

  /// Ana sayfada mı? (Alt sayfa seçili değil mi?)
  bool get isOnMainPage => subPageIndex == -1;

  /// Slider button için yatay pozisyon değeri (0.0 - 1.0)
  /// 3 sayfa için: 0.0, 0.5, 1.0
  double get horizontalValue {
    if (mainPageIndex == 0) return 0.0;
    if (mainPageIndex == 1) return 0.5;
    return 1.0;
  }

  /// Kopya oluştur (immutable pattern)
  Slider2DState copyWith({
    int? mainPageIndex,
    int? subPageIndex,
    bool? showMiniButtons,
  }) {
    return Slider2DState(
      mainPageIndex: mainPageIndex ?? this.mainPageIndex,
      subPageIndex: subPageIndex ?? this.subPageIndex,
      showMiniButtons: showMiniButtons ?? this.showMiniButtons,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Slider2DState &&
          runtimeType == other.runtimeType &&
          mainPageIndex == other.mainPageIndex &&
          subPageIndex == other.subPageIndex &&
          showMiniButtons == other.showMiniButtons;

  @override
  int get hashCode =>
      mainPageIndex.hashCode ^ subPageIndex.hashCode ^ showMiniButtons.hashCode;

  @override
  String toString() =>
      'Slider2DState(main: $mainPageIndex, sub: $subPageIndex, miniButtons: $showMiniButtons)';
}
