import 'package:flutter/material.dart';
import 'pages/home_page.dart'; // Correct relative import
import 'utils/music_controller.dart'; // Import MusicController

void main() async {
  WidgetsFlutterBinding.ensureInitialized();         // Ensure widgets are initialized
  await MusicController().init();                    // Start background music
  runApp(const MathGameApp());
}

class MathGameApp extends StatelessWidget {
  const MathGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Math is Fun',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        fontFamily: 'ComicNeue',
        scaffoldBackgroundColor: const Color(0xFFFDF7FF),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFDF7FF),
          foregroundColor: Colors.black,
          elevation: 0,
          centerTitle: true,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF6C63FF),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.deepPurple,
            textStyle: const TextStyle(fontSize: 16),
          ),
        ),
      ),
      home: const HomePage(),
    );
  }
}
