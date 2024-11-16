import 'package:elemental_breaker/Constants/user_device.dart';
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

class HighScoreDisplay extends StatefulWidget {
  final ElementalBreaker game;
  const HighScoreDisplay({super.key, required this.game});

  @override
  State<HighScoreDisplay> createState() => _HighScoreDisplayState();
}

class _HighScoreDisplayState extends State<HighScoreDisplay> {
  int highScore = 0;

  @override
  void initState() {
    super.initState();
    _loadHighScore();
  }

  Future<void> _loadHighScore() async {
    final hscore = await HighScoreManager.getHighScore();
    setState(() {
      highScore = hscore;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: widget.game.currentLevelNotifier,
      builder: (context, level, child) {
        if (level > highScore) {
          highScore = level;
        }
        return Text(
          '$highScore',
          style: TextStyle(
            fontSize: 34,
          ),
        );
      },
    );
  }
}
