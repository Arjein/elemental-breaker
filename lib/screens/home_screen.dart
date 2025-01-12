import 'package:elemental_breaker/widgets/score_display.dart';
import 'package:flutter/material.dart';
import 'package:elemental_breaker/screens/in_game_screen.dart';
import 'package:elemental_breaker/elemental_breaker.dart';
import 'package:get_it/get_it.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ElementalBreaker game = GetIt.I<ElementalBreaker>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Elemental Breaker'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 50),
            HighScoreDisplay(game: game),
            SizedBox(height: 50),
            ElevatedButton(
              onPressed: () => _resumeGame(context, game),
              child: Text('Resume Game'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _startNewGame(context, game),
              child: Text('Start New Game'),
            ),
          ],
        ),
      ),
    );
  }

  void _resumeGame(BuildContext context, ElementalBreaker game) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => InGameScreen(),
      ),
    );
  }

  void _startNewGame(BuildContext context, ElementalBreaker game) {
    if (game.levelManager.isLoaded) {
      game.restartGame(); // Assuming you have a reset method to start a new game
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => InGameScreen(),
      ),
    );
  }
}
