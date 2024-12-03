// lib/ball/ball_physics.dart

import 'package:elemental_breaker/Constants/collision_groups.dart';
import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

class BallPhysics extends BodyComponent
    with ContactCallbacks, HasGameRef<Forge2DGame> {
  final double radius;

  @override
  final Vector2 position;

  BallPhysics({
    required this.radius,
    required this.position,
  });

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    // Any physics-specific initialization
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
      position: position,
      type: BodyType.dynamic,
      bullet: true,
      isAwake: false,
      userData: this,
    );

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }

  @override
  void beginContact(Object other, Contact contact) {
    // Default physics contact handling
    // This can be overridden in subclasses
  }
}
