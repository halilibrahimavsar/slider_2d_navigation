# Slider 2D Navigation 🎯

Modern ve etkileyici bir Flutter navigasyon modülü. Hem yatay (ana sayfalar arası) hem dikey (alt sayfalar arası) 3D küp animasyonlu geçişler sağlar.

## ✨ Özellikler

- 🎨 **3D Küp Animasyonları**: Hem yatay hem dikey geçişlerde etkileyici 3D efektler
- 🔄 **2 Boyutlu Navigasyon**: Yatay ve dikey sürükleme desteği
- 🎯 **Mini Butonlar**: Hızlı aksiyonlar için overlay butonlar
- 🏷️ **Alt Sayfa Göstergeleri**: Tag tarzında kompakt alt sayfa seçiciler
- 📱 **Dokunmatik Optimize**: Haptic feedback ve smooth animasyonlar
- 🎭 **Özelleştirilebilir**: Her sayfa için renk, ikon ve içerik kontrolü
- 🚀 **Performanslı**: Optimize edilmiş animasyonlar ve state yönetimi

## 📦 Kurulum

```yaml
dependencies:
  slider_2d_navigation: ^1.0.0
```

## 🚀 Hızlı Başlangıç

### Basit Kullanım

```dart
import 'package:flutter/material.dart';
import 'package:slider_2d_navigation/slider_2d_navigation.dart';

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Slider2DNavigationView(
        mainPages: [
          MainPage(
            id: 'savings',
            label: 'BİRİKİM',
            icon: Icons.savings_outlined,
            color: Color(0xFF43A047),
            mainWidget: SavingsPage(),
            subPages: [
              SubPage(
                id: 'gold',
                label: 'Altın',
                icon: Icons.account_balance,
                widget: GoldPage(),
              ),
            ],
            miniButtons: [
              MiniButtonData(
                icon: Icons.add,
                label: 'Ekle',
                color: Color(0xFF43A047),
                onTap: () => print('Eklendi'),
              ),
            ],
          ),
          // Diğer sayfalar...
        ],
      ),
    );
  }
}
```

## 📖 Detaylı Kullanım

### Ana Sayfa Tanımlama

```dart
MainPage(
  id: 'unique_id',
  label: 'SAYFA ADI',
  icon: Icons.icon_name,
  color: Colors.blue,
  mainWidget: MyMainWidget(),
  
  // Alt sayfalar (opsiyonel)
  subPages: [
    SubPage(
      id: 'sub_1',
      label: 'Alt Sayfa 1',
      icon: Icons.subdirectory_arrow_right,
      widget: MySubWidget(),
      onTap: () => print('Seçildi'),
    ),
  ],
  
  // Mini butonlar (opsiyonel)
  miniButtons: [
    MiniButtonData(
      icon: Icons.add,
      label: 'Aksiyon',
      color: Colors.green,
      onTap: () => performAction(),
    ),
  ],
  
  // Ana sayfa callback'i (opsiyonel)
  onTap: () => print('Ana sayfa seçildi'),
)
```

### Controller Kullanımı (İleri Seviye)

```dart
class MyPage extends StatefulWidget {
  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> with TickerProviderStateMixin {
  late Slider2DController controller;

  @override
  void initState() {
    super.initState();
    controller = Slider2DController(
      mainPages: myPages,
      vsync: this,
      initialState: Slider2DState(
        mainPageIndex: 1,
        subPageIndex: -1,
      ),
    );
  }

  void navigateToPage() {
    // Programatik navigasyon
    controller.goToMainPage(2);
    controller.goToSubPage(0);
    controller.goToMainPageLevel(); // Ana sayfaya dön
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Column(
          children: [
            Text('Aktif Sayfa: ${controller.currentMainPage.label}'),
            Expanded(
              child: Slider2DNavigationView(
                mainPages: myPages,
              ),
            ),
          ],
        );
      },
    );
  }
}
```

## 🎮 Kullanıcı Etkileşimleri

### Yatay Navigasyon (Ana Sayfalar)
- **Sola/Sağa Sürükle**: Ana sayfalar arasında geçiş
- **Ana Sayfa İkonuna Tıkla**: Direkt o sayfaya git

### Dikey Navigasyon (Alt Sayfalar)
- **Aşağı Sürükle**: İlk alt sayfaya git veya sonraki alt sayfaya geç
- **Yukarı Sürükle**: Ana sayfaya dön veya önceki alt sayfaya geç
- **Alt Sayfa Tag'ine Tıkla**: Direkt o alt sayfaya git

### Mini Butonlar
- **Slider Button'a Tıkla**: Mini butonları göster/gizle
- **Mini Button'a Tıkla**: İlgili aksiyonu gerçekleştir

## 🎨 Özelleştirme

### Renkler ve Stil

```dart
MainPage(
  color: Color(0xFF1E88E5), // Ana renk
  // ...
)

Slider2DNavigationView(
  sliderPadding: EdgeInsets.all(20), // Slider padding'i
  initialMainPageIndex: 1, // Başlangıç sayfası (0, 1, 2)
)
```

### Animasyon Süreleri

Controller içindeki `Duration` değerlerini değiştirerek animasyon hızlarını ayarlayabilirsiniz.

## 📐 Yapı

```
slider_2d_navigation/
├── lib/
│   ├── slider_2d_navigation.dart          # Ana export dosyası
│   ├── src/
│   │   ├── models/
│   │   │   ├── main_page_model.dart       # Ana sayfa modeli
│   │   │   ├── sub_page_model.dart        # Alt sayfa modeli
│   │   │   └── slider_2d_state.dart       # Durum modeli
│   │   ├── controllers/
│   │   │   └── slider_2d_controller.dart  # Ana controller
│   │   ├── animations/
│   │   │   ├── horizontal_cube_animation.dart  # Yatay animasyon
│   │   │   └── vertical_cube_animation.dart    # Dikey animasyon
│   │   ├── widgets/
│   │   │   ├── slider_button_2d.dart      # Ana slider button
│   │   │   ├── mini_buttons_overlay.dart  # Overlay butonlar
│   │   │   └── sub_page_indicator.dart    # Alt sayfa göstergesi
│   │   └── slider_2d_navigation_view.dart # Ana widget
│   └── example/
│       └── example_usage.dart             # Kullanım örneği
```

## 🎯 Örnekler

Detaylı örnek için `lib/example/example_usage.dart` dosyasına bakın.

## 🐛 Bilinen Sorunlar

- Mini butonlar açıkken sürükleme yapmak overlay'i kapatır (tasarım gereği)
- 3'ten fazla ana sayfa şu anda desteklenmiyor

## 🤝 Katkıda Bulunma

Pull request'ler kabul edilir. Büyük değişiklikler için önce bir issue açın.

## 📄 Lisans

MIT License

## 👨‍💻 Geliştirici

Cunehat Finance App için geliştirildi.

## 📱 Ekran Görüntüleri

[Buraya ekran görüntüleri eklenebilir]

## 🔗 Bağlantılar

- [Dökümanlar](https://github.com/avsarhalilibrahim/slider_2d_navigation/wiki)
- [Örnek Projeler](https://github.com/avsarhalilibrahim/slider_2d_navigation/tree/main/examples)
- [Changelog](https://github.com/avsarhalilibrahim/slider_2d_navigation/blob/main/CHANGELOG.md)

---

⭐ Bu paketi beğendiyseniz yıldız vermeyi unutmayın!