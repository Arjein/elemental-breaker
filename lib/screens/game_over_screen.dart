import 'package:elemental_breaker/Constants/user_device.dart';
import 'package:elemental_breaker/elemental_breaker.dart';
import 'package:flutter/material.dart';

class GameOverScreen extends StatelessWidget {
  final ElementalBreaker game;
  const GameOverScreen({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: UserDevice.width! * 0.5,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'GAME OVER',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // RESTART THE GAME
                game.restartGame();
              },
              child: Text('RESTART'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Implement quit functionality as needed
                game.hideGameOverScreen();
                Navigator.pop(context);
                game.restartGame();
              },
              child: Text('HOME'),
            ),
          ],
        ),
      ),
    );
  }
}
