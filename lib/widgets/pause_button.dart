// pause_button.dart

import 'package:elemental_breaker/Constants/overlay_identifiers.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';

class PauseButton extends StatelessWidget {
  final Game game;

  const PauseButton({Key? key, required this.game}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 10, // Adjust as needed
      left: 10, // Adjust as needed
      child: ElevatedButton(
        onPressed: () {
          game.overlays.add(OverlayIdentifiers.pausedMenu);
          game.pauseEngine(); // Pause the game
        },
        style: ElevatedButton.styleFrom(
          shape: CircleBorder(),
          backgroundColor: Colors.black54,
          padding: EdgeInsets.all(12), // Background color
        ),
        child: Icon(
          Icons.pause,
          color: Colors.white,
        ),
      ),
    );
  }
}
