import 'package:flutter/material.dart';
import 'compare_page.dart';
import 'order_page.dart';
import 'compose_page.dart';
import 'challenge_page.dart';
import '../utils/music_controller.dart';
import '../widgets/background_container.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final musicController = MusicController();

  @override
  void initState() {
    super.initState();
    // Ensure initial state reflects actual music status
    musicController.init().then((_) {
      setState(() {}); // triggers rebuild with correct icon
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundContainer(
        child: SafeArea(
          child: Stack(
            children: [
              Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 40),
                      const Text(
                        '✨ Math is Fun ✨',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6C63FF),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Let's Play!",
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple,
                            ),
                      ),
                      const SizedBox(height: 30),
                      ...[
                        ['Compare Numbers', const ComparePage()],
                        ['Order Numbers', const OrderPage()],
                        ['Compose Numbers', const ComposePage()],
                        ['Challenge Mode', const ChallengePage()],
                      ].map((entry) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF8D75F5),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => entry[1] as Widget),
                              );
                            },
                            child: Text(
                              entry[0] as String,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),

              // Music toggle icon button
              // Music toggle icon button
              Positioned(
                top: 12,
                right: 12,
                child: IconButton(
                  icon: Icon(
                    musicController.isPlaying ? Icons.music_note : Icons.music_off,
                    color: Colors.deepPurple,
                    size: 28,
                  ),
                  onPressed: () async {
                    await musicController.toggleMusic();
                    setState(() {}); // refresh icon state
                  },
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
