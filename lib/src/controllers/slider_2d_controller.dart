import 'package:flutter/material.dart';
import 'package:slider_2d_navigation/slider_2d_navigation.dart';

/// Slider 2D navigasyon controller'ı
/// Hem yatay (ana sayfa) hem dikey (alt sayfa) navigasyonu yönetir
class Slider2DController extends ChangeNotifier {
  /// Ana sayfalar listesi
  final List<MainPage> mainPages;

  /// Mevcut durum
  Slider2DState _state;

  /// Yatay animasyon controller'ı (ana sayfalar arası)
  final AnimationController horizontalController;

  /// Dikey animasyon controller'ı (alt sayfalar arası)
  final AnimationController verticalController;

  Slider2DController({
    required this.mainPages,
    required TickerProvider vsync,
    Slider2DState? initialState,
  })  : _state = initialState ?? const Slider2DState(),
        horizontalController = AnimationController(
          vsync: vsync,
          duration: const Duration(milliseconds: 750),
          value: initialState?.horizontalValue ?? 0.0,
        ),
        verticalController = AnimationController(
          vsync: vsync,
          duration: const Duration(milliseconds: 600),
          value: 0.0,
        ) {
    // Yatay controller değişikliklerini dinle
    horizontalController.addListener(_onHorizontalChanged);
  }

  /// Mevcut durum
  Slider2DState get state => _state;

  /// Mevcut ana sayfa
  MainPage get currentMainPage => mainPages[_state.mainPageIndex];

  /// Mevcut alt sayfa (varsa)
  SubPage? get currentSubPage {
    if (_state.isOnMainPage) return null;
    final subPages = currentMainPage.subPages;
    if (_state.subPageIndex >= subPages.length) return null;
    return subPages[_state.subPageIndex];
  }

  /// Yatay controller değişikliklerini izle
  void _onHorizontalChanged() {
    final value = horizontalController.value;
    int newMainPageIndex;

    if (value < 0.33) {
      newMainPageIndex = 0;
    } else if (value > 0.66) {
      newMainPageIndex = 2;
    } else {
      newMainPageIndex = 1;
    }

    if (newMainPageIndex != _state.mainPageIndex) {
      _updateState(
        _state.copyWith(
          mainPageIndex: newMainPageIndex,
          subPageIndex: -1, // Ana sayfaya dön
        ),
      );
    }
  }

  /// Durumu güncelle
  void _updateState(Slider2DState newState) {
    if (_state != newState) {
      _state = newState;
      notifyListeners();
    }
  }

  /// Ana sayfaya git (yatay hareket)
  Future<void> goToMainPage(int index, {bool animate = true}) async {
    if (index < 0 || index >= mainPages.length) return;
    if (_state.mainPageIndex == index && _state.isOnMainPage) return;

    // Alt sayfadaysak önce ana sayfaya dön
    if (!_state.isOnMainPage) {
      await goToMainPageLevel();
    }

    _updateState(_state.copyWith(mainPageIndex: index, subPageIndex: -1));

    final targetValue = index == 0 ? 0.0 : (index == 1 ? 0.5 : 1.0);

    if (animate) {
      await horizontalController.animateTo(
        targetValue,
        duration: const Duration(milliseconds: 750),
        curve: Curves.easeOutCubic,
      );
    } else {
      horizontalController.value = targetValue;
    }

    // Callback'i çağır
    currentMainPage.onTap?.call();
  }

  /// Alt sayfaya git (dikey hareket)
  Future<void> goToSubPage(int index, {bool animate = true}) async {
    final subPages = currentMainPage.subPages;
    if (subPages.isEmpty || index < 0 || index >= subPages.length) return;

    final isComingFromMainPage = _state.isOnMainPage;
    final previousSubPageIndex = _state.subPageIndex;

    _updateState(_state.copyWith(subPageIndex: index));

    if (animate) {
      if (isComingFromMainPage) {
        // Ana sayfadan alt sayfaya: 0.0 -> 0.5
        await verticalController.animateTo(
          0.5,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOutCubic,
        );
      } else {
        // Alt sayfadan alt sayfaya
        final direction = index > previousSubPageIndex ? 1 : -1;

        // İlk önce 0.5'ten geçerli değere git (örn: 0.5 -> 1.0)
        await verticalController.animateTo(
          direction > 0 ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInCubic,
        );

        // Sonra sıfırla ve tekrar 0.5'e getir
        verticalController.value = direction > 0 ? 0.0 : 1.0;
        await verticalController.animateTo(
          0.5,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
        );
      }
    } else {
      verticalController.value = 0.5;
    }

    // Callback'i çağır
    subPages[index].onTap?.call();
  }

  /// Ana sayfa seviyesine dön (dikey hareket - yukarı)
  Future<void> goToMainPageLevel({bool animate = true}) async {
    if (_state.isOnMainPage) return;

    _updateState(_state.copyWith(subPageIndex: -1));

    if (animate) {
      // 0.5'ten 0.0'a (yukarı çık)
      await verticalController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOutCubic,
      );
    } else {
      verticalController.value = 0.0;
    }

    // Ana sayfa callback'i çağır
    currentMainPage.onTap?.call();
  }

  /// Mini butonları göster/gizle
  void toggleMiniButtons() {
    _updateState(_state.copyWith(showMiniButtons: !_state.showMiniButtons));
  }

  /// Mini butonları gizle
  void hideMiniButtons() {
    if (_state.showMiniButtons) {
      _updateState(_state.copyWith(showMiniButtons: false));
    }
  }

  /// Manuel yatay sürükleme için değer güncelle
  void updateHorizontalValue(double value) {
    horizontalController.value = value.clamp(0.0, 1.0);
  }

  @override
  void dispose() {
    horizontalController.removeListener(_onHorizontalChanged);
    horizontalController.dispose();
    verticalController.dispose();
    super.dispose();
  }
}
