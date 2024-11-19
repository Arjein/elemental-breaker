// fire_block.dart

import 'package:elemental_breaker/Constants/elements.dart';
import 'package:elemental_breaker/blocks/effects/fire_effect.dart';
import 'package:flutter/material.dart';
import 'game_block.dart';

class FireBlock extends GameBlock {
  late List<GameBlock> adjacentBlocks;

  FireBlock({
    required super.gridManager,
    required super.health,
    required super.size,
    required super.vectorPosition,
    required super.gridXIndex,
    required super.gridYIndex,
    required super.levelManager,
    super.spritePath, // Optional
  }) : super(
          color: Colors.red,
          element: Elements.fire,
          elementalEffect: FireEffect(gridManager, levelManager),
        );

  @override
  String toString() {
    return 'FireBlock(health: $health, stack: $stack, size: $size, position: ${body.position}, color: ${elementColorMap[element]})';
  }

  @override
  int get damage => stack;
}
