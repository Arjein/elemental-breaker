// water_block.dart
import 'package:elemental_breaker/Constants/elements.dart';
import 'package:elemental_breaker/blocks/effects/water_effect.dart';
import 'package:flutter/material.dart';
import 'game_block.dart';

class WaterBlock extends GameBlock {
  late List<GameBlock> columnBlocks;
  late List<GameBlock> rowBlocks;
  late List<GameBlock> selectedBlocks = [];

  WaterBlock({
    required super.gridManager,
    required super.health,
    required super.size,
    required super.vectorPosition,
    required super.gridXIndex,
    required super.gridYIndex,
    required super.levelManager,
    super.spritePaths = const {
      "block_border_path": "water_block/border_sprite.png",
      "block_background_path": "water_block/background_sprite.png",
      "block_inside_path": "water_block/inside_sprite.png",
    },
  }) : super(
          color: Colors.blue,
          element: Elements.water,
          elementalEffect: WaterEffect(gridManager, levelManager),
        );

  @override
  String toString() {
    return 'WaterBlock(health: $health, stack: $stack, position: $gridXIndex, $gridYIndex)';
  }

  @override
  int get damage => stack;
}
