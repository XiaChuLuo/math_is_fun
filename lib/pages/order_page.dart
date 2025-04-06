import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter/foundation.dart';
import '../widgets/background_container.dart'; // ← for animated background

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  List<int> numbers = [];
  List<int?> userOrder = [null, null, null];
  String orderMode = 'Ascending';

  @override
  void initState() {
    super.initState();
    generateNumbers();
  }

  void generateNumbers() {
    numbers = [];
    Random random = Random();
    while (numbers.length < 3) {
      int num = random.nextInt(90) + 10;
      if (!numbers.contains(num)) numbers.add(num);
    }
    userOrder = [null, null, null];
    orderMode = random.nextBool() ? 'Ascending' : 'Descending';
    setState(() {});
  }

  void selectNumber(int index, int value) {
    setState(() {
      if (userOrder.contains(value)) return;
      userOrder[index] = value;
    });
  }

  void clearSlot(int index) {
    setState(() {
      userOrder[index] = null;
    });
  }

  void checkAnswer() {
    if (userOrder.contains(null)) return;
    List<int> expected = [...numbers];
    expected.sort();
    if (orderMode == 'Descending') expected = expected.reversed.toList();

    bool isCorrect = listEquals(expected, userOrder);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          isCorrect ? 'Correct!' : 'Wrong',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Expected: $expected\nYour answer: $userOrder',
          style: const TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              generateNumbers();
            },
            child: const Text(
              'Next',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
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
            // Top App Bar Style
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
                      'Order Numbers',
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

            // Main Content
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      const Text(
                        'Arrange the numbers:',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Select order: $orderMode',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Number Options
                      Wrap(
                        spacing: 16,
                        runSpacing: 12,
                        alignment: WrapAlignment.center,
                        children: numbers.map((num) {
                          return ElevatedButton(
                            onPressed: userOrder.contains(num)
                                ? null
                                : () {
                                    for (int i = 0; i < userOrder.length; i++) {
                                      if (userOrder[i] == null) {
                                        selectNumber(i, num);
                                        break;
                                      }
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: userOrder.contains(num)
                                  ? Colors.grey.shade300
                                  : const Color(0xFF8D75F5),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                            ),
                            child: Text(
                              '$num',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 30),

                      // Input Slots
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(3, (index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: GestureDetector(
                              onTap: () => clearSlot(index),
                              child: Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Colors.amber[100],
                                  border: Border.all(color: Colors.black),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: Text(
                                    userOrder[index]?.toString() ?? '?',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),

                      const SizedBox(height: 30),

                      // Check Answer Button
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
                      ),
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
