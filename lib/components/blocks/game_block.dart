import 'package:elemental_breaker/Constants/collision_groups.dart';
import 'package:elemental_breaker/components/game_ball.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';

abstract class GameBlock extends BodyComponent with ContactCallbacks {
  int health;
  final Vector2 size;
  final Vector2 initialPosition;
  final Paint paint;

  GameBlock({
    required this.health,
    required this.size,
    required this.initialPosition,
    required Color color,
  })  : paint = Paint()..color = color,
        super(paint: Paint()..color = Colors.white);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    // Enable debug mode if needed
    debugMode = false; // Set to true to see the body's shape
  }

  @override
  Body createBody() {
    final shape = PolygonShape();
    shape.set([
      Vector2(-size.x / 2, -size.y / 2),
      Vector2(size.x / 2, -size.y / 2),
      Vector2(size.x / 2, size.y / 2),
      Vector2(-size.x / 2, size.y / 2),
    ]);
    final fixtureDef = FixtureDef(shape)
      ..restitution = 1.0
      ..friction = 0.0
      ..density = 1.0
      ..filter.groupIndex = GROUP_BLOCK // Assign to block group
      ..userData = this;

    final bodyDef = BodyDef(
      position: this.initialPosition,
      type: BodyType.static,
      userData: this,
    );
    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }

  void onHit(GameBall ball);

  @override
  void beginContact(Object other, Contact contact) {
    super.beginContact(other, contact);

    if (other is GameBall) {
      onHit(other);
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    // Draw the block as a rectangle centered on its position
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset.zero,
        width: size.x,
        height: size.y,
      ),
      paint,
    );
  }

  /// Optional: Override update if blocks have dynamic behaviors
  @override
  void update(double dt) {
    super.update(dt);
    // Shared update logic, if any
  }
}
