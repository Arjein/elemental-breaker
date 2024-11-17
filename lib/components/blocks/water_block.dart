// fire_block.dart

import 'package:elemental_breaker/Constants/elements.dart';
import 'package:elemental_breaker/components/game_ball.dart';
import 'package:flutter/material.dart';
import 'game_block.dart';

class WaterBlock extends GameBlock {
  final Elements element = Elements.water;
  late List<GameBlock> columnBlocks;

  WaterBlock({
    required super.health,
    required super.size,
    super.color = Colors.blue,
    required super.vectorPosition,
    required super.gridManager,
  });

  @override
  void onHit(GameBall ball) {
    if (isStacking) {
      if (ball.element == element) {
        // Continue stacking
        stack++;
      }
    } else {
      health--;
      if (health <= 0) {
        if (ball.element == element) {
          // Start stacking
          isStacking = true;
          isReadyToTrigger = true; // Mark for triggering at end of level
          columnBlocks = gridManager.getBlockColumn(this);
          for (GameBlock block in columnBlocks) {
            block.highlight(elementColorMap[ball.element]);
          }
        } else {
          // Remove the block immediately
          removeBlock();
        }
      }
    }
  }

  @override
  String toString() {
    return 'WaterBlock(health: $health, size: $size, position: $position, color: ${paint.color})';
  }

  @override
  Future<void> triggerElementalEffect() async {
    if (isReadyToTrigger) {
      // Get adjacent blocks

      // Damage adjacent blocks based on the stack count
      for (GameBlock block in columnBlocks) {
        block.isHighlighted = false;
        if (block.health - stack <= 0) {
          block.removeBlock();
        } else {
          block.health -= stack;
        }
      }
      // Remove this block
      removeBlock();
    }
  }
}
