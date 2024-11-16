import 'package:elemental_breaker/Constants/collision_groups.dart';
import 'package:elemental_breaker/components/game_ball.dart';
import 'package:elemental_breaker/grid_manager.dart';
import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';

abstract class GameBlock extends BodyComponent with ContactCallbacks {
  int health;
  final Vector2 size;
  final Vector2 vectorPosition;
  final GridManager gridManager;
  final double strokeWidth;

  bool isReadyToTrigger = false;
  bool isMoving = false;
  bool isStacking = false;
  int stack = 0;

  @override
  final Paint paint;

  // **Highlight Properties**
  bool isHighlighted = false;
  late Paint highlightPaint;

  GameBlock({
    required this.health,
    required this.size,
    required this.vectorPosition,
    required Color color,
    required this.gridManager,
    this.strokeWidth = 0.1,
  })  : paint = Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth,
        super(paint: Paint()..color = Colors.white) {
    highlightPaint = Paint()
      ..color = Colors.transparent
      ..style = PaintingStyle.fill;
  }

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

  void triggerElementalEffect();

  void removeBlock() {
    gridManager.removeBlockFromGrid(this);
  }

  @override
  void beginContact(Object other, Contact contact) {
    super.beginContact(other, contact);

    if (other is GameBall) {
      onHit(other);
    }
  }

  /// **Highlight Method with Type-Specific Color**
  void highlight(Color color) {
    if (!isHighlighted) {
      isHighlighted = true;
      highlightPaint.color = color.withOpacity(0.4);
      debugPrint(
          "Highlighting block: $this with color ${highlightPaint.color.toString()}");

      // Add a TimerComponent to remove the highlight after the specified duration
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
      isHighlighted ? highlightPaint : paint,
    );

    // Display health or stack count
    String displayText = isStacking ? '$stack' : '$health';
    if (isStacking) {
      paint.style = PaintingStyle.fill;
    }
    final textPainter = TextPainter(
      text: TextSpan(
        text: displayText,
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

  void updatePosition(int newXAxisIndex, int newYAxisIndex,
      {VoidCallback? onComplete}) {
    if (isMoving) return;

    isMoving = true;

    // Calculate the new position in the game world
    Vector2 newPosition =
        gridManager.getPositionFromGridIndices(newXAxisIndex, newYAxisIndex);

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

  @override
  void update(double dt) {
    super.update(dt);
    // Shared update logic, if any
  }
}
