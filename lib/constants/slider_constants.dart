import 'package:flutter/material.dart';

class SliderConstants {
  static const Duration animationDuration = Duration(milliseconds: 500);
  static const Curve animationCurve = Curves.easeOutBack;
  static const double sliderHeight = 80.0;
  static const double knobSize = 60.0;
  static const double knobPadding = 10.0;
  static const double knobWidth = 70.0;
  static const double trackPadding = 10.0;
  static const BorderRadius trackBorderRadius =
      BorderRadius.all(Radius.circular(35));

  static const Duration miniButtonAnimationDuration =
      Duration(milliseconds: 400);
  static const Curve miniButtonAnimationCurve = Curves.easeOutBack;
  static const double miniButtonSpread = 0.8;
  static const double miniButtonDistance = 90.0;
  static const double miniButtonSize = 50.0;
  static const double miniButtonContainerSize = 60.0;

  static const double subMenuSpacing = 12.0;
  static const double subMenuRunSpacing = 8.0;
  static const BorderRadius subMenuBorderRadius =
      BorderRadius.all(Radius.circular(20));

  static const EdgeInsets subMenuPadding =
      EdgeInsets.symmetric(horizontal: 16, vertical: 8);
  static const TextStyle subMenuTextStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );

  static const double overlayBlur = 5.0;
  static const double overlayOpacity = 0.2;

  static const TextStyle stateLabelStyle = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
  );

  static const TextStyle activeStateLabelStyle = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.bold,
    letterSpacing: 0.5,
  );

  static const TextStyle knobLabelStyle = TextStyle(
    color: Colors.white,
    fontSize: 10,
    fontWeight: FontWeight.bold,
  );
}
