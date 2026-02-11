import 'package:flutter/material.dart';

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

class _HomePageState extends State<HomePage> {
  int? _lastNumber; // null means show nothing (required)

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
                onPressed: () {},
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

