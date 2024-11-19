// water_block.dart
import 'package:elemental_breaker/Constants/elements.dart';
import 'package:elemental_breaker/blocks/effects/water_effect.dart';
import 'package:elemental_breaker/grid_manager.dart';
import 'package:elemental_breaker/level_manager.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'game_block.dart';

class WaterBlock extends GameBlock {
  late List<GameBlock> columnBlocks;
  late List<GameBlock> rowBlocks;
  late List<GameBlock> selectedBlocks = [];

  WaterBlock({
    required GridManager gridManager,
    required int health,
    required Vector2 size,
    required Vector2 vectorPosition,
    required int gridXIndex,
    required int gridYIndex,
    required LevelManager levelManager,
    String? spritePath, // Optional
  }) : super(
          health: health,
          size: size,
          vectorPosition: vectorPosition,
          color: Colors.blue,
          gridManager: gridManager,
          levelManager: levelManager,
          gridXIndex: gridXIndex,
          gridYIndex: gridYIndex,
          element: Elements.water,
          spritePath: spritePath,
          elementalEffect: WaterEffect(gridManager, levelManager),
        );

  @override
  String toString() {
    return 'WaterBlock(health: $health, stack: $stack, position: $gridXIndex, $gridYIndex)';
  }

  @override
  int get damage => stack;
}
