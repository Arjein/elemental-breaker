// fire_block.dart

import 'package:elemental_breaker/Constants/elements.dart';
import 'package:elemental_breaker/components/game_ball.dart';
import 'package:flutter/material.dart';
import 'game_block.dart';

class WaterBlock extends GameBlock {
  final Elements element = Elements.water;
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
  void triggerElementalEffect() {
    // TODO: implement triggerElementalEffect
  }
}
