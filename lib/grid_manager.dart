// grid_manager.dart

import 'dart:math';
import 'package:elemental_breaker/components/blocks/game_block.dart';
import 'package:elemental_breaker/Constants/user_device.dart';
import 'package:flutter/material.dart';
import 'package:flame/components.dart';

class GridManager {
  final int gridColumns;
  final int gridRows;
  final List<List<GameBlock?>> gridBlocks;
  final Map<GameBlock, Point<int>> blockPositions = {};

  GridManager({required this.gridColumns, required this.gridRows})
      : gridBlocks = List.generate(
          gridRows,
          (_) => List<GameBlock?>.filled(gridColumns, null),
        );

  void addBlock(GameBlock block, int xAxisIndex, int yAxisIndex) {
    if (yAxisIndex < 0 ||
        yAxisIndex >= gridRows ||
        xAxisIndex < 0 ||
        xAxisIndex >= gridColumns) {
      throw Exception('Grid indices out of bounds');
    }

    if (gridBlocks[yAxisIndex][xAxisIndex] != null) {
      throw Exception('Grid position already occupied');
    }
    gridBlocks[yAxisIndex][xAxisIndex] = block;
    blockPositions[block] = Point(xAxisIndex, yAxisIndex);

    debugPrint("Block added at ($xAxisIndex, $yAxisIndex)");
  }

  void removeBlockFromGrid(GameBlock block) {
    debugPrint("We will Remove this Block: $block");
    Point<int>? position = blockPositions[block];
    debugPrint("THe position of this block is $position");
    if (position != null) {
      gridBlocks[position.y][position.x] = null;
      blockPositions.remove(block);
      block.removeFromParent();
      debugPrint("Block removed from (${position.x}, ${position.y})");
      debugPrint("So, the position is: ${gridBlocks[position.y][position.x]}");
    }
  }

  void updateBlockPosition(
      GameBlock block, int newXAxisIndex, int newYAxisIndex) {
    // Ensure new indices are within bounds
    if (newXAxisIndex < 0 ||
        newXAxisIndex >= gridColumns ||
        newYAxisIndex < 0 ||
        newYAxisIndex >= gridRows) {
      throw Exception('New grid indices out of bounds');
    }

    // Remove from old position
    Point<int>? oldPosition = blockPositions[block];
    if (oldPosition != null) {
      gridBlocks[oldPosition.y][oldPosition.x] = null;
      debugPrint("Block moved from (${oldPosition.x}, ${oldPosition.y})");
    }

    // Check if new position is occupied
    if (gridBlocks[newYAxisIndex][newXAxisIndex] != null) {
      throw Exception('New grid position already occupied');
    }

    // Add to new position
    gridBlocks[newYAxisIndex][newXAxisIndex] = block;
    blockPositions[block] = Point(newXAxisIndex, newYAxisIndex);
    debugPrint("Block moved to ($newXAxisIndex, $newYAxisIndex)");

    //debugPrint("BlockList:$gridBlocks");
    //debugPrint("BlockPositons::$blockPositions");
  }

  Vector2 getPositionFromGridIndices(int xAxisIndex, int yAxisIndex) {
    double x = GameConstants.positionValsX[xAxisIndex];
    double y = GameConstants.positionValsY[yAxisIndex];
    return Vector2(x, y);
  }

  List<GameBlock> getAdjacentBlocks(GameBlock block) {
    List<GameBlock> adjacentBlocks = [];
    Point<int>? pos = blockPositions[block];
    if (pos == null) return adjacentBlocks;

    int x = pos.x;
    int y = pos.y;

    List<List<int>> directions = [
      [0, -1], // Up
      [0, 1], // Down
      [-1, 0], // Left
      [1, 0], // Right
    ];

    for (List<int> dir in directions) {
      int newX = x + dir[0];
      int newY = y + dir[1];

      if (newX >= 0 && newX < gridColumns && newY >= 0 && newY < gridRows) {
        GameBlock? adjacentBlock = gridBlocks[newY][newX];
        if (adjacentBlock != null) {
          adjacentBlocks.add(adjacentBlock);
        }
      }
    }
    return adjacentBlocks;
  }

  Future<void> moveBlocksDown() async {
    int movingBlocks = 0;
    List<Future<void>> moveFutures = [];

    // Start from the second-to-last row and move upwards
    for (int y = gridRows - 2; y >= 0; y--) {
      for (int x = 0; x < gridColumns; x++) {
        GameBlock? block = gridBlocks[y][x];
        if (block != null) {
          // Check if the block can move down
          if (y + 1 < gridRows && gridBlocks[y + 1][x] == null) {
            // Delegate the move to _moveBlock, which uses updateBlockPosition
            moveFutures.add(_moveBlock(block, x, y + 1));
            movingBlocks++;
          }
        }
      }
    }

    // Wait for all block movements to complete
    await Future.wait(moveFutures);

    if (movingBlocks == 0) {
      // No blocks to move, proceed immediately
      checkGameOver();
    }
  }

  Future<void> _moveBlock(
      GameBlock block, int newXAxisIndex, int newYAxisIndex) async {
    try {
      // Update the block's position in the grid
      updateBlockPosition(block, newXAxisIndex, newYAxisIndex);

      // Calculate the new position in the game world
      Vector2 newPosition =
          getPositionFromGridIndices(newXAxisIndex, newYAxisIndex);

      // Animate the block to the new position
      block.updatePosition(newXAxisIndex, newYAxisIndex, onComplete: () {
        // After moving, you might want to perform additional logic
        // For example, checking for block merges, triggers, etc.
        // Currently, nothing is done here.
      });

      // Wait for the block to finish moving
      await Future.delayed(Duration(
          milliseconds:
              400)); // Duration should match block's movement duration
    } catch (e) {
      debugPrint('Error moving block: $e');
    }
  }

  bool checkGameOver() {
    // Check if any block is in the bottom row
    for (int x = 0; x < gridColumns; x++) {
      if (gridBlocks[gridRows - 1][x] != null) {
        debugPrint("GAME OVER: Block at bottom row");
        return true;
      }
    }
    return false;
  }

  // Optional: Clear all blocks (useful for restarting the game)
  void clearAllBlocks() {
    for (GameBlock block in blockPositions.keys.toList()) {
      block.removeBlock();
    }
  }
}
