import 'package:elemental_breaker/Constants/elements.dart';
import 'package:elemental_breaker/block_factory.dart';
import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'components/ball_launcher.dart';
import 'components/drag_handler.dart';

class LevelManager extends Component with HasGameRef<Forge2DGame> {
  late int currentLevel;
  late BallLauncher _ballLauncher;
  late DragHandler _dragHandler;
  late BlockFactory _blockFactory;
  late bool isLaunching;
  late double gameWidth;
  late double gameHeight;

  LevelManager();

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    gameWidth = gameRef.size.x;
    gameHeight = gameRef.size.y;

    debugPrint("GameWidth: $gameWidth");
    debugPrint("GameHeight: $gameHeight");

    int gridSize = 6;
    int gridHeightSize = 8;
    final blockwidth = (gameWidth - 18) / gridSize;

    _blockFactory = BlockFactory(game: gameRef);
    // Initialize the BallLauncher
    final launchPosition = Vector2(0, 30); // Bottom center
    _ballLauncher =
        BallLauncher(levelManager: this, initialPosition: launchPosition);

    // Initialize the DragHandler
    _dragHandler = DragHandler(levelManager: this);

    // Add BallLauncher and DragHandler to the game
    await gameRef.world.add(_ballLauncher);
    await _ballLauncher.loaded; // Wait for BallLauncher to finish loading

    await gameRef.world.add(_dragHandler);
    debugPrint("DEBUG");
    initializeGame();
  }

  void initializeGame() async {
    isLaunching = false;
    currentLevel = 1;
    //createBlocksForLevel(1);

    //debugPrint(fireBlock.toString());

    debugPrint("Game initialized");

    // random init grid
  }

  void nextLevel() {
    debugPrint("Current Level: $currentLevel");
    ballLauncher.reset();

    // Creat the grid logic
  }

  void onLaunchDirectionSet(Vector2 direction) {
    debugPrint("Launch Direction Set");
    // Set launch parameters in the BallLauncher
    _ballLauncher.setLaunchParameters(direction);

    // Start launching balls based on the current level
    _ballLauncher.startLaunching(currentLevel);
    isLaunching = true;
  }

  void onAllBallsReturned() {
    currentLevel++;
    debugPrint("Islaunching: $isLaunching");
    // Start the next level
    nextLevel();
  }

  Future<void> createBlocksForLevel(int level) async {
    // Example logic to create blocks based on the level
    // This can be customized to create different patterns or difficulties

    // For demonstration, we'll create one of each block type
    await _blockFactory.createBlock(
      type: Elements.fire,
      health: 3,
      size: Vector2(2.0, 2.0),
      position: Vector2(10.0, 15.0),
    );

    await _blockFactory.createBlock(
      type: Elements.water,
      health: 3,
      size: Vector2(2.0, 2.0),
      position: Vector2(15.0, 15.0),
    );

    await _blockFactory.createBlock(
      type: Elements.earth,
      health: 3,
      size: Vector2(2.0, 2.0),
      position: Vector2(20.0, 15.0),
    );

    await _blockFactory.createBlock(
      type: Elements.air,
      health: 3,
      size: Vector2(2.0, 2.0),
      position: Vector2(25.0, 15.0),
    );

    // Add more blocks as needed based on the level
  }

  BallLauncher get ballLauncher => _ballLauncher;
  DragHandler get dragHandler => _dragHandler;
}
