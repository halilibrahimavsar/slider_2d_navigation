# Slider 2D Navigation

A Flutter package for 2D slider navigation with horizontal and vertical cube animations. Features dynamic mini buttons, sub-menus, and smooth transitions.

## Features

- 🎯 **Horizontal Navigation**: Smooth sliding between different states
- 📱 **Vertical Navigation**: Sub-menu carousel for each state
- 🎨 **Dynamic Mini Buttons**: Context-sensitive action buttons
- ✨ **Smooth Animations**: Cube-like transitions and haptic feedback
- 🎭 **Customizable**: Colors, labels, and actions fully configurable

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  slider_2d_navigation: ^1.0.0
```

Then import:

```dart
import 'package:slider_2d_navigation/slider_2d_navigation.dart';
```

## Usage

### Basic Usage

```dart
class MySliderPage extends StatefulWidget {
  @override
  _MySliderPageState createState() => _MySliderPageState();
}

class _MySliderPageState extends State<MySliderPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DynamicSlider(
        controller: _controller,
        onValueChanged: (value) => print('Value: $value'),
        onStateTap: (state) => print('Tapped: $state'),
        miniButtons: _getMiniButtons(),
        subMenuItems: _getSubMenuItems(),
      ),
    );
  }
}
```

### Defining Mini Buttons

```dart
Map<SliderState, List<MiniButtonData>> _getMiniButtons() {
  return {
    SliderState.savedMoney: [
      MiniButtonData(
        icon: Icons.add,
        label: 'Ekle',
        color: Colors.green,
        onTap: () => print('Birikim eklendi'),
      ),
      MiniButtonData(
        icon: Icons.remove,
        label: 'Çıkar',
        color: Colors.red,
        onTap: () => print('Birikim çıkarıldı'),
      ),
    ],
    SliderState.transactions: [
      MiniButtonData(
        icon: Icons.send,
        label: 'Gönder',
        color: Colors.blue,
        onTap: () => print('İşlem gönderildi'),
      ),
    ],
  };
}
```

### Defining Sub-Menu Items

```dart
Map<SliderState, List<SubMenuItem>> _getSubMenuItems() {
  return {
    SliderState.savedMoney: [
      SubMenuItem(
        icon: Icons.account_balance,
        label: 'Banka',
        onTap: () => print('Banka seçildi'),
      ),
      SubMenuItem(
        icon: Icons.home,
        label: 'Ev',
        onTap: () => print('Ev seçildi'),
      ),
    ],
    SliderState.transactions: [
      SubMenuItem(
        icon: Icons.history,
        label: 'Geçmiş',
        onTap: () => print('Geçmiş seçildi'),
      ),
    ],
  };
}
```

### Programmatic Navigation

```dart
// Navigate to specific state
_controller.animateTo(0.0); // savedMoney
_controller.animateTo(0.5); // transactions  
_controller.animateTo(1.0); // debt

// Or use the helper
final target = SliderStateHelper.getTargetValue(SliderState.transactions, 3);
_controller.animateTo(target);
```

## Customization

### Slider States

The package comes with three predefined states:

- `SliderState.savedMoney` - For savings/money-related actions
- `SliderState.transactions` - For transaction-related actions  
- `SliderState.debt` - For debt-related actions

Each state has associated colors, icons, and labels that you can customize through the `SliderStateHelper`.

### Animations

Control the animation behavior through your `AnimationController`:

```dart
_controller = AnimationController(
  vsync: this,
  duration: const Duration(milliseconds: 500), // Adjust duration
);
```

### Styling

The slider uses the `SliderConfig` class for styling constants:

- `SliderConfig.knobWidth/Height` - Size of the main knob
- `SliderConfig.trackPadding` - Padding around the track
- `SliderConfig.animationDuration` - Default animation duration
- `SliderConfig.animationCurve` - Default animation curve

## Example

For a complete example, see the `example.dart` file in the package.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
