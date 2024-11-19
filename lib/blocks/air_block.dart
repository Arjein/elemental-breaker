// air_block.dart
import 'package:elemental_breaker/Constants/elements.dart';
import 'package:elemental_breaker/blocks/effects/air_effect.dart';
import 'package:elemental_breaker/grid_manager.dart';
import 'package:elemental_breaker/level_manager.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'game_block.dart';

class AirBlock extends GameBlock {
  late List<GameBlock> randomBlocks;
  final int baseHealth;

  AirBlock({
    required GridManager gridManager,
    required int health,
    required Vector2 size,
    required Vector2 vectorPosition,
    required int gridXIndex,
    required int gridYIndex,
    required LevelManager levelManager,
    required Forge2DGame gameRef, // Reference to the game for effects
    String? spritePath, // Optional
  })  : baseHealth = health,
        super(
          health: health,
          size: size,
          vectorPosition: vectorPosition,
          color: Colors.grey,
          gridManager: gridManager,
          levelManager: levelManager,
          gridXIndex: gridXIndex,
          gridYIndex: gridYIndex,
          element: Elements.air,
          spritePath: spritePath,
          elementalEffect:
              AirEffect.create(gridManager, levelManager, gameRef, health),
        );

  @override
  String toString() {
    return 'AirBlock(health: $health, stack: $stack, size: $size, position: ${body.position}, color: ${elementColorMap[element]})';
  }

  @override
  int get damage => stack;
}
