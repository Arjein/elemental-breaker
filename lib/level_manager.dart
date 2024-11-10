import 'dart:math';

import 'package:elemental_breaker/Constants/elements.dart';
import 'package:elemental_breaker/Constants/user_device.dart';
import 'package:elemental_breaker/block_factory.dart';
import 'package:elemental_breaker/components/blocks/game_block.dart';
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

  // Grid Dimensions:
  final int gridColumns = 7;
  final int gridRows = 10;

  // Grid of blocks
  late List<List<GameBlock?>> gridBlocks;

  // Block Size:
  late Vector2 blockSize;

  LevelManager();

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Initialize grid
    gridBlocks = List.generate(
      gridRows,
      (_) => List<GameBlock?>.filled(gridColumns, null),
    );
    debugPrint("GridBlocks: $gridBlocks");

    _blockFactory = BlockFactory(game: gameRef);

    // Initialize the BallLauncher
    final launchPosition =
        game.camera.visibleWorldRect.bottomCenter.toVector2();
    _ballLauncher = BallLauncher(
        levelManager: this, initialPosition: launchPosition, orbObjectSize: 5);

    // Initialize the DragHandler
    _dragHandler = DragHandler(levelManager: this);

    // Add BallLauncher and DragHandler to the game
    await gameRef.world.add(_ballLauncher);
    await _ballLauncher.loaded; // Wait for BallLauncher to finish loading

    await gameRef.world.add(_dragHandler);
    initializeGame();
  }

  void initializeGame() async {
    isLaunching = false;
    currentLevelNotifier.value = 1;
    await createBlocksForLevel(1);
    await moveBlocksDown();
    debugPrint("Game initialized");

    // random init grid
  }

  void nextLevel() async {
    currentLevelNotifier.value += 1;

    debugPrint("Current Level: ${currentLevelNotifier.value}");
    ballLauncher.reset();
    await createBlocksForLevel(currentLevelNotifier.value);
    await moveBlocksDown();
    if (checkGameOver()) {
      gameOver();
    }

    // Creat the grid logic
  }

  void onLaunchDirectionSet(Vector2 direction) {
    // Set launch parameters in the BallLauncher
    _ballLauncher.setLaunchParameters(direction);

    // Start launching balls based on the current level
    _ballLauncher.startLaunching(currentLevelNotifier.value);
    isLaunching = true;
  }

  void onAllBallsReturned() {
    debugPrint("Islaunching: $isLaunching");
    // Start the next level
    nextLevel();
  }

  Future<void> createBlocksForLevel(int level) async {
    // Example logic to create blocks based on the level

    // if check GAME OVER

    int numBlocksToGenerate = Random().nextInt(gridColumns) + 1;
    Set<int> usedXAxisIndices = {};
    for (int i = 0; i < numBlocksToGenerate; i++) {
      // Generate a random xAxisIndex not already used
      int xAxisIndex;
      do {
        xAxisIndex = Random().nextInt(gridColumns); // 0 to gridColumns - 1
      } while (usedXAxisIndices.contains(xAxisIndex));

      usedXAxisIndices.add(xAxisIndex);

      // Generate a random element
      Elements randomElement =
          Elements.values[Random().nextInt(Elements.values.length)];

      // Create the block
      int health = level; // For example, health increases with level

      GameBlock block = await _blockFactory.createBlock(
        type: randomElement,
        health: health,
        xAxisIndex: xAxisIndex,
        yAxisIndex: 0,
      );
      gridBlocks[0][xAxisIndex] = block;
    }
    await Future.delayed(Duration(milliseconds: 50));
  }

  bool checkGameOver() {
    // Check if any block is in the bottom row
    for (int x = 0; x < gridColumns; x++) {
      if (gridBlocks[gridRows - 1][x] != null) {
        return true;
      }
    }
    return false;
  }

  void gameOver() {
    // Implement your game over logic here
    // For example, stop the game, show a game over screen, etc.
    debugPrint('Game Over! Handling game over logic.');
  }

  Vector2 getPositionFromGridIndices(int xAxisIndex, int yAxisIndex) {
    double x = GameConstants.positionValsX[xAxisIndex];
    double y = GameConstants.positionValsY[yAxisIndex];

    return Vector2(x, y);
  }

  moveBlocksDown() {
    int movingBlocks = 0;

    // Start from the second-to-last row and move upwards
    for (int y = gridRows - 2; y >= 0; y--) {
      for (int x = 0; x < gridColumns; x++) {
        GameBlock? block = gridBlocks[y][x];
        if (block != null) {
          // Check if the block can move down
          if (y + 1 < gridRows) {
            // Move the block reference down in the grid
            gridBlocks[y + 1][x] = block;
            gridBlocks[y][x] = null;

            // Update block's grid position
            block.gridPosition[1] = y + 1;

            movingBlocks++;

            // Calculate the new position in the game world
            Vector2 newPosition = getPositionFromGridIndices(x, y + 1);

            // Animate the block to the new position
            block.updatePosition(newPosition, onComplete: () {
              movingBlocks--;
              if (movingBlocks == 0) {
                // All blocks have finished moving
                // Proceed with the game logic, e.g., checking for game over
                // checkGameOver();
              }
            });
          } else {
            // The block has reached the bottom row
            // Handle game over condition
            // You can set a flag or call a method here
            // For example:
            //gameOver();
          }
        }
      }
    }

    if (movingBlocks == 0) {
      // No blocks to move, proceed immediately
      //checkGameOver();
    }
  }

  BallLauncher get ballLauncher => _ballLauncher;
  DragHandler get dragHandler => _dragHandler;
}
