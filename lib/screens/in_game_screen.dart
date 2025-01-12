import 'package:elemental_breaker/Constants/overlay_identifiers.dart';
import 'package:elemental_breaker/Constants/user_device.dart';
import 'package:elemental_breaker/elemental_breaker.dart';
import 'package:elemental_breaker/screens/game_over_screen.dart';
import 'package:elemental_breaker/screens/paused_menu.dart';
import 'package:elemental_breaker/widgets/pause_button.dart';
import 'package:elemental_breaker/widgets/score_display.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class InGameScreen extends StatelessWidget {
  final ElementalBreaker elementalBreakerGame = GetIt.I<ElementalBreaker>();

  InGameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize device dimensions and game constants
    if (UserDevice.width == null) {
      // If first time Launch
      _initializeGameConstants(context);
      // Initialize the game instance
    }

    return Scaffold(
      backgroundColor: Colors.green, // Background color
      body: SafeArea(
        child: Column(
          children: [
            // Top bar with pause button and score display
            Container(
              color: Colors.red,
              height: UserDevice.height! * 0.08,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: PauseButton(game: elementalBreakerGame),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: ScoreDisplay(game: elementalBreakerGame),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: HighScoreDisplay(game: elementalBreakerGame),
                  ),
                ],
              ),
            ),
            // Game display area with overlays
            Container(
              color: Colors.green,
              width: GameConstants.gameWidth,
              height: GameConstants.gameHeight,
              child: GameWidget<ElementalBreaker>(
                game: elementalBreakerGame,
                overlayBuilderMap: {
                  // Pause button overlay
                  OverlayIdentifiers.pauseButton: (context, game) =>
                      PauseButton(game: game),
                  // Paused menu overlay
                  OverlayIdentifiers.pausedMenu: (context, game) =>
                      PausedMenu(game: game),
                  // Game over screen overlay
                  OverlayIdentifiers.gameOverScreen: (context, game) =>
                      GameOverScreen(game: game),
                },
                initialActiveOverlays: [],
              ),
            ),
            Expanded(child: Container())
          ],
        ),
      ),
    );
  }

  // Need Adjustments Here!!!! Dorukla karar ver ve ayarla
  void _initializeGameConstants(BuildContext context) {
    UserDevice.width = MediaQuery.of(context).size.width;
    UserDevice.height = MediaQuery.of(context).size.height;
    // Set the game's width
    GameConstants.gameWidth = UserDevice.width! * 0.95;

    // Here: set the gameHeight to 80% of the device height
    GameConstants.gameHeight = UserDevice.height! * 0.8;

    // Calculate the offset and block sizes based on the game width
    GameConstants.blockOffset = GameConstants.gameWidth! * 0.015;
    GameConstants.blockEdgeLength = (GameConstants.gameWidth! -
            (GameConstants.numberOfColumns + 1) * GameConstants.blockOffset!) /
        GameConstants.numberOfColumns;

    // Compute positions for X and Y coordinates for blocks
    GameConstants.positionValsX[0] =
        -3 * GameConstants.blockEdgeLength! + -3 * GameConstants.blockOffset!;
    for (int i = 1; i < GameConstants.numberOfColumns; i++) {
      GameConstants.positionValsX[i] = GameConstants.positionValsX[i - 1] +
          GameConstants.blockEdgeLength! +
          GameConstants.blockOffset!;
    }

    GameConstants.positionValsY[0] = -5 * GameConstants.blockEdgeLength! -
        7 / 2 * GameConstants.blockOffset!;
    ;
    for (int i = 1; i < GameConstants.numberOfRows; i++) {
      if (i == 9) {
        GameConstants.positionValsY[i] = (GameConstants.gameHeight!) / 2 -
            GameConstants.blockEdgeLength! / 2 -
            GameConstants.blockOffset! / 2;
      } else {
        GameConstants.positionValsY[i] = GameConstants.positionValsY[i - 1] +
            GameConstants.blockEdgeLength! +
            GameConstants.blockOffset!;
      }
    }

    // Scale positions for your game’s coordinate system
    for (int i = 0; i < GameConstants.numberOfColumns; i++) {
      GameConstants.positionValsX[i] /= 10;
    }
    for (int i = 0; i < GameConstants.numberOfRows; i++) {
      GameConstants.positionValsY[i] /= 10;
    }
  }
}
