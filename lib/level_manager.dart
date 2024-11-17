import 'dart:math';

import 'package:elemental_breaker/Constants/elements.dart';
import 'package:elemental_breaker/Constants/overlay_identifiers.dart';
import 'package:elemental_breaker/Constants/user_device.dart';
import 'package:elemental_breaker/block_factory.dart';
import 'package:elemental_breaker/components/blocks/game_block.dart';
import 'package:elemental_breaker/grid_manager.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'components/ball_launcher.dart';
import 'components/drag_handler.dart';

class LevelManager extends Component with HasGameRef<Forge2DGame> {
  final ValueNotifier<int> currentLevelNotifier = ValueNotifier<int>(1);
  late BallLauncher _ballLauncher;
  late DragHandler _dragHandler;
  late BlockFactory _blockFactory;
  late bool isLaunching;
  late Elements currentBallElement;
  late GridManager gridManager;

  LevelManager();

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Initialize GridManager
    gridManager = GridManager(gridColumns: 7, gridRows: 10);

    // Initialize BlockFactory with GridManager
    _blockFactory = BlockFactory(game: gameRef, gridManager: gridManager);

    // Initialize the BallLauncher
    final launchPosition =
        game.camera.visibleWorldRect.bottomCenter.toVector2();

    _ballLauncher = BallLauncher(
      levelManager: this,
      initialPosition: launchPosition,
      orbObjectSize: 4,
    );

    // Initialize the DragHandler
    _dragHandler = DragHandler(levelManager: this);

    // Add BallLauncher and DragHandler to the game
    await gameRef.world.add(_ballLauncher);
    await _ballLauncher.loaded;
    await gameRef.world.add(_dragHandler);

    // Initialize the grid (if needed)
    // Note: gridManager already initializes gridBlocks in its constructor

    initializeGame();
  }

  Elements getRandomElement() {
    // Randomly select one of the elements
    int randomIndex = Random().nextInt(Elements.values.length);
    return Elements.values[randomIndex];
  }

  // Initialize the game state
  void initializeGame() async {
    gridManager.reset();
    isLaunching = false;
    currentLevelNotifier.value = 1;
    currentBallElement = getRandomElement();

    await createBlocksForLevel(1);
    //await createTestBlocks();
    ballLauncher.reset();

    await gridManager.moveBlocksDown();
    debugPrint("Game initialized");
  }

  Future<void> createTestBlocks() async {
    await _blockFactory.createBlock(
      type: Elements.water,
      health: 1,
      xAxisIndex: 1,
      yAxisIndex: 0,
    );
    await _blockFactory.createBlock(
      type: Elements.fire,
      health: 1,
      xAxisIndex: 2,
      yAxisIndex: 0,
    );
    await _blockFactory.createBlock(
      type: Elements.air,
      health: 1,
      xAxisIndex: 3,
      yAxisIndex: 0,
    );
    await _blockFactory.createBlock(
      type: Elements.earth,
      health: 1,
      xAxisIndex: 4,
      yAxisIndex: 0,
    );
    await Future.delayed(Duration(milliseconds: 50));
  }

  // Proceed to the next level
  void nextLevel() async {
    currentLevelNotifier.value += 1;
    currentBallElement = getRandomElement();
    debugPrint("Current Level: ${currentLevelNotifier.value}");
    ballLauncher.reset();
    await createBlocksForLevel(currentLevelNotifier.value);
    //await createTestBlocks();
    await gridManager.moveBlocksDown();
    if (checkGameOver()) {
      int highScore = await HighScoreManager.getHighScore();
      if (currentLevelNotifier.value > highScore) {
        HighScoreManager.saveHighScore(highScore);
      }
      debugPrint("GAME OVER");
      game.overlays.add(OverlayIdentifiers.gameOverScreen);
    }
  }

  // Handle launch direction set by the player
  void onLaunchDirectionSet(Vector2 direction) {
    // Set launch parameters in the BallLauncher
    _ballLauncher.setLaunchParameters(direction);

    // Start launching balls based on the current level
    _ballLauncher.startLaunching(currentLevelNotifier.value);
    isLaunching = true;
  }

  // Trigger elemental effects on all blocks marked as ready
  Future<void> triggerElementalEffects() async {
    List<Future<void>> effectFutures = [];

    for (int y = 0; y < gridManager.gridRows; y++) {
      for (int x = 0; x < gridManager.gridColumns; x++) {
        GameBlock? block = gridManager.gridBlocks[y][x];
        if (block != null && block.isReadyToTrigger) {
          debugPrint("Elemental Effect on Block: $block");
          effectFutures.add(block.triggerElementalEffect());
        }
      }
    }
    await Future.wait(effectFutures);
  }

  void reset() async {
    gridManager.reset();
    _ballLauncher.restart();
  }

  // Called when all balls have returned
  void onAllBallsReturned() async {
    debugPrint("IsLaunching: $isLaunching");
    await triggerElementalEffects();

    // Start the next level
    nextLevel();
    //initializeGame();
  }

  // Create blocks for a given level
  Future<void> createBlocksForLevel(int level) async {
    int numBlocksToGenerate = Random().nextInt(gridManager.gridColumns) + 1;
    Set<int> usedXAxisIndices = {};
    for (int i = 0; i < numBlocksToGenerate; i++) {
      int xAxisIndex;
      do {
        xAxisIndex = Random().nextInt(gridManager.gridColumns);
      } while (usedXAxisIndices.contains(xAxisIndex));

      usedXAxisIndices.add(xAxisIndex);

      Elements randomElement =
          Elements.values[Random().nextInt(Elements.values.length)];
      int health = level;

      await _blockFactory.createBlock(
        type: randomElement,
        health: health,
        xAxisIndex: xAxisIndex,
        yAxisIndex: 0,
      );
    }
    await Future.delayed(Duration(milliseconds: 50));
  }

  bool checkGameOver() {
    debugPrint("Longest Column Length: ${gridManager.longestColumnLength}");
    return gridManager.longestColumnLength >= gridManager.gridRows;
  }

  Vector2 getPositionFromGridIndices(int xAxisIndex, int yAxisIndex) {
    // This method can be removed if GridManager handles position retrieval
    double x = GameConstants.positionValsX[xAxisIndex];
    double y = GameConstants.positionValsY[yAxisIndex];
    return Vector2(x, y);
  }

  // Remove redundant moveBlocksDown from LevelManager
  // It is now handled by GridManager
  // void moveBlocksDown() { ... }

  BallLauncher get ballLauncher => _ballLauncher;
  DragHandler get dragHandler => _dragHandler;
}
