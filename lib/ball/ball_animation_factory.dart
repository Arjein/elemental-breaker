// lib/animations/ball_animation_factory.dart

import 'package:elemental_breaker/Constants/elements.dart';
import 'package:elemental_breaker/ball/fireball_animation.dart';
import 'ball_animation.dart';
// Import other animation classes as needed

class BallAnimationFactory {
  BallAnimation createAnimation(Elements element) {
    switch (element) {
      case Elements.fire:
        return FireBallAnimation();

      // Add other cases for different elements
      default:
        throw UnimplementedError('Animation for $element not implemented');
    }
  }
}
