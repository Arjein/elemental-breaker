// lib/game_components/game_ball.dart

import 'package:elemental_breaker/Constants/collision_groups.dart';
import 'package:elemental_breaker/Constants/elements.dart';
import 'package:elemental_breaker/ball/ball_animation.dart';
import 'package:elemental_breaker/ball/ball_animation_factory.dart';
import 'package:elemental_breaker/game_components.dart/ball_launcher.dart';
import 'package:elemental_breaker/game_components.dart/damage_source.dart';
import 'package:elemental_breaker/game_components.dart/game_wall.dart';
import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';

class GameBall extends BodyComponent
    with ContactCallbacks, HasGameRef<Forge2DGame>
    implements DamageSource {
  final double radius = 1.0;
  final Vector2 initialPosition;
  final BallLauncher ballLauncher;
  @override
  final Elements element;
  late Color color;
  // Animation related
  //late BallAnimation _animation;
  //final BallAnimationFactory _animationFactory = BallAnimationFactory();

  GameBall({
    required this.element,
    required this.ballLauncher,
    Vector2? position,
  })  : initialPosition = position ?? Vector2.zero(),
        super(
          paint: Paint()..color = elementColorMap[element],
        ) {
    color = elementColorMap[element];
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    // Enable debug mode if needed
    debugMode = false; // Set to true to see the body's shape

    //// Initialize the animation based on the element
    //_animation = _animationFactory.createAnimation(element);
    //await _animation.initialize(gameRef, initialPosition);
  }

  @override
  Body createBody() {
    final shape = CircleShape()..radius = radius;
    final fixtureDef = FixtureDef(shape)
      ..restitution = 1.0
      ..friction = 0.0
      ..density = 1.0
      ..userData = this
      ..filter.groupIndex = GROUP_GAMEBALL;

    final bodyDef = BodyDef(
      position: initialPosition,
      type: BodyType.dynamic,
      bullet: true,
      isAwake: false,
      userData: this,
    );
    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }

  @override
  void update(double dt) {
    super.update(dt);
    // Update animation with the current position
    //_animation.update(dt, body.position);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    // Draw the red circle representing the fireball
    canvas.drawCircle(
      Offset.zero,
      radius,
      Paint()..color = color,
    );

    // Delegating rendering of particles to the animation component
    //_animation.render(canvas);
  }

  @override
  void beginContact(Object other, Contact contact) {
    if (other is GameBall) {
      // Ignore collisions with other GameBalls
      return;
    }
    if (other is Wall && other.isBottomWall) {
      // Notify the BallLauncher that this ball has hit the bottom wall
      ballLauncher.onBallHitBottom(this);
    }
  }

  @override
  int get damage => 1;

  @override
  Future<void> onRemove() async {
    super.onRemove();
    //_animation.dispose();
  }
}
