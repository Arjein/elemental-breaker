// grid_manager.dart

import 'dart:math';
import 'package:elemental_breaker/blocks/game_block.dart';
import 'package:elemental_breaker/Constants/user_device.dart';
import 'package:flutter/material.dart';
import 'package:flame/components.dart';

class GridManager {
  final int gridColumns;
  final int gridRows;
  final List<List<GameBlock?>> gridBlocks;
  final Map<GameBlock, Point<int>> blockPositions = {};
  int longestColumnLength = 0;
  int? longestColumn;

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
      debugPrint("BlockPosition: ${blockPositions[block]}");
    }
  }

  List<GameBlock> getRandomBlocks(int count) {
    List<GameBlock> allBlocks = [];

    for (int y = 0; y < gridRows; y++) {
      for (int x = 0; x < gridColumns; x++) {
        GameBlock? block = gridBlocks[y][x];
        if (block != null) {
          allBlocks.add(block);
        }
      }
    }

    if (allBlocks.length <= count) {
      return allBlocks;
    }

    allBlocks.shuffle();

    return allBlocks.sublist(0, count);
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
      debugPrint("Block moved from Block Position: ($oldPosition})");
    }

    // Check if new position is occupied
    if (gridBlocks[newYAxisIndex][newXAxisIndex] != null) {
      throw Exception('New grid position already occupied');
    }

    // Add to new position
    gridBlocks[newYAxisIndex][newXAxisIndex] = block;
    blockPositions[block] = Point(newXAxisIndex, newYAxisIndex);
    block.gridXIndex = newXAxisIndex;
    block.gridYIndex = newYAxisIndex;
    debugPrint("Block moved to : ${block.gridXIndex}, ${block.gridYIndex}");

    if (newYAxisIndex + 1 > longestColumnLength) {
      longestColumnLength = newYAxisIndex + 1;
      longestColumn = newXAxisIndex;
      debugPrint("Longest Column: $longestColumn");
    }
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

  int getLowestOccupiedRow() {
    for (int y = gridRows - 1; y >= 0; y--) {
      for (int x = 0; x < gridColumns; x++) {
        if (gridBlocks[y][x] != null) {
          return y; // Return the row index closest to the bottom with a block
        }
      }
    }
    return -1; // Return -1 if no blocks are present
  }

  List<GameBlock> getGroundBlocks() {
    List<GameBlock> groundBlocks = [];
    int lowestRow = getLowestOccupiedRow(); // Find the lowest occupied row

    if (lowestRow != -1) {
      // Ensure there are blocks in the grid
      for (int x = 0; x < gridColumns; x++) {
        GameBlock? block = gridBlocks[lowestRow][x];
        if (block != null) {
          groundBlocks.add(block); // Add all blocks in the lowest row
        }
      }
    }

    return groundBlocks; // Return the list of ground blocks
  }

  List<GameBlock> getBlockColumn(GameBlock block) {
    List<GameBlock> column = [];
    for (int i = 0; i < gridRows; i++) {
      debugPrint(
          "Block at ZORT ${block.gridXIndex}, ${block.gridYIndex}: ${block.health} and stack: ${block.stack}");
      if (gridBlocks[i][blockPositions[block]!.x] != null) {
        column.add(gridBlocks[i][blockPositions[block]!.x]!);
      }
    }
    return column; // Return the list of ground blocks
  }

  List<GameBlock> getBlockRow(GameBlock block) {
    List<GameBlock> column = [];
    for (int i = 0; i < gridColumns; i++) {
      if (gridBlocks[blockPositions[block]!.y][i] != null) {
        column.add(gridBlocks[blockPositions[block]!.y][i]!);
      }
    }
    return column; // Return the list of ground blocks
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
    }
  }

  Future<void> _moveBlock(
      GameBlock block, int newXAxisIndex, int newYAxisIndex) async {
    try {
      // Update the block's position in the grid
      updateBlockPosition(block, newXAxisIndex, newYAxisIndex);

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

  // Optional: Clear all blocks (useful for restarting the game)
  void reset() {
    for (GameBlock block in blockPositions.keys.toList()) {
      block.removeBlock();
    }
    longestColumn = null;
    longestColumnLength = 0;
  }

  @override
  String toString() {
    StringBuffer buffer = StringBuffer();

    for (int y = 0; y < gridRows; y++) {
      for (int x = 0; x < gridColumns; x++) {
        buffer.write(gridBlocks[y][x] != null ? '1 ' : '- ');
      }
      buffer.write('\n'); // Newline after each row
    }

    return buffer.toString();
  }
}
