import 'package:elemental_breaker/components/game_ball.dart';
import 'package:flutter/material.dart';
import 'game_block.dart';

class EarthBlock extends GameBlock {
  EarthBlock({
    required super.health,
    required super.size,
    required super.initialPosition,
    Color color = Colors.brown,
  }) : super(color: color);

  @override
  void onHit(GameBall ball) {
    // Reduce health on hit
    health -= 1;
    debugPrint('EarthBlock hit by GameBall. Remaining Health: $health');

    if (health <= 0) {
      // Trigger destruction effects
      debugPrint('EarthBlock destroyed');
      removeFromParent();
    } else {
      // Optionally, change animation speed or appearance based on health
      // For example, speed up the flame animation
      //flameAnimationComponent.animation!. = 1.5;
    }
  }

  @override
  String toString() {
    return 'EarthBlock(health: $health, size: $size, position: $position, color: ${paint.color})';
  }
}
