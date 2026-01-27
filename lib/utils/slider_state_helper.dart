import 'package:flutter/material.dart';
import '../models/slider_state.dart';

class SliderStateHelper {
  static SliderState getStateFromValue(double value, int totalStates) {
    final segmentSize = 1.0 / (totalStates - 1);
    final index = (value / segmentSize).round();
    return SliderState.values[index.clamp(0, totalStates - 1)];
  }

  static Color getStateColor(SliderState state) {
    switch (state) {
      case SliderState.savedMoney:
        return const Color(0xFF43A047);
      case SliderState.transactions:
        return const Color(0xFF1E88E5);
      case SliderState.debt:
        return const Color(0xFFE53935);
    }
  }

  static String getStateLabel(SliderState state) {
    switch (state) {
      case SliderState.savedMoney:
        return 'BİRİKİM';
      case SliderState.transactions:
        return 'İŞLEMLER';
      case SliderState.debt:
        return 'BORÇ';
    }
  }

  static IconData getStateIcon(SliderState state) {
    switch (state) {
      case SliderState.savedMoney:
        return Icons.savings_outlined;
      case SliderState.transactions:
        return Icons.swap_horiz_rounded;
      case SliderState.debt:
        return Icons.account_balance_wallet_outlined;
    }
  }

  static double getTargetValueForState(SliderState state, int totalStates) {
    final index = SliderState.values.indexOf(state);
    return index / (totalStates - 1);
  }
}
