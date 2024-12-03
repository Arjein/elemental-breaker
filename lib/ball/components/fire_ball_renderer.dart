import 'dart:math';
import 'package:elemental_breaker/Constants/elements.dart';
import 'package:elemental_breaker/ball/components/base_ball_renderer.dart';
import 'package:flame/components.dart';
import 'package:flame/particles.dart';
import 'package:flame_forge2d/body_component.dart';
import 'package:flutter/material.dart';

class FireBallRenderer extends BaseBallRenderer {
  final BodyComponent ball;
  late final Sprite sparkle;
  FireBallRenderer({
    required super.radius,
    required this.ball,
  }) : super(
          element: Elements.fire,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Load the fireball sprite
    sprite = await Sprite.load('ball/fire_ball.png');
    sparkle = await Sprite.load('ball/fire_sparkle.png');
  }

  generateFlameParticle() {
    Random _random = new Random();
    double? angleVariation;
    // Add the flame particle effect
    final flameParticle = Particle.generate(
      count: 10,
      lifespan: 0.05,
      generator: (i) {
        // Calculate the emission direction with randomness
        final velocity = ball.body.linearVelocity;
        final emissionDirection = -velocity;
        final angleVariation =
            (_random.nextDouble() - 0.5) * (pi / 6); // Corrected to ±15 degrees

        final rotatedDirection = emissionDirection.clone()
          ..rotate(angleVariation);

        // Add slight randomness to particle start position around the ball
        final offsetX = (_random.nextDouble() - 0.5) * 0.5; // Reduced offset
        final offsetY = (_random.nextDouble() - 0.5) * 0.5;

        return AcceleratedParticle(
          speed: rotatedDirection * 0.5,
          position: Vector2(offsetX + 1, offsetY + 1),
          child: SpriteParticle(
            sprite: sparkle,
            size: Vector2(1, 1),
          ),
        );
      },
    );
    final flameEffect = ParticleSystemComponent(
      particle: flameParticle,
      anchor: Anchor.center,
      angle: angleVariation,
      position: Vector2.zero(), // Position is relative to the parent
    );
    return flameEffect;
  }

  @override
  void update(double dt) async {
    final flameEffect = generateFlameParticle();
    //await add(flameEffect);
  }
}
