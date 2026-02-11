import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';

const Color kAppBarColor = Color.fromARGB(255, 11, 95, 164);
const Color kBodyColor = Color.fromARGB(255, 11, 95, 164);
const Color kButtonColor = Color.fromARGB(255, 11, 95, 164);
const Color kTextColor = Colors.white;

// constants for TextStyle
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

void main() {
  runApp(const MyApp());
}

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

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final Random _rng = Random();

  int? _lastNumber;
  bool _isGenerating = false;

  late final Map<int, int> _counts;

  late final AnimationController _controller;
  Timer? _timer;

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
    });

    _controller.reset();
    _controller.forward();

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 60), (_) {
      setState(() {
        _random1to9();
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

  
Widget _centerContent() {
  if (_isGenerating) {
    return Text('$_lastNumber', style: kBigNumberStyle);
  }
  if (_lastNumber == null) {
    return const SizedBox.shrink();
  }
  return Text('$_lastNumber', style: kBigNumberStyle);
}

@override
Widget build(BuildContext context) {
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
                child: Center(
                  child: _lastNumber == null
                      ? const SizedBox.shrink()
                      : Text('$_lastNumber', style: kBigNumberStyle),
                ),
              ),
              ElevatedButton(
                style: kElevatedButtonStyle,
                onPressed: _startGeneration,
                child: const Text('Generate'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                style: kElevatedButtonStyle,
                onPressed: () {},
                child: const Text('View Statistics'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}