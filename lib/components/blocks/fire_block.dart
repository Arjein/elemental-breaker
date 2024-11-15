// fire_block.dart

import 'package:elemental_breaker/Constants/elements.dart';
import 'package:elemental_breaker/components/game_ball.dart';
import 'package:flutter/material.dart';
import 'game_block.dart';

class FireBlock extends GameBlock {
  final Elements element = Elements.fire;

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
        } else {
          // Remove the block immediately
          removeBlock();
        }
      }
    }
  }

  @override
  void triggerElementalEffect() {
    if (isReadyToTrigger) {
      // Get adjacent blocks
      List<GameBlock> adjacentBlocks = gridManager.getAdjacentBlocks(this);
      debugPrint("Blocks Adjacent to this Block: $adjacentBlocks");
      // Damage adjacent blocks based on the stack count
      for (GameBlock block in adjacentBlocks) {
        block.health -= stack;
        if (block.health <= 0) {
          block.removeBlock();
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
