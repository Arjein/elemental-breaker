import 'package:elemental_breaker/Constants/collision_groups.dart';
import 'package:elemental_breaker/Constants/elements.dart';
import 'package:elemental_breaker/components/ball_launcher.dart';
import 'package:elemental_breaker/components/damage_source.dart';
import 'package:elemental_breaker/components/game_wall.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';

class GameBall extends BodyComponent
    with ContactCallbacks
    implements DamageSource {
  final double radius = 1.0;
  final Vector2 initialPosition;
  final BallLauncher ballLauncher;
  @override
  final Elements element;
  GameBall({
    required this.element,
    required this.ballLauncher,
    Vector2? position,
  })  : initialPosition = position ?? Vector2.zero(),
        super(
          paint: Paint()..color = elementColorMap[element],
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    // Enable debug mode if needed
    debugMode = false; // Set to true to see the body's shape
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
  void render(Canvas canvas) {
    super.render(canvas);
    // Draw the ball
    canvas.drawCircle(
      Offset.zero,
      radius,
      paint,
    );
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
  // TODO: implement damage
  int get damage => 1;
}
