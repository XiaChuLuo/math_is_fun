import 'package:flutter/material.dart';
import 'dart:math';
import '../widgets/background_container.dart'; // import background container

class ComparePage extends StatefulWidget {
  const ComparePage({super.key});

  @override
  State<ComparePage> createState() => _ComparePageState();
}

class _ComparePageState extends State<ComparePage> {
  int left = 0;
  int right = 0;
  String? selected;
  bool? isCorrect;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      generateNumbers();
    });
  }

  void generateNumbers() {
    final rand = Random();
    do {
      left = rand.nextInt(90) + 10;
      right = rand.nextInt(90) + 10;
    } while (left == right);
    setState(() {
      selected = null;
      isCorrect = null;
    });
  }

  void checkAnswer() {
    if (selected == null) return;

    setState(() {
      if ((left > right && selected == 'Greater') ||
          (left < right && selected == 'Lesser')) {
        isCorrect = true;
      } else {
        isCorrect = false;
      }
    });
  }

  void goNext() {
    generateNumbers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundContainer(
        child: Column(
          children: [
            // 🧭 Custom App Bar
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, size: 28),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Spacer(),
                    Text(
                      'Compare Numbers',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.deepPurple.shade700,
                        shadows: [
                          Shadow(
                            offset: const Offset(1, 1),
                            blurRadius: 2,
                            color: Colors.purple.withOpacity(0.3),
                          )
                        ],
                      ),
                    ),
                    const Spacer(flex: 2),
                  ],
                ),
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(height: 40),
                      Text(
                        '$left is ? than $right',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: ['Greater', 'Lesser'].map((option) {
                          final isSelected = selected == option;
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  selected = option;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isSelected
                                    ? Colors.deepPurple
                                    : Colors.grey[300],
                                foregroundColor: Colors.black,
                              ),
                              child: Text(
                                option,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: checkAnswer,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF8D75F5),
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Check Answer'),
                      ),
                      const SizedBox(height: 10),
                      if (isCorrect != null)
                        Column(
                          children: [
                            Text(
                              isCorrect! ? 'Correct! 🎉' : 'Wrong! Try Again.',
                              style: TextStyle(
                                fontSize: 18,
                                color: isCorrect! ? Colors.green : Colors.red,
                              ),
                            ),
                            const SizedBox(height: 10),
                            if (isCorrect!)
                              ElevatedButton(
                                onPressed: goNext,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green[600],
                                  foregroundColor: Colors.white,
                                ),
                                child: const Text('Next'),
                              )
                          ],
                        )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
