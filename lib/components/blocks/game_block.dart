import 'package:elemental_breaker/Constants/collision_groups.dart';
import 'package:elemental_breaker/components/game_ball.dart';
import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:flame/effects.dart';

abstract class GameBlock extends BodyComponent with ContactCallbacks {
  int health;
  final Vector2 size;
  final Vector2 vectorPosition;
  final List<int> gridPosition;
  final Paint paint;
  final double strokeWidth;
  bool isMoving = false;
  // final SpriteAnimationComponent animationComponent; // This will handle the animation like flame etc...
  GameBlock({
    required this.health,
    required this.size,
    required this.gridPosition,
    required this.vectorPosition,
    required Color color,
    this.strokeWidth = 0.1,
  })  : paint = Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth,
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
      position: vectorPosition,
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
    // Draw the block as a rectangle with only borders
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset.zero,
        width: size.x,
        height: size.y,
      ),
      paint,
    );

    // Draw health value at the center of the block
    final textPainter = TextPainter(
      text: TextSpan(
        text: '$health',
        style: TextStyle(
          color: Colors.white,
          fontSize: 2,
          fontWeight: FontWeight.bold,
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(-textPainter.width / 2, -textPainter.height / 2),
    );
  }

  void updatePosition(Vector2 newPosition, {VoidCallback? onComplete}) {
    if (isMoving) return;

    isMoving = true;

    // Calculate the distance to move
    final Vector2 currentPosition = body.position.clone();
    final Vector2 movement = newPosition - currentPosition;

    // Calculate the required velocity
    final duration = 0.4; // Duration in seconds
    final Vector2 velocity = movement / duration;

    // Set the body to kinematic
    body.setType(BodyType.kinematic);

    // Set the linear velocity
    body.linearVelocity = velocity;

    // Schedule to stop the movement after the duration
    add(
      TimerComponent(
        period: duration,
        removeOnFinish: true,
        onTick: () {
          // Stop the block
          body.linearVelocity = Vector2.zero();
          body.setType(BodyType.static);

          isMoving = false;

          // Call the onComplete callback if provided
          if (onComplete != null) {
            onComplete();
          }
        },
      ),
    );
  }

  /// Optional: Override update if blocks have dynamic behaviors
  @override
  void update(double dt) {
    super.update(dt);
    // Shared update logic, if any
  }
}
