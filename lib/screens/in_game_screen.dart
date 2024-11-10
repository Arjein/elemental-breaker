// main.dart

import 'package:elemental_breaker/Constants/overlay_identifiers.dart';
import 'package:elemental_breaker/Constants/user_device.dart';
import 'package:elemental_breaker/elemental_breaker.dart';
import 'package:elemental_breaker/screens/paused_menu.dart';
import 'package:elemental_breaker/widgets/pause_button.dart';
import 'package:elemental_breaker/widgets/score_display.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class InGameScreen extends StatelessWidget {
  late final ElementalBreaker elementalBreakerGame;
  InGameScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (UserDevice.width == null) {
      UserDevice.width = MediaQuery.of(context).size.width;
      UserDevice.height = MediaQuery.of(context).size.height;
      GameConstants.gameWidth = UserDevice.width;

      // Decide on blockOffset (e.g., 1% of gameWidth)
      GameConstants.blockOffset = GameConstants.gameWidth! * 0.015;

      // Number of columns and rows

      // Calculate blockEdgeLength based on blockOffset
      GameConstants.blockEdgeLength = (GameConstants.gameWidth! -
              (GameConstants.numberOfColumns + 1) *
                  GameConstants.blockOffset!) /
          GameConstants.numberOfColumns;

      // Calculate gameHeight based on blockEdgeLength and blockOffset
      GameConstants.gameHeight =
          GameConstants.numberOfRows * GameConstants.blockEdgeLength! +
              (GameConstants.numberOfRows + 1) * GameConstants.blockOffset!;

      debugPrint("Game Height: ${GameConstants.gameHeight}");
      debugPrint("Game Width: ${GameConstants.gameWidth}");
      debugPrint("Block Edge Length: ${GameConstants.blockEdgeLength}");
      debugPrint("Block Offset: ${GameConstants.blockOffset}");

      GameConstants.positionValsX[0] =
          -3 * GameConstants.blockEdgeLength! + -3 * GameConstants.blockOffset!;
      for (int i = 1; i < GameConstants.numberOfColumns; i++) {
        GameConstants.positionValsX[i] = GameConstants.positionValsX[i - 1] +
            GameConstants.blockEdgeLength! +
            GameConstants.blockOffset!;
      }

      // Compute the positions for Y
      GameConstants.positionValsY[0] = -9 / 2 * GameConstants.blockEdgeLength! +
          -9 / 2 * GameConstants.blockOffset!;
      for (int i = 1; i < GameConstants.numberOfRows; i++) {
        GameConstants.positionValsY[i] = GameConstants.positionValsY[i - 1] +
            GameConstants.blockEdgeLength! +
            GameConstants.blockOffset!;
      }
      for (int i = 0; i < GameConstants.numberOfColumns; i++) {
        GameConstants.positionValsX[i] /= 10;
      }

      for (int i = 0; i < GameConstants.numberOfRows; i++) {
        GameConstants.positionValsY[i] /= 10;
      }
      debugPrint("PositonValsX: ${GameConstants.positionValsX}");
      debugPrint("PositonValsY: ${GameConstants.positionValsY}");

      elementalBreakerGame = ElementalBreaker();
    }
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black54, // Optional: Set a background color
        body: SafeArea(
          child: Column(
            children: [
              Container(
                color: Colors.black87,
                height: UserDevice.height! * 0.08,
                child: Stack(
                  children: [
                    // Pause button aligned to the left
                    Align(
                      alignment: Alignment.centerLeft,
                      child: PauseButton(
                        game: elementalBreakerGame,
                      ),
                    ),
                    // Score display centered horizontally
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: ScoreDisplay(
                        game: elementalBreakerGame,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                color: Colors.green,
                width: GameConstants.gameWidth,
                height: GameConstants.gameHeight,
                child: GameWidget<ElementalBreaker>(
                  game: elementalBreakerGame,
                  overlayBuilderMap: {
                    OverlayIdentifiers.pauseButton:
                        (BuildContext context, ElementalBreaker game) {
                      return PauseButton(game: game);
                    },
                    OverlayIdentifiers.pausedMenu:
                        (BuildContext context, ElementalBreaker game) {
                      return PausedMenu(game: game);
                    },
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
