import 'package:elemental_breaker/elemental_breaker.dart';
import 'package:flutter/material.dart';

class ScoreDisplay extends StatefulWidget {
  final ElementalBreaker game;
  const ScoreDisplay({super.key, required this.game});

  @override
  State<ScoreDisplay> createState() => _ScoreDisplayState();
}

class _ScoreDisplayState extends State<ScoreDisplay> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: widget.game.currentLevelNotifier,
      builder: (context, level, child) {
        return Text(
          '$level',
          style: TextStyle(fontSize: 34, color: Colors.white),
        );
      },
    );
  }
}
