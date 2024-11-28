// lib/animations/fire_ball_animation.dart

import 'package:flame/components.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';
import 'ball_animation.dart';
import 'package:flame/game.dart';

class FireBallAnimation implements BallAnimation {
  late ParticleSystemComponent fireTrail;

  @override
  Future<void> initialize(Game game, Vector2 position) async {
    // Ensure the game instance is of type FlameGame or its subclass
    if (game is! FlameGame) {
      throw Exception('Game must be a FlameGame to add components.');
    }

    // Create fire trail particles
    final particle = Particle.generate(
      count: 10,
      generator: (i) => AcceleratedParticle(
        acceleration: Vector2(0, -10),
        speed: Vector2.random() * 20,
        position: Vector2.zero(),
        lifespan: 1.0,
        child: CircleParticle(
          radius: 0.1,
          paint: Paint()..color = Colors.orange.withOpacity(1),
        ),
      ),
    );

    // Use 'child' parameter based on your Flame version
    // If your Flame version uses 'particle', replace 'child' with 'particle'
    fireTrail = ParticleSystemComponent(
      particle:
          particle, // Use 'particle: particle' if required by your Flame version
      position: position,
      anchor: Anchor.center,
    );

    // Add the particle system to the game
    game.add(fireTrail);
  }

  @override
  void update(double dt, Vector2 position) {
    // Update the position of the particle system to follow the ball
    fireTrail.position = position;
  }

  @override
  void render(Canvas canvas) {
    // Rendering is handled by Flame components
    // No additional rendering required here
  }

  @override
  void dispose() {
    // Remove the particle system from the game
    fireTrail.removeFromParent();
  }
}
