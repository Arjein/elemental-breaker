// earth_block.dart
import 'package:elemental_breaker/Constants/elements.dart';
import 'package:elemental_breaker/blocks/effects/earth_effect.dart';
import 'package:flutter/material.dart';
import 'game_block.dart';

class EarthBlock extends GameBlock {
  late List<GameBlock> groundBlocks;

  EarthBlock({
    required super.gridManager,
    required super.health,
    required super.size,
    required super.vectorPosition,
    required super.gridXIndex,
    required super.gridYIndex,
    required super.levelManager,
    super.spritePaths,
  }) : super(
          color: Colors.brown,
          element: Elements.earth,
          elementalEffect: EarthEffect(gridManager, levelManager),
        );

  @override
  String toString() {
    return 'EarthBlock(health: $health, stack: $stack, size: $size, position: ${body.position}, color:  color: ${elementColorMap[element]})';
  }

  @override
  int get damage => stack;
}
