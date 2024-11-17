// fire_block.dart

import 'package:elemental_breaker/Constants/elements.dart';
import 'package:elemental_breaker/components/game_ball.dart';

import 'package:flutter/material.dart';
import 'game_block.dart';

class FireBlock extends GameBlock {
  final Elements element = Elements.fire;
  late List<GameBlock> adjacentBlocks;
  FireBlock({
    required super.gridManager,
    required super.health,
    required super.size,
    required super.vectorPosition,
  }) : super(
          color: Colors.red,
        );

  @override
  void onHit(GameBall ball) {
    debugPrint("Size: ${super.size}");
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
          adjacentBlocks = gridManager.getAdjacentBlocks(this);
          for (GameBlock block in adjacentBlocks) {
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
  Future<void> triggerElementalEffect() async {
    if (isReadyToTrigger) {
      // Damage adjacent blocks based on the stack count
      for (GameBlock block in adjacentBlocks) {
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

  @override
  String toString() {
    return 'FireBlock(health: $health, size: $size, position: ${body.position}, color: ${paint.color})';
  }
}
