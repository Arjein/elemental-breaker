import 'package:flame/components.dart';
import 'package:flame/particles.dart';
import 'package:flame_forge2d/body_component.dart';

import 'package:flutter/material.dart';
import 'dart:math';

class FireballFlameEffect extends PositionComponent {
  final BodyComponent ball;
  final Random _random = Random();

  FireballFlameEffect({required this.ball});

  @override
  Future<void> onLoad() async {
    super.onLoad();
    debugMode = true;

    final flameParticle = Particle.generate(
      count: 5,
      lifespan: 10,
      generator: (i) {
        // Calculate the emission direction with randomness
        final velocity = ball.body.linearVelocity;
        final emissionDirection = -velocity;
        final angleVariation =
            (_random.nextDouble() - 0.1) * pi / 6; // +/- 15 degrees
        final rotatedDirection = emissionDirection.clone()
          ..rotate(angleVariation);

        // Add slight randomness to particle start position around the ball
        final offsetX = (_random.nextDouble() - 0.5) * 0.5; // Reduced offset
        final offsetY = (_random.nextDouble() - 0.5) * 0.5;

        return AcceleratedParticle(
          speed: rotatedDirection,
          position: Vector2(offsetX, offsetY),
          child: CircleParticle(
            radius: 0.4,
            paint: Paint()..color = Colors.orange.withOpacity(0.9),
          ),
        );
      },
    );

    // Add a particle system to continuously emit particles
    final particleSystem = ParticleSystemComponent(
      particle: flameParticle,
      position: Vector2.zero(), // Position is relative to the parent
    );
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Continuously update the position to follow the ball
    position = ball.body.position;
  }
}
