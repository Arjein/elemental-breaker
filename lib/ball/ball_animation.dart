// lib/animations/ball_animation.dart

import 'package:flame/game.dart';
import 'package:flutter/material.dart';

abstract class BallAnimation {
  /// Initialize the animation components.
  Future<void> initialize(FlameGame game, Vector2 position);

  /// Update animation components based on the ball's state.
  void update(double dt, Vector2 position);

  /// Render animation components.
  void render(Canvas canvas);

  /// Dispose of animation components.
  void dispose();
}
