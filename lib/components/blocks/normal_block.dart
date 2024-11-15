// fire_block.dart

import 'package:elemental_breaker/components/game_ball.dart';
import 'package:flutter/material.dart';
import 'game_block.dart';

class NormalBlock extends GameBlock {
  NormalBlock({
    required super.health,
    required super.size,
    super.color = Colors.black,
    required super.vectorPosition,
    required super.gridManager,
  });

  @override
  void onHit(GameBall ball) {
    // Reduce health on hit
    health -= 1;
    debugPrint('NormalBlock hit by GameBall. Remaining Health: $health');

    if (health <= 0) {
      // Trigger destruction effects
      debugPrint('NormalBlock destroyed');
      removeFromParent();
    } else {
      // Optionally, change animation speed or appearance based on health
      // For example, speed up the flame animation
      //flameAnimationComponent.animation!. = 1.5;
    }
  }

  @override
  String toString() {
    return 'NormalBlock(health: $health, size: $size, position: $position, color: ${paint.color})';
  }

  @override
  void triggerElementalEffect() {
    // TODO: implement triggerElementalEffect
  }
}
