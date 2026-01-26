import 'package:flutter/material.dart';
import '../slider_2d_navigation.dart';

/// Slider 2D Navigation modülünün kullanım örneği
void main() {
  runApp(const ExampleUsageOfSliderTabView());
}

class ExampleUsageOfSliderTabView extends StatelessWidget {
  const ExampleUsageOfSliderTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Slider 2D Navigation Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const ExampleHomePage(),
    );
  }
}

class ExampleHomePage extends StatelessWidget {
  const ExampleHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Ana sayfaları tanımla
    final List<MainPage> mainPages = [
      // SOL SAYFA - BİRİKİM
      MainPage(
        id: 'savings',
        label: 'BİRİKİM',
        icon: Icons.savings_outlined,
        color: const Color(0xFF43A047),
        mainWidget: const _MainPageContent(
          title: 'Birikim Sayfası',
          color: Color(0xFF43A047),
          icon: Icons.savings_outlined,
        ),
        subPages: [
          SubPage(
            id: 'savings_1',
            label: 'Altın',
            icon: Icons.account_balance,
            widget: const _SubPageContent(
              title: 'Altın Yatırımları',
              color: Color(0xFFFFD700),
              icon: Icons.account_balance,
            ),
            onTap: () => debugPrint('Altın seçildi'),
          ),
          SubPage(
            id: 'savings_2',
            label: 'Döviz',
            icon: Icons.currency_exchange,
            widget: const _SubPageContent(
              title: 'Döviz Hesapları',
              color: Color(0xFF4CAF50),
              icon: Icons.currency_exchange,
            ),
            onTap: () => debugPrint('Döviz seçildi'),
          ),
          SubPage(
            id: 'savings_3',
            label: 'Hisse',
            icon: Icons.trending_up,
            widget: const _SubPageContent(
              title: 'Hisse Senetleri',
              color: Color(0xFF2196F3),
              icon: Icons.trending_up,
            ),
            onTap: () => debugPrint('Hisse seçildi'),
          ),
        ],
        miniButtons: [
          MiniButtonData(
            icon: Icons.add,
            label: 'Birikim Ekle',
            color: const Color(0xFF43A047),
            onTap: () => debugPrint('Birikim eklendi'),
          ),
          MiniButtonData(
            icon: Icons.analytics,
            label: 'Rapor',
            color: const Color(0xFF1976D2),
            onTap: () => debugPrint('Rapor gösterildi'),
          ),
        ],
        onTap: () => debugPrint('Birikim ana sayfası seçildi'),
      ),

      // ORTA SAYFA - İŞLEMLER
      MainPage(
        id: 'transactions',
        label: 'İŞLEMLER',
        icon: Icons.swap_horiz_rounded,
        color: const Color(0xFF1E88E5),
        mainWidget: const _MainPageContent(
          title: 'İşlemler Sayfası',
          color: Color(0xFF1E88E5),
          icon: Icons.swap_horiz_rounded,
        ),
        subPages: [
          SubPage(
            id: 'transactions_1',
            label: 'Geçmiş',
            icon: Icons.history,
            widget: const _SubPageContent(
              title: 'İşlem Geçmişi',
              color: Color(0xFF1976D2),
              icon: Icons.history,
            ),
            onTap: () => debugPrint('Geçmiş seçildi'),
          ),
          SubPage(
            id: 'transactions_2',
            label: 'Bekleyen',
            icon: Icons.pending_actions,
            widget: const _SubPageContent(
              title: 'Bekleyen İşlemler',
              color: Color(0xFFFFA726),
              icon: Icons.pending_actions,
            ),
            onTap: () => debugPrint('Bekleyen seçildi'),
          ),
        ],
        miniButtons: [
          MiniButtonData(
            icon: Icons.remove,
            label: 'Gider',
            color: const Color(0xFFE53935),
            onTap: () => debugPrint('Gider eklendi'),
          ),
          MiniButtonData(
            icon: Icons.add,
            label: 'Gelir',
            color: const Color(0xFF43A047),
            onTap: () => debugPrint('Gelir eklendi'),
          ),
        ],
        onTap: () => debugPrint('İşlemler ana sayfası seçildi'),
      ),

      // SAĞ SAYFA - BORÇ
      MainPage(
        id: 'debt',
        label: 'BORÇ',
        icon: Icons.account_balance_wallet_outlined,
        color: const Color(0xFFE53935),
        mainWidget: const _MainPageContent(
          title: 'Borç Sayfası',
          color: Color(0xFFE53935),
          icon: Icons.account_balance_wallet_outlined,
        ),
        subPages: [
          SubPage(
            id: 'debt_1',
            label: 'Alacaklar',
            icon: Icons.trending_up,
            widget: const _SubPageContent(
              title: 'Alacaklarım',
              color: Color(0xFF4CAF50),
              icon: Icons.trending_up,
            ),
            onTap: () => debugPrint('Alacaklar seçildi'),
          ),
          SubPage(
            id: 'debt_2',
            label: 'Borçlar',
            icon: Icons.trending_down,
            widget: const _SubPageContent(
              title: 'Borçlarım',
              color: Color(0xFFF44336),
              icon: Icons.trending_down,
            ),
            onTap: () => debugPrint('Borçlar seçildi'),
          ),
          SubPage(
            id: 'debt_3',
            label: 'Krediler',
            icon: Icons.credit_card,
            widget: const _SubPageContent(
              title: 'Kredi Kartları',
              color: Color(0xFFFF9800),
              icon: Icons.credit_card,
            ),
            onTap: () => debugPrint('Krediler seçildi'),
          ),
        ],
        miniButtons: [
          MiniButtonData(
            icon: Icons.add,
            label: 'Alacak',
            color: const Color(0xFF43A047),
            onTap: () => debugPrint('Alacak eklendi'),
          ),
          MiniButtonData(
            icon: Icons.add,
            label: 'Borç',
            color: const Color(0xFFE53935),
            onTap: () => debugPrint('Borç eklendi'),
          ),
        ],
        onTap: () => debugPrint('Borç ana sayfası seçildi'),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Slider 2D Navigation'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Slider2DNavigationView(
          mainPages: mainPages,
          initialMainPageIndex: 1, // Ortadan başla
          sliderPadding: const EdgeInsets.all(20.0),
        ),
      ),
    );
  }
}

/// Ana sayfa içeriği örneği
class _MainPageContent extends StatelessWidget {
  final String title;
  final Color color;
  final IconData icon;

  const _MainPageContent({
    required this.title,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color.withValues(alpha: 0.1), color.withValues(alpha: 0.05)],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 100, color: color),
            const SizedBox(height: 20),
            Text(
              title,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Slider\'ı sola-sağa kaydırarak ana sayfalar arasında geçiş yapın\nAşağı kaydırarak alt sayfalara erişin',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}

/// Alt sayfa içeriği örneği
class _SubPageContent extends StatelessWidget {
  final String title;
  final Color color;
  final IconData icon;

  const _SubPageContent({
    required this.title,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [color.withValues(alpha: 0.2), color.withValues(alpha: 0.1)],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 80, color: color),
            const SizedBox(height: 20),
            Text(
              title,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 40),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                'Bu bir alt sayfa\nYukarı kaydırarak ana sayfaya dönebilirsiniz',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
