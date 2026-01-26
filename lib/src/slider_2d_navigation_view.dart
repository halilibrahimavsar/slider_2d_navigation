import 'package:flutter/material.dart';
import 'package:slider_2d_navigation/slider_2d_navigation.dart';

import 'animations/horizontal_cube_animation.dart';
import 'animations/vertical_cube_animation.dart';
import 'widgets/slider_button_2d.dart';

/// Ana 2D Navigasyon Widget'ı
/// Hem yatay (ana sayfalar) hem dikey (alt sayfalar) navigasyonu sağlar
class Slider2DNavigationView extends StatefulWidget {
  /// Ana sayfalar
  final List<MainPage> mainPages;

  /// Slider button padding'i
  final EdgeInsets sliderPadding;

  /// Başlangıç ana sayfa indeksi
  final int initialMainPageIndex;

  const Slider2DNavigationView({
    super.key,
    required this.mainPages,
    this.sliderPadding = const EdgeInsets.all(20.0),
    this.initialMainPageIndex = 1, // Ortadan başla
  });

  @override
  State<Slider2DNavigationView> createState() => _Slider2DNavigationViewState();
}

class _Slider2DNavigationViewState extends State<Slider2DNavigationView>
    with TickerProviderStateMixin {
  late Slider2DController _controller;

  @override
  void initState() {
    super.initState();

    // Controller'ı oluştur
    _controller = Slider2DController(
      mainPages: widget.mainPages,
      vsync: this,
      initialState: Slider2DState(
        mainPageIndex: widget.initialMainPageIndex.clamp(
          0,
          widget.mainPages.length - 1,
        ),
        subPageIndex: -1,
      ),
    );

    // Başlangıç ana sayfasına git
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.goToMainPage(widget.initialMainPageIndex, animate: false);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final state = _controller.state;
        final mainPage = _controller.currentMainPage;
        final subPage = _controller.currentSubPage;

        return Column(
          children: [
            // Ana içerik alanı (animasyonlu)
            Expanded(child: _buildAnimatedContent(state, mainPage, subPage)),

            // Slider button
            Padding(
              padding: widget.sliderPadding,
              child: SliderButton2D(controller: _controller),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAnimatedContent(
    Slider2DState state,
    MainPage mainPage,
    SubPage? subPage,
  ) {
    // Yatay animasyon (ana sayfalar arası)
    Widget horizontalContent = HorizontalCubeAnimation(
      controller: _controller.horizontalController,
      leftWidget: _buildVerticalContent(widget.mainPages[0]),
      centerWidget: _buildVerticalContent(widget.mainPages[1]),
      rightWidget: _buildVerticalContent(widget.mainPages[2]),
    );

    return horizontalContent;
  }

  /// Her ana sayfa için dikey içerik oluştur
  Widget _buildVerticalContent(MainPage mainPage) {
    return AnimatedBuilder(
      animation: _controller.verticalController,
      builder: (context, child) {
        final state = _controller.state;

        // Sadece aktif ana sayfada dikey animasyon göster
        if (mainPage != _controller.currentMainPage) {
          return mainPage.mainWidget;
        }

        // Alt sayfalar varsa ve seçiliyse dikey animasyon göster
        if (mainPage.subPages.isNotEmpty && !state.isOnMainPage) {
          final subPage = _controller.currentSubPage;
          if (subPage != null) {
            return VerticalCubeAnimation(
              controller: _controller.verticalController,
              topWidget: mainPage.mainWidget,
              bottomWidget: subPage.widget,
            );
          }
        }

        // Ana sayfa veya alt sayfa yoksa sadece ana widget'ı göster
        return mainPage.mainWidget;
      },
    );
  }
}
