import 'package:elemental_breaker/game_components.dart/game_wall.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'level_manager.dart';

class ElementalBreaker extends Forge2DGame {
  // Initialize LevelManager
  LevelManager levelManager = LevelManager();

  ElementalBreaker()
      : super(
          gravity: Vector2(0, 0),
          camera: CameraComponent(),
        ) {
    debugMode = false;
  }

  @override
  Color backgroundColor() =>
      const Color(0xFF0F0F0F); // Set your desired background color here

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    camera.viewport.add(FpsTextComponent());
    await world.add(levelManager);

    // Add boundaries
    await world.addAll(createBoundaries());
  }

  List<Component> createBoundaries() {
    final visibleRect = camera.visibleWorldRect;
    final topLeft = visibleRect.topLeft.toVector2();
    final topRight = visibleRect.topRight.toVector2();
    final bottomRight = visibleRect.bottomRight.toVector2();
    final bottomLeft = visibleRect.bottomLeft.toVector2();
    debugPrint("TopLeft, TopRight: $topLeft |$topRight");
    return [
      Wall(topLeft, topRight), // Top wall
      Wall(topRight, bottomRight), // Right wall
      Wall(bottomLeft, bottomRight, isBottomWall: true), // Bottom wall
      Wall(topLeft, bottomLeft), // Left wall
    ];
  }

  // Overlay management functions
  void showPauseMenu() {
    overlays.add('PausedMenu');
    pauseEngine();
  }

  void hidePauseMenu() {
    overlays.remove('PausedMenu');
    resumeEngine();
  }

  void showGameOverScreen() {
    overlays.add('GameOverScreen');
  }

  void hideGameOverScreen() {
    overlays.remove('GameOverScreen');
  }

  void restartGame() {
    hideGameOverScreen();
    hidePauseMenu();
    levelManager.reset();
    levelManager.initializeGame();
  }

  ValueNotifier<int> get currentLevelNotifier =>
      levelManager.currentLevelNotifier;
}
