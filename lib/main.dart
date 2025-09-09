import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const StepCounterApp());

class StepCounterApp extends StatelessWidget {
  const StepCounterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Step Counter',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.teal,
      ),
      home: const StepCounterPage(),
    );
  }
}

class StepCounterPage extends StatefulWidget {
  const StepCounterPage({super.key});

  @override
  State<StepCounterPage> createState() => _StepCounterPageState();
}

class _StepCounterPageState extends State<StepCounterPage> {
  static const _prefsKey = 'step_counter_value';
  int _count = 0;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadSaved();
  }

  Future<void> _loadSaved() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _count = prefs.getInt(_prefsKey) ?? 0;
      _loading = false;
    });
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_prefsKey, _count);
  }

  void _inc(int step) {
    setState(() => _count += step);
    _save();
  }

  void _reset() {
    setState(() => _count = 0);
    _save();
  }

  Color _backgroundFor(int value) {
    if (value < 10) return Colors.green.shade100;
    if (value <= 20) return Colors.orange.shade100;
    return Colors.red.shade100;
  }

  Color _textFor(int value) {
    if (value < 10) return Colors.green.shade800;
    if (value <= 20) return Colors.orange.shade800;
    return Colors.red.shade800;
  }

  @override
  Widget build(BuildContext context) {
    final bg = _backgroundFor(_count);
    final fg = _textFor(_count);

    return Scaffold(
      appBar: AppBar(title: const Text('Step Counter')),
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        color: bg,
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('จำนวนก้าว (จำลอง)',
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Text('$_count',
                        style: Theme.of(context)
                            .textTheme
                            .displayLarge
                            ?.copyWith(color: fg, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 24),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      alignment: WrapAlignment.center,
                      children: [
                        FilledButton.icon(
                          onPressed: () => _inc(1),
                          icon: const Icon(Icons.exposure_plus_1),
                          label: const Text('+1'),
                        ),
                        FilledButton.icon(
                          onPressed: () => _inc(5),
                          icon: const Icon(Icons.filter_5),
                          label: const Text('+5'),
                        ),
                        OutlinedButton.icon(
                          onPressed: _reset,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Reset'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _count < 10
                          ? 'โซนสีเขียว: ปลอดโปร่ง'
                          : (_count <= 20
                              ? 'โซนสีส้ม: เริ่มร้อนแรง'
                              : 'โซนสีแดง: ฮอตมาก!'),
                      style: TextStyle(color: fg),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
