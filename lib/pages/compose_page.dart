import 'package:flutter/material.dart';
import 'dart:math';
import '../widgets/background_container.dart';

class ComposePage extends StatefulWidget {
  const ComposePage({super.key});

  @override
  State<ComposePage> createState() => _ComposePageState();
}

class _ComposePageState extends State<ComposePage> {
  List<int> options = [];
  List<int> selected = [];
  int target = 0;

  @override
  void initState() {
    super.initState();
    generateQuestion();
  }

  void generateQuestion() {
    Random random = Random();

    int a = random.nextInt(90) + 10;
    int b = random.nextInt(90) + 10;

    // Ensure target does not exceed 99
    while (a + b > 99) {
      a = random.nextInt(90) + 10;
      b = random.nextInt(90) + 10;
    }

    target = a + b;

    selected = [];
    options = [a, b];
    while (options.length < 4) {
      int num = random.nextInt(90) + 10;
      if (!options.contains(num)) {
        options.add(num);
      }
    }
    options.shuffle();
    setState(() {});
  }

  void toggleSelection(int number) {
    setState(() {
      if (selected.contains(number)) {
        selected.remove(number);
      } else {
        if (selected.length < 2) {
          selected.add(number);
        }
      }
    });
  }

  void checkAnswer() {
    if (selected.length != 2) return;
    int sum = selected[0] + selected[1];
    bool correct = sum == target;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(correct ? 'Correct!' : 'Wrong'),
        content: Text('Answer: $sum\nTarget: $target'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              generateQuestion();
            },
            child: const Text('Next'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundContainer(
        child: Column(
          children: [
            // Top app bar style
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
                      'Compose Number',
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

            // Main content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Column(
                  children: [
                    Text(
                      'Which two numbers make $target?',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                    ),
                    const SizedBox(height: 30),
                    Wrap(
                      spacing: 20,
                      runSpacing: 20,
                      alignment: WrapAlignment.center,
                      children: options.map((num) {
                        final isSelected = selected.contains(num);
                        return ElevatedButton(
                          onPressed: () => toggleSelection(num),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                isSelected ? Colors.deepPurple : Colors.deepPurple[100],
                            foregroundColor: isSelected ? Colors.white : Colors.black,
                            elevation: 6,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                          ),
                          child: Text(
                            '$num',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(2, (index) {
                        return Container(
                          width: 60,
                          height: 60,
                          margin: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.amber[100],
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              selected.length > index ? '${selected[index]}' : '?',
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: checkAnswer,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8D75F5),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                      ),
                      child: const Text(
                        'Check Answer',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
