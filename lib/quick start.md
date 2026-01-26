# 🚀 Slider 2D Navigation - Hızlı Başlangıç

Tebrikler! **slider_2d_navigation** paketi başarıyla oluşturuldu.

## 📦 Paketin İçeriği

```
slider_2d_navigation/
├── lib/
│   ├── slider_2d_navigation.dart          # Ana export dosyası
│   ├── src/
│   │   ├── models/                         # Veri modelleri
│   │   │   ├── main_page_model.dart
│   │   │   ├── sub_page_model.dart
│   │   │   └── slider_2d_state.dart
│   │   ├── controllers/                    # State management
│   │   │   └── slider_2d_controller.dart
│   │   ├── animations/                     # 3D animasyonlar
│   │   │   ├── horizontal_cube_animation.dart
│   │   │   └── vertical_cube_animation.dart
│   │   ├── widgets/                        # UI bileşenleri
│   │   │   ├── slider_button_2d.dart
│   │   │   ├── mini_buttons_overlay.dart
│   │   │   └── sub_page_indicator.dart
│   │   └── slider_2d_navigation_view.dart # Ana widget
│   └── example/
│       └── example_usage.dart             # Detaylı örnek
├── test/
│   └── slider_2d_navigation_test.dart     # Unit testler
├── README.md                              # Genel dokümantasyon
├── INTEGRATION_GUIDE.md                   # Entegrasyon kılavuzu
├── CHANGELOG.md                           # Sürüm geçmişi
├── LICENSE                                # MIT Lisansı
├── pubspec.yaml                           # Paket konfigürasyonu
└── analysis_options.yaml                  # Linter ayarları
```

## 🎯 Öne Çıkan Özellikler

### ✅ Tam Özellikli 2D Navigasyon
- **Yatay**: 3 ana sayfa arası küp animasyonlu geçiş
- **Dikey**: Her ana sayfanın sınırsız alt sayfası (küp animasyonlu)
- **Gesture Tabanlı**: Dokunmatik optimizasyonlu sürükle-bırak

### ✅ Mini Butonlar Sistemi
- Overlay ile açılan hızlı aksiyon butonları
- Animasyonlu fan-out efekti
- Kenarlara göre otomatik yerleşim

### ✅ Modüler ve Genişletilebilir
- Temiz mimari (Models, Controllers, Widgets, Animations)
- Type-safe API
- Kolay özelleştirme

### ✅ Prodüksiyon Hazır
- Kapsamlı unit testler
- Dökümanlar ve örnekler
- Flutter best practices

## 🏃 Hızlı Başlangıç

### 1. Projenize Ekleyin

**Yöntem A: Yerel Paket (Önerilen)**
```bash
# Flutter projenizin kök dizininde:
mkdir packages
cp -r slider_2d_navigation packages/

# pubspec.yaml'a ekleyin:
dependencies:
  slider_2d_navigation:
    path: ./packages/slider_2d_navigation
```

**Yöntem B: Direkt Kullanım**
```bash
# src dosyalarını projenize kopyalayın
cp -r slider_2d_navigation/lib/src your_project/lib/widgets/slider_2d/
```

### 2. Örnek Uygulamayı Çalıştırın

```bash
cd slider_2d_navigation
flutter pub get
flutter run lib/example/example_usage.dart
```

### 3. Basit Kullanım

```dart
import 'package:slider_2d_navigation/slider_2d_navigation.dart';

Slider2DNavigationView(
  mainPages: [
    MainPage(
      id: 'page1',
      label: 'SAYFA 1',
      icon: Icons.home,
      color: Colors.blue,
      mainWidget: MyWidget1(),
      subPages: [...], // Opsiyonel
      miniButtons: [...], // Opsiyonel
    ),
    // 3 ana sayfa tanımlayın
  ],
)
```

## 📚 Detaylı Dokümantasyon

1. **README.md**: Genel bakış ve API referansı
2. **INTEGRATION_GUIDE.md**: Mevcut projenize nasıl entegre edeceğiniz
3. **example/example_usage.dart**: Çalışan tam örnek
4. **test/**: Unit test örnekleri

## 🎨 Mevcut Projenize Entegrasyon

### Cunehat Finance Projesi İçin

Mevcut `HomePage` yapınızı şu şekilde güncelleyebilirsiniz:

```dart
// Eski yapınız:
Column(
  children: [
    Expanded(child: CubeAnimationView(...)),
    SliderButtonEnhanced(...),
  ],
)

// Yeni yapı:
Slider2DNavigationView(
  mainPages: [
    MainPage(
      id: 'savings',
      label: 'BİRİKİM',
      icon: Icons.savings_outlined,
      color: Color(0xFF43A047),
      mainWidget: InvestmentMoneyPage(...),
      subPages: [ /* Alt sayfalarınız */ ],
      miniButtons: [ /* Hızlı aksiyonlarınız */ ],
    ),
    // İşlemler ve Borç sayfaları...
  ],
)
```

Detaylı entegrasyon için `INTEGRATION_GUIDE.md` dosyasına bakın.

## 🧪 Testler

```bash
cd slider_2d_navigation
flutter test
```

## 📝 Lisans

MIT License - Özgürce kullanabilir, değiştirebilir ve dağıtabilirsiniz.

## 🎯 Sonraki Adımlar

1. ✅ Örnek uygulamayı çalıştırın ve test edin
2. ✅ INTEGRATION_GUIDE.md'yi okuyun
3. ✅ Kendi sayfalarınızı tanımlayın
4. ✅ Mevcut projenize entegre edin
5. ✅ Özelleştirin ve geliştirin!

## 💡 İpuçları

- Her ana sayfa için **benzersiz ID** kullanın
- Alt sayfa sayısını **makul tutun** (max 5-6)
- Mini buton sayısını **2-3 ile sınırlayın**
- Widget'ları **lazy load** edin
- **BLoC/Provider** ile state management yapın

## 🐛 Sorun mu var?

1. README.md'deki "Bilinen Sorunlar" bölümüne bakın
2. INTEGRATION_GUIDE.md'deki "Sık Karşılaşılan Sorunlar" bölümüne bakın
3. Test dosyalarına örnek kullanımlar için bakın

---

**Başarılar! 🚀**

Sorularınız için README.md ve INTEGRATION_GUIDE.md dosyalarına göz atın.