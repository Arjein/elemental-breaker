import 'dart:math';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_forge2d/forge2d_game.dart';
import 'aiming_line.dart';
import '../level_manager.dart';

class DragHandler extends PositionComponent
    with GestureHitboxes, HasGameRef<Forge2DGame>, DragCallbacks {
  AimingLine? _aimingLine;
  final LevelManager levelManager;
  // Instance variables to store positions
  Vector2? _dragStart;
  Vector2? _dragCurrent;

  DragHandler({required this.levelManager});

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Set the size to cover the entire game world
    // Get the size of the game world
    final worldSize = gameRef.size;

    // Set the size to cover the entire game world
    size = worldSize;

    // Set the position to the top-left corner of the game world
    position = Vector2(-worldSize.x / 2, -worldSize.y / 2);

    // Enable the hitbox
    add(RectangleHitbox());
  }

  @override
  void onDragStart(DragStartEvent event) {
    if (!levelManager.isLaunching) {
      super.onDragStart(event);
      final camera = gameRef.camera;
      // Store the drag start position in world coordinates
      _dragStart = camera.localToGlobal(event.canvasPosition);
      // debugPrint("Drag started");
    }
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    if (_dragStart != null) {
      final camera = gameRef.camera;
      //debugPrint("Drag Updated");
      // Update the current drag position in world coordinates
      _dragCurrent = camera.localToGlobal(event.canvasStartPosition);

      // Calculate the drag vector (from drag start to current position)
      Vector2 dragVector = _dragCurrent! - _dragStart!;

      // The launch vector is the opposite of the drag vector
      Vector2 launchVector = -dragVector;

      // Compute the angle between the launch vector and the X-axis
      double angleRadians = atan2(launchVector.y, launchVector.x);
      double angleDegrees = angleRadians * 180 / pi;

      // Normalize angleDegrees to [0, 360)
      if (angleDegrees < 0) {
        angleDegrees += 360;
      }

      // Determine if the drag should be canceled
      if (angleDegrees < 180 || angleDegrees >= 360) {
        // Remove the aiming line and return
        _aimingLine?.removeFromParent();
        _aimingLine = null;
        return;
      }

      // Clamp the angle between 205 and 345 degrees
      if (angleDegrees < 195) {
        angleDegrees = 195;
      } else if (angleDegrees > 345) {
        angleDegrees = 345;
      }

      // Create a unit vector in the direction of the adjusted angle
      angleRadians = angleDegrees * pi / 180;
      Vector2 launchDirection = Vector2(cos(angleRadians), sin(angleRadians));

      // Update or create the aiming line
      _aimingLine ??= AimingLine();
      if (!gameRef.world.children.contains(_aimingLine)) {
        gameRef.add(_aimingLine!);
      }

      // Get the BallLauncher from LevelManager
      final levelManager = gameRef.world.firstChild<LevelManager>();
      final ballLauncher = levelManager?.ballLauncher;

      // Set the end point of the aiming line for visualization
      if (ballLauncher != null) {
        double lineLength = 100; // Adjust as needed
        _aimingLine!.updateLine(
          startPoint: ballLauncher.launchPosition,
          endPoint: ballLauncher.launchPosition + launchDirection * lineLength,
        );
      }
    }
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    if (_dragStart != null && _dragCurrent != null) {
      Vector2 dragVector = _dragCurrent! - _dragStart!;
      Vector2 launchVector = -dragVector;

      // Compute the angle in degrees
      double angleRadians = atan2(launchVector.y, launchVector.x);
      double angleDegrees = angleRadians * 180 / pi;

      // Normalize angleDegrees to [0, 360)
      if (angleDegrees < 0) {
        angleDegrees += 360;
      }
      //debugPrint("Drag ended | Launch vector: $launchVector");
      // Check if the drag should be canceled
      if (angleDegrees < 180 || angleDegrees >= 360) {
        // Cancel the drag
        _dragStart = null;
        _dragCurrent = null;
        _aimingLine?.removeFromParent();
        _aimingLine = null;
        return;
      }

      // Clamp the angle between 205 and 345 degrees
      if (angleDegrees < 195) {
        angleDegrees = 195;
      } else if (angleDegrees > 345) {
        angleDegrees = 345;
      }

      // Create a unit vector in the direction of the adjusted angle
      angleRadians = angleDegrees * pi / 180;
      Vector2 launchDirection = Vector2(cos(angleRadians), sin(angleRadians));

      // Communicate the launch parameters to the LevelManager
      //debugPrint("LevelManager: $levelManager");
      levelManager.onLaunchDirectionSet(launchDirection);
      // debugPrint("Drag end doptu mu");
      // Remove the aiming line
      _aimingLine?.removeFromParent();
      _aimingLine = null;

      // Reset drag positions
      _dragStart = null;
      _dragCurrent = null;
    }
  }

  @override
  void onDragCancel(DragCancelEvent event) {
    super.onDragCancel(event);
    // Handle drag cancellation
    _dragStart = null;
    _dragCurrent = null;
    _aimingLine?.removeFromParent();
    _aimingLine = null;
  }
}
