import 'package:elemental_breaker/Constants/elements.dart';
import 'package:elemental_breaker/game_components.dart/game_ball.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:flame/effects.dart';

import 'package:elemental_breaker/level_manager.dart';

class BallLauncher extends PositionComponent with HasGameRef<Forge2DGame> {
  bool _firstBallCollected = false;
  Vector2? _launchDirection;
  int _collectedBalls = 0;
  final double _launchSpeed = 80;

  late Vector2 launchPosition;
  final LevelManager levelManager;
  final double orbObjectSize;

  BallLauncher({
    required this.levelManager,
    required Vector2 initialPosition,
    required this.orbObjectSize,
  }) : super(
          position: initialPosition,
          anchor: Anchor.topCenter,
        );

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // Define the size of the pyramid
    final double pyramidHeight = orbObjectSize * 2; // Adjust as needed
    final double pyramidWidth = orbObjectSize * 2; // Adjust as needed

    // Define the points of the pyramid
    final Vector2 topPoint =
        Vector2(0, -pyramidHeight / 2); // Top point (launch position)
    final Vector2 bottomLeftPoint =
        Vector2(-pyramidWidth / 2, pyramidHeight / 2); // Bottom left point
    final Vector2 bottomRightPoint =
        Vector2(pyramidWidth / 2, pyramidHeight / 2); // Bottom right point
    final Vector2 backPoint = Vector2(
        0,
        pyramidHeight / 2 +
            (pyramidHeight / 4)); // Back point to create 3D effect

    // Draw the front face of the pyramid
    final Path frontFacePath = Path()
      ..moveTo(topPoint.x, topPoint.y)
      ..lineTo(bottomLeftPoint.x, bottomLeftPoint.y)
      ..lineTo(bottomRightPoint.x, bottomRightPoint.y)
      ..close();

    final Paint frontFacePaint = Paint()..color = Colors.transparent;

    canvas.drawPath(frontFacePath, frontFacePaint);

    // Draw the left side face of the pyramid
    final Path leftFacePath = Path()
      ..moveTo(topPoint.x, topPoint.y)
      ..lineTo(bottomLeftPoint.x, bottomLeftPoint.y)
      ..lineTo(backPoint.x, backPoint.y)
      ..close();

    final Paint leftFacePaint = Paint()
      ..color = Colors.transparent
      ..style = PaintingStyle.fill;

    canvas.drawPath(leftFacePath, leftFacePaint);

    // Draw the right side face of the pyramid
    final Path rightFacePath = Path()
      ..moveTo(topPoint.x, topPoint.y)
      ..lineTo(bottomRightPoint.x, bottomRightPoint.y)
      ..lineTo(backPoint.x, backPoint.y)
      ..close();

    final Paint rightFacePaint = Paint()
      ..color = Colors.transparent
      ..style = PaintingStyle.fill;

    canvas.drawPath(rightFacePath, rightFacePaint);

    // Optionally, draw edges
    final Paint edgePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.05;

    canvas.drawPath(frontFacePath, edgePaint);
    canvas.drawPath(leftFacePath, edgePaint);
    canvas.drawPath(rightFacePath, edgePaint);

    // Define the element colors

    // List of corner points
    final List<Vector2> cornerPoints = [
      topPoint,
      bottomLeftPoint,
      bottomRightPoint,
      backPoint,
    ];

    // Draw element balls at each corner

    for (int i = 0; i < cornerPoints.length; i++) {
      final Vector2 corner = cornerPoints[i];
      Paint ballPaint = Paint();

      ballPaint = Paint()
        ..color = elementColorMap[levelManager.currentBallElement];

      canvas.drawCircle(
        Offset(corner.x, corner.y),
        orbObjectSize / 4, // Adjust size as needed
        ballPaint,
      );
    }

    // Update the launch position to the top point of the pyramid
    launchPosition = absolutePosition + topPoint;
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
        element: levelManager.currentBallElement,
        position: launchPosition.clone(),
        ballLauncher: this,
      );

      ballList.add(ball);
    }
    await gameRef.world.addAll(ballList);

    for (GameBall ball in ballList) {
      await Future.delayed(
          Duration(milliseconds: 100)); // Delay between launches
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
    _firstBallCollected = false;
    _launchDirection = null;
    _collectedBalls = 0;
  }

  void restart() {
    position = game.camera.visibleWorldRect.bottomCenter.toVector2();
    _firstBallCollected = false;
    _launchDirection = null;
    _collectedBalls = 0;
  }

  void onBallHitBottom(GameBall ball) async{
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

    if (levelManager.currentLevelNotifier.value == _collectedBalls) {
      debugPrint("All Balls Returned");
      // Notify the LevelManager
      await levelManager.onAllBallsReturned();
      levelManager.isLaunching = false;
    }
  }

  Vector2 get ballLaunchPosition => launchPosition;
}
