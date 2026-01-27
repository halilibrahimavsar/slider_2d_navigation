# Dynamic Slider Button

Modüler ve dinamik bir slider button bileşeni. Sayfa sayısı artırılabilir veya azaltılabilir şekilde tasarlanmıştır.

## Özellikler

- ✅ Modüler yapı
- ✅ Dinamik sayfa sayısı desteği
- ✅ Mini buton overlay sistemi
- ✅ Alt menü (tag) desteği
- ✅ Haptic feedback
- ✅ Smooth animasyonlar
- ✅ Responsive tasarım

## Proje Yapısı

```
lib/
├── models/
│   ├── slider_state.dart          # Slider durumları (enum)
│   ├── mini_button_data.dart      # Mini buton veri modeli
│   ├── sub_menu_item.dart        # Alt menü öğesi modeli
│   └── slider_config.dart        # Slider konfigürasyonu
├── constants/
│   └── slider_constants.dart      # Sabit değerler
├── utils/
│   └── slider_state_helper.dart  # Durum yardımcı fonksiyonları
├── widgets/
│   ├── dynamic_slider_button.dart    # Ana slider bileşeni
│   ├── mini_buttons_overlay.dart     # Mini buton overlay'i
│   ├── sub_menu_tags.dart            # Alt menü tag'leri
│   └── state_section.dart            # Durum bölümleri
├── dynamic_slider.dart           # Ana export dosyası
└── example.dart                   # Kullanım örneği
```

## Kullanım

```dart
import 'package:flutter/material.dart';
import 'package:your_package/dynamic_slider.dart';

class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> with TickerProviderStateMixin {
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
  Widget build(BuildContext context) {
    return DynamicSliderButton(
      controller: _controller,
      onValueChanged: (value) => print('Value: $value'),
      onTap: (state) => print('State: $state'),
      miniButtons: {
        SliderState.savedMoney: [
          MiniButtonData(
            icon: Icons.add,
            label: 'Ekle',
            color: Colors.green,
            onTap: () => print('Eklendi'),
          ),
        ],
      },
      subMenuItems: {
        SliderState.savedMoney: [
          SubMenuItem(
            icon: Icons.account_balance,
            label: 'Banka',
            onTap: () => print('Banka'),
          ),
        ],
      },
    );
  }
}
```

## Yeni Durum Ekleme

SliderState enum'ına yeni durumlar ekleyerek slider'ı genişletebilirsiniz:

```dart
enum SliderState {
  savedMoney,
  transactions,
  debt,
  investments,  // Yeni durum
  settings,     // Yeni durum
}
```

## Özelleştirme

- Renkler: `SliderStateHelper.getStateColor()` üzerinden
- İkonlar: `SliderStateHelper.getStateIcon()` üzerinden
- Label'lar: `SliderStateHelper.getStateLabel()` üzerinden
- Animasyonlar: `SliderConstants` üzerinden özelleştirilebilir
