import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/background_container.dart';

class ChallengePage extends StatefulWidget {
  const ChallengePage({super.key});

  @override
  State<ChallengePage> createState() => _ChallengePageState();
}

class _ChallengePageState extends State<ChallengePage> {
  int health = 3;
  int score = 0;
  int highScore = 0;
  String selectedAnswer = '';
  int timer = 5;
  Timer? countdown;
  double progress = 1.0;

  String questionType = '';
  List<String> options = [];

  int target = 0;
  List<int> compareNums = [];
  List<int> selectedCompare = [];

  List<int> orderOptions = [];
  List<int?> userOrder = [null, null, null];
  String orderMode = 'Ascending';

  List<int> composeOptions = [];
  List<int> selectedCompose = [];

  @override
  void initState() {
    super.initState();
    loadHighScore();
    generateNewQuestion();
  }

  Future<void> loadHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      highScore = prefs.getInt('highestScore') ?? 0;
    });
  }

  Future<void> updateHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    if (score > highScore) {
      await prefs.setInt('highestScore', score);
      setState(() {
        highScore = score;
      });
    }
  }

  void generateQuestion() {
    setState(() {
      selectedAnswer = '';
      selectedCompare = [0];
      selectedCompose = [];
      userOrder = [null, null, null];
    });

    final types = ['compare', 'order', 'compose'];
    questionType = types[Random().nextInt(types.length)];

    switch (questionType) {
      case 'compare':
        int a = Random().nextInt(90) + 10;
        int b;
        do {
          b = Random().nextInt(90) + 10;
        } while (b == a);
        compareNums = [a, b];
        selectedCompare = [0];
        break;
      case 'order':
        orderOptions = [];
        while (orderOptions.length < 3) {
          int num = Random().nextInt(90) + 10;
          if (!orderOptions.contains(num)) orderOptions.add(num);
        }
        orderMode = Random().nextBool() ? 'Ascending' : 'Descending';
        break;
      case 'compose':
        selectedCompose = [];
        int a = Random().nextInt(45) + 10;
        int b = Random().nextInt(45) + 10;
        target = a + b;
        if (target > 99) target = 99;
        composeOptions = [a, b];
        while (composeOptions.length < 4) {
          int num = Random().nextInt(90) + 10;
          if (!composeOptions.contains(num)) composeOptions.add(num);
        }
        composeOptions.shuffle();
        break;
    }
  }

  void startTimer() {
    countdown?.cancel();
    timer = 5;
    progress = 1.0;
    countdown = Timer.periodic(const Duration(seconds: 1), (timerTick) {
      if (timer > 0) {
        setState(() {
          timer--;
          progress = timer / 5;
        });
      } else {
        timerTick.cancel();
        wrongAnswer();
      }
    });
  }

  void wrongAnswer() {
    setState(() {
      health--;
    });
    if (health <= 0) {
      updateHighScore();
      showGameOverDialog();
    } else {
      generateNewQuestion();
    }
  }

  void generateNewQuestion() {
    generateQuestion();
    startTimer();
  }

  void showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('Game Over', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text('Your score: $score\nHighest Score: $highScore'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                score = 0;
                health = 3;
              });
              generateNewQuestion();
            },
            child: const Text('Try Again'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('Exit'),
          ),
        ],
      ),
    );
  }

  void submitAnswer() {
    countdown?.cancel();

    bool correct = false;
    if (questionType == 'compare') {
      if ((compareNums[0] > compareNums[1] && selectedCompare[0] == 1) ||
          (compareNums[0] < compareNums[1] && selectedCompare[0] == 2)) {
        correct = true;
      }
    } else if (questionType == 'order') {
      List<int> expected = List.from(orderOptions);
      expected.sort();
      if (orderMode == 'Descending') expected = expected.reversed.toList();
      correct = listEquals(expected, userOrder);
    } else if (questionType == 'compose') {
      if (selectedCompose.length == 2) {
        correct = selectedCompose[0] + selectedCompose[1] == target;
      }
    }

    if (correct) {
      setState(() {
        score++;
      });
      generateNewQuestion();
    } else {
      wrongAnswer();
    }
  }

  Widget buildQuestionUI() {
    if (questionType == 'compare') {
      return Column(
        children: [
          Text(
            '${compareNums[0]} is ? than ${compareNums[1]}',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              answerButton('Greater', 1),
              const SizedBox(width: 12),
              answerButton('Lesser', 2),
            ],
          ),
        ],
      );
    } else if (questionType == 'order') {
      return Column(
        children: [
          Text(
            'Arrange in $orderMode order:',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: userOrder.asMap().entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() => userOrder[entry.key] = null);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber.shade100,
                    minimumSize: const Size(60, 60),
                  ),
                  child: Text(entry.value?.toString() ?? '?', style: const TextStyle(fontSize: 20)),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: orderOptions.map((num) {
              bool selected = userOrder.contains(num);
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: ElevatedButton(
                  onPressed: selected
                      ? null
                      : () {
                          int index = userOrder.indexWhere((val) => val == null);
                          if (index != -1) {
                            setState(() => userOrder[index] = num);
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selected ? Colors.grey.shade300 : const Color(0xFF8D75F5),
                    minimumSize: const Size(60, 50),
                  ),
                  child: Text(num.toString(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              );
            }).toList(),
          ),
        ],
      );
    } else if (questionType == 'compose') {
      return Column(
        children: [
          Text(
            'Which two numbers make $target?',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 16,
            runSpacing: 12,
            children: composeOptions.map((num) {
              bool selected = selectedCompose.contains(num);
              return ElevatedButton(
                onPressed: () {
                  setState(() {
                    if (selected) {
                      selectedCompose.remove(num);
                    } else if (selectedCompose.length < 2) {
                      selectedCompose.add(num);
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: selected ? Colors.deepPurple : Colors.deepPurple[100],
                  foregroundColor: selected ? Colors.white : Colors.black,
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
          const SizedBox(height: 20),
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
                    selectedCompose.length > index ? '${selectedCompose[index]}' : '?',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              );
            }),
          ),
        ],
      );
    }

    return const SizedBox.shrink();
  }

  Widget answerButton(String label, int value) {
    bool selected = selectedCompare[0] == value;
    return ElevatedButton(
      onPressed: () {
        setState(() => selectedCompare[0] = value);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: selected ? const Color(0xFF8D75F5) : Colors.grey.shade300,
        foregroundColor: Colors.black,
        minimumSize: const Size(100, 45),
      ),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundContainer(
        child: Column(
          children: [
            AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Text(
                'Challenge Mode',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
              ),
              centerTitle: true,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                color: Colors.black,
                onPressed: () => Navigator.pop(context),
              ),
            ),
            LinearProgressIndicator(value: progress, minHeight: 6),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children: List.generate(health, (_) => const Icon(Icons.favorite, color: Colors.red))),
                  Text('Score: $score', style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: buildQuestionUI(),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: submitAnswer,
              child: const Text("Check Answer"),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
