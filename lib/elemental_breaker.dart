import 'package:elemental_breaker/Constants/user_device.dart';
import 'package:elemental_breaker/components/game_wall.dart';
import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'level_manager.dart';

class ElementalBreaker extends Forge2DGame {
  // Initialize LevelManager
  LevelManager levelManager = LevelManager();

  ElementalBreaker()
      : super(gravity: Vector2(0, 0), camera: CameraComponent()) {
    debugMode = false;
    debugColor = Colors.white;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    camera.viewport.add(FpsTextComponent());

    await world.add(levelManager);

    // Add boundaries
    await world.addAll(createBoundaries());
  }

  List<Component> createBoundaries() {
    final visibleRect = camera.visibleWorldRect;
    final topLeft = visibleRect.topLeft.toVector2();
    final topRight = visibleRect.topRight.toVector2();
    final bottomRight = visibleRect.bottomRight.toVector2();
    final bottomLeft = visibleRect.bottomLeft.toVector2();
    debugPrint("TopLeft, TopRight: $topLeft |$topRight");
    return [
      Wall(topLeft, topRight), // Top wall
      Wall(topRight, bottomRight), // Right wall
      Wall(bottomLeft, bottomRight, isBottomWall: true), // Bottom wall
      Wall(topLeft, bottomLeft), // Left wall
    ];
  }

  ValueNotifier<int> get currentLevelNotifier =>
      levelManager.currentLevelNotifier;
}
