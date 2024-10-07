// fire_block.dart

import 'package:elemental_breaker/components/game_ball.dart';
import 'package:flutter/material.dart';
import 'game_block.dart';

class WaterBlock extends GameBlock {
  WaterBlock({
    required super.health,
    required super.size,
    required super.initialPosition,
    Color color = Colors.blue,
  }) : super(color: color);

  @override
  void onHit(GameBall ball) {
    // Reduce health on hit
    health -= 1;
    debugPrint('WaterBlock hit by GameBall. Remaining Health: $health');

    if (health <= 0) {
      // Trigger destruction effects
      debugPrint('WaterBlock destroyed');
      removeFromParent();
    } else {
      // Optionally, change animation speed or appearance based on health
      // For example, speed up the flame animation
      //flameAnimationComponent.animation!. = 1.5;
    }
  }

  @override
  String toString() {
    return 'WaterBlock(health: $health, size: $size, position: $position, color: ${paint.color})';
  }
}
