import 'package:elemental_breaker/Constants/elements.dart';
import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:flame/effects.dart';
import 'package:elemental_breaker/components/game_ball.dart';
import 'package:elemental_breaker/level_manager.dart';
import 'dart:math' as math;

class BallLauncher extends PositionComponent with HasGameRef<Forge2DGame> {
  bool _firstBallCollected = false;
  Vector2? _launchDirection;
  int _collectedBalls = 0;
  final double _launchSpeed = 100;
  final Paint paint;
  final LevelManager levelManager;

  BallLauncher({
    required this.levelManager,
    required Vector2 initialPosition,
  })  : paint = Paint()..color = Colors.blue.shade500,
        super(
          position: initialPosition,
          size: Vector2.all(0.0), // Adjust size as needed
          anchor: Anchor.center,
        );

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.save();

    // Rotate the launcher so that corners face upwards
    canvas.rotate(math.pi / 4);

    // Draw the square launcher
    final squareSize = 5.0; // Adjust size as needed
    final squareRect = Rect.fromCenter(
      center: Offset.zero,
      width: squareSize,
      height: squareSize,
    );
    canvas.drawRect(squareRect, paint);

    // Positions for the balls at each corner
    final halfSize = squareSize / 2;
    final cornerOffsets = [
      Offset(-halfSize, -halfSize),
      Offset(halfSize, -halfSize),
      Offset(halfSize, halfSize),
      Offset(-halfSize, halfSize),
    ];

    // Colors for each elemental power
    final elementColors = [
      Colors.red, // Fire
      Colors.blue, // Water
      Colors.green, // Earth
      Colors.yellow, // Air
    ];

    // Draw balls at each corner
    for (int i = 0; i < 4; i++) {
      final cornerPaint = Paint()..color = elementColors[i];
      canvas.drawCircle(cornerOffsets[i], 1.5, cornerPaint);
    }

    canvas.restore();
  }

  void startLaunching(int ballCount) {
    if (_launchDirection == null) {
      debugPrint("Launch Boku yedi");
      return;
    }
    debugPrint("Launch Started");
    _firstBallCollected = false;

    _launchBalls(ballCount);
  }
/*

  void _launchBalls(int ballCount) async {
    for (int i = 0; i < ballCount; i++) {
      await Future.delayed(
          Duration(milliseconds: 80)); // Delay between launches
      _launchBall();
    }
  }

  void _launchBall() async {
    final ball = GameBall(
      position: position.clone(),
      ballLauncher: this,
    );
    await gameRef.world.add(ball);

    // Set the ball's velocity based on the stored launch direction and speed
    ball.body.linearVelocity = _launchDirection! * _launchSpeed;
  }
*/

  void _launchBalls(int ballCount) async {
    // _prepareLaunch
    List<GameBall> ballList = [];
    for (int i = 0; i < ballCount; i++) {
      GameBall ball = GameBall(
        element: Elements.fire,
        position: position.clone() + Vector2(0, -3.5),
        ballLauncher: this,
      );

      ballList.add(ball);
    }
    await gameRef.world.addAll(ballList);

    for (GameBall ball in ballList) {
      await Future.delayed(
          Duration(milliseconds: 80)); // Delay between launches
      ball.body.linearVelocity = _launchDirection! * _launchSpeed;
    }
  }

  void setLaunchParameters(Vector2 direction) {
    _launchDirection = direction;
  }

  void updateLaunchPosition(Vector2 newPosition) {
    // Keep the Y coordinate constant

    final duration = 0.4; // Duration in seconds
    add(MoveEffect.to(
      newPosition,
      EffectController(
        duration: duration,
        curve: Curves
            .easeInOut, // Import 'package:flutter/animation.dart' for Curves
      ),
    ));
  }

  void reset() {
    // RESETLICEZ
    _firstBallCollected = false;
    _launchDirection = null;
    _collectedBalls = 0;
    // Optionally reset the launch position if needed
    // _launchPosition = Vector2(0, 30);
  }

  void onBallHitBottom(GameBall ball) {
    if (!_firstBallCollected) {
      _firstBallCollected = true;

      // Update the launch position, changing only the X-coordinate
      Vector2 newLaunchPosition = Vector2(ball.body.position.x, position.y);
      updateLaunchPosition(newLaunchPosition);
    }
    _collectedBalls++;
    // Remove the ball
    ball.removeFromParent();

    // Check if all balls have returned

    if (levelManager.currentLevel == _collectedBalls) {
      levelManager.isLaunching = false;
      debugPrint("All Balls Returned");
      // Notify the LevelManager
      levelManager.onAllBallsReturned();
    }
  }

  Vector2 get launchPosition => position;
}
