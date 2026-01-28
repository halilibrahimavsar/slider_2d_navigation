import 'package:flutter/material.dart';
import 'lib/dynamic_slider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Submenu Test',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const TestPage(),
    );
  }
}

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Submenu Ontap Test')),
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DynamicSliderButton(
              controller: _controller,
              onValueChanged: (value) {
                print('Slider value changed: $value');
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
                ],
              },
              subMenuItems: {
                SliderState.savedMoney: [
                  SubMenuItem(
                    icon: Icons.account_balance,
                    label: 'Banka',
                    onTap: () => print('Banka seçildi - SUBMENU'),
                  ),
                  SubMenuItem(
                    icon: Icons.home,
                    label: 'Ev',
                    onTap: () => print('Ev seçildi - SUBMENU'),
                  ),
                ],
                SliderState.transactions: [
                  SubMenuItem(
                    icon: Icons.history,
                    label: 'Geçmiş',
                    onTap: () => print('Geçmiş seçildi - SUBMENU'),
                  ),
                  SubMenuItem(
                    icon: Icons.pending,
                    label: 'Bekleyen',
                    onTap: () => print('Bekleyen seçildi - SUBMENU'),
                  ),
                ],
              },
            ),
            const SizedBox(height: 50),
            const Text(
              'Test Instructions:\n'
              '1. Drag slider to "Birikim" or "İşlemler"\n'
              '2. Vertically drag in the knob to select submenu items\n'
              '3. Release to select - ontap should trigger\n'
              '4. Check console for "SUBMENU" messages',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
