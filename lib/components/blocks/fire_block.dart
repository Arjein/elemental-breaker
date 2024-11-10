// fire_block.dart

import 'package:elemental_breaker/components/game_ball.dart';
import 'package:flutter/material.dart';
import 'game_block.dart';

class FireBlock extends GameBlock {
  FireBlock({
    super.color = Colors.red,
    required super.health,
    required super.size,
    required super.gridPosition, required super.vectorPosition,
  });

  @override
  void onHit(GameBall ball) {
    // Reduce health on hit
    health -= 1;
    //debugPrint('FireBlock hit by GameBall. Remaining Health: $health');

    if (health <= 0) {
      // Trigger destruction effects
      //debugPrint('FireBlock destroyed');
      removeFromParent();
    } else {
      // Optionally, change animation speed or appearance based on health
      // For example, speed up the flame animation
      //flameAnimationComponent.animation!. = 1.5;
    }
  }

  @override
  String toString() {
    return 'FireBlock(health: $health, size: $size, position: $position, color: ${paint.color})';
  }
}
