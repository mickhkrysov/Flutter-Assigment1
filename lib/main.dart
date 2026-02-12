import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

/// Constants (Colors / Styles)

const Color kAppBarColor = Color(0xFF147CD3);
const Color kBodyColor = Color(0xFF2196F3);
const Color kButtonColor = Color(0xFF147CD3);
const Color kTextColor = Colors.white;

const TextStyle kBigNumberStyle = TextStyle(
  fontSize: 96,
  fontWeight: FontWeight.w600,
  color: kTextColor,
);

const TextStyle kRowTextStyle = TextStyle(
  fontSize: 18,
  color: kTextColor,
);

const TextStyle kButtonTextStyle = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.w600,
);

final ButtonStyle kElevatedButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: kButtonColor,
  foregroundColor: kTextColor,
  elevation: 2,
  minimumSize: const Size(double.infinity, 48),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10),
  ),
  textStyle: kButtonTextStyle,
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: kBodyColor,
        appBarTheme: const AppBarTheme(
          backgroundColor: kAppBarColor,
          foregroundColor: kTextColor,
          centerTitle: true,
        ),
      ),
      home: const HomePage(),
    );
  }
}

/// Home Page
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final Random _rng = Random();
  int? _lastNumber;
  int _rollingNumber = 1;
  late final Map<int, int> _counts;
  late final AnimationController _controller;
  Timer? _timer;
  bool _isGenerating = false;

  @override
  void initState() {
    super.initState();
    _counts = {for (int i = 1; i <= 9; i++) i: 0};
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _finishGeneration();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  int _random1to9() => _rng.nextInt(9) + 1;

  void _startGeneration() {
    if (_isGenerating) return;

    setState(() {
      _isGenerating = true;
      _rollingNumber = _random1to9();
    });

    _controller.reset();
    _controller.forward();
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 60), (_) {
      setState(() {
        _rollingNumber = _random1to9();
      });
    });
  }

  void _finishGeneration() {
    _timer?.cancel();
    _timer = null;
    final int finalNumber = _random1to9();

    setState(() {
      _lastNumber = finalNumber;
      _counts[finalNumber] = (_counts[finalNumber] ?? 0) + 1;
      _isGenerating = false;
    });

    _controller.reset();
  }

  void _resetAll() {
    setState(() {
      _lastNumber = null;
      for (int i = 1; i <= 9; i++) {
        _counts[i] = 0;
      }
    });
  }

  Future<void> _openStatistics() async {
    final bool? didReset = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => StatisticsPage(
          counts: _counts,
          onReset: _resetAll,
        ),
      ),
    );

    if (didReset == true) {
    }
  }

  @override
  Widget build(BuildContext context) {
    final Widget centerContent;
    if (_isGenerating) {
      centerContent = Text(
        '$_rollingNumber',
        style: kBigNumberStyle,
      );
    } else if (_lastNumber == null) {
      centerContent = const SizedBox.shrink();
    } else {
      centerContent = Text(
        '$_lastNumber',
        style: kBigNumberStyle,
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: null,
          icon: const Icon(Icons.home),
        ),
        title: const Text('Random Number Generator'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 16),
              Expanded(
                child: Center(child: centerContent),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                style: kElevatedButtonStyle,
                onPressed: _isGenerating ? null : _startGeneration,
                child: const Text('Generate'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                style: kElevatedButtonStyle,
                onPressed: _openStatistics,
                child: const Text('View Statistics'),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}


/// Statistics Page
class StatisticsPage extends StatefulWidget {
  const StatisticsPage({
    super.key,
    required this.counts,
    required this.onReset,
  });
  final Map<int, int> counts;
  final VoidCallback onReset;
  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  void _resetPressed() {
    widget.onReset();
    setState(() {});
  }

  void _backToHomePressed() {
    Navigator.pop(context, false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, false),
        ),
        title: const Text('Statistics'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Expanded(
                child: ListView.separated(
                  itemCount: 9,
                  separatorBuilder: (_, __) => const Divider(
                    color: Colors.white24,
                    height: 1,
                  ),
                  itemBuilder: (context, index) {
                    final int number = index + 1;
                    final int count = widget.counts[number] ?? 0;

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Number $number', style: kRowTextStyle),
                          Text('$count times', style: kRowTextStyle),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                style: kElevatedButtonStyle,
                onPressed: _resetPressed,
                child: const Text('Reset'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                style: kElevatedButtonStyle,
                onPressed: _backToHomePressed,
                child: const Text('Back to Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
