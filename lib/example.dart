import 'package:flutter/material.dart';
import 'dynamic_slider.dart';

void main() {
  runApp(const ExampleOfSlideButton());
}

class ExampleOfSlideButton extends StatelessWidget {
  const ExampleOfSlideButton({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dynamic Slider Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const SliderDemo(),
    );
  }
}

class SliderDemo extends StatefulWidget {
  const SliderDemo({super.key});

  @override
  State<SliderDemo> createState() => _SliderDemoState();
}

class _SliderDemoState extends State<SliderDemo> with TickerProviderStateMixin {
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
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Dynamic Slider Demo'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 50),
            DynamicSliderButton(
              controller: _controller,
              onValueChanged: (value) {
                print('Slider value: $value');
              },
              onTap: (state) {
                print('Tapped state: $state');
              },
              miniButtons: {
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
                  MiniButtonData(
                    icon: Icons.download,
                    label: 'Al',
                    color: Colors.purple,
                    onTap: () => print('İşlem alındı'),
                  ),
                ],
                SliderState.debt: [
                  MiniButtonData(
                    icon: Icons.add,
                    label: 'Borç Ekle',
                    color: Colors.orange,
                    onTap: () => print('Borç eklendi'),
                  ),
                ],
              },
              subMenuItems: {
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
                  SubMenuItem(
                    icon: Icons.pending,
                    label: 'Bekleyen',
                    onTap: () => print('Bekleyen seçildi'),
                  ),
                ],
                SliderState.debt: [
                  SubMenuItem(
                    icon: Icons.person,
                    label: 'Kişisel',
                    onTap: () => print('Kişisel borç'),
                  ),
                  SubMenuItem(
                    icon: Icons.business,
                    label: 'Kurumsal',
                    onTap: () => print('Kurumsal borç'),
                  ),
                ],
              },
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => _controller.animateTo(0.0),
                  child: const Text('Birikim'),
                ),
                ElevatedButton(
                  onPressed: () => _controller.animateTo(0.5),
                  child: const Text('İşlemler'),
                ),
                ElevatedButton(
                  onPressed: () => _controller.animateTo(1.0),
                  child: const Text('Borç'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
