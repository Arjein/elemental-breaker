import 'package:elemental_breaker/Constants/overlay_identifiers.dart';
import 'package:elemental_breaker/Constants/user_device.dart';
import 'package:elemental_breaker/elemental_breaker.dart';
import 'package:elemental_breaker/screens/game_over_screen.dart';
import 'package:elemental_breaker/screens/paused_menu.dart';
import 'package:elemental_breaker/widgets/pause_button.dart';
import 'package:elemental_breaker/widgets/score_display.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class InGameScreen extends StatelessWidget {
  late final ElementalBreaker elementalBreakerGame;

  InGameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize device dimensions and game constants
    if (UserDevice.width == null) {
      UserDevice.width = MediaQuery.of(context).size.width;
      UserDevice.height = MediaQuery.of(context).size.height;
      GameConstants.gameWidth = UserDevice.width;
      GameConstants.blockOffset = GameConstants.gameWidth! * 0.015;

      GameConstants.blockEdgeLength = (GameConstants.gameWidth! -
              (GameConstants.numberOfColumns + 1) *
                  GameConstants.blockOffset!) /
          GameConstants.numberOfColumns;

      GameConstants.gameHeight =
          GameConstants.numberOfRows * GameConstants.blockEdgeLength! +
              (GameConstants.numberOfRows + 1) * GameConstants.blockOffset!;

      // Compute positions for X and Y coordinates for blocks
      GameConstants.positionValsX[0] =
          -3 * GameConstants.blockEdgeLength! + -3 * GameConstants.blockOffset!;
      for (int i = 1; i < GameConstants.numberOfColumns; i++) {
        GameConstants.positionValsX[i] = GameConstants.positionValsX[i - 1] +
            GameConstants.blockEdgeLength! +
            GameConstants.blockOffset!;
      }

      GameConstants.positionValsY[0] = -9 / 2 * GameConstants.blockEdgeLength! +
          -9 / 2 * GameConstants.blockOffset!;
      for (int i = 1; i < GameConstants.numberOfRows; i++) {
        GameConstants.positionValsY[i] = GameConstants.positionValsY[i - 1] +
            GameConstants.blockEdgeLength! +
            GameConstants.blockOffset!;
      }

      // Scale positions for your game’s coordinate system
      for (int i = 0; i < GameConstants.numberOfColumns; i++) {
        GameConstants.positionValsX[i] /= 10;
      }
      for (int i = 0; i < GameConstants.numberOfRows; i++) {
        GameConstants.positionValsY[i] /= 10;
      }

      // Initialize the game instance
      elementalBreakerGame = ElementalBreaker();
    }

    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black54, // Background color
        body: SafeArea(
          child: Column(
            children: [
              // Top bar with pause button and score display
              Container(
                color: Colors.black87,
                height: UserDevice.height! * 0.08,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: PauseButton(game: elementalBreakerGame),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: ScoreDisplay(game: elementalBreakerGame),
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
            ],
          ),
        ),
      ),
    );
  }
}
