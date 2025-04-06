import 'dart:math';
import 'package:flutter/material.dart';

class BackgroundContainer extends StatefulWidget {
  final Widget child;

  const BackgroundContainer({super.key, required this.child});

  @override
  State<BackgroundContainer> createState() => _BackgroundContainerState();
}

class _BackgroundContainerState extends State<BackgroundContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  final List<_Bubble> _bubbles = List.generate(12, (index) => _Bubble());

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFEEE5FF), Color(0xFFD9D7F1)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            children: [
              ..._bubbles.map((b) => b.build(context, _controller.value)),
              widget.child,
            ],
          ),
        );
      },
    );
  }
}

class _Bubble {
  final double size = Random().nextDouble() * 30 + 20;
  final double startX = Random().nextDouble();
  final double delay = Random().nextDouble();
  final Color color = Colors.white.withOpacity(0.1 + Random().nextDouble() * 0.2);

  Widget build(BuildContext context, double animationValue) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final top = (height + size) * (1.0 - ((animationValue + delay) % 1.0));
    final left = width * startX;

    return Positioned(
      top: top,
      left: left,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
