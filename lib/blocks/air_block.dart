// air_block.dart
import 'package:elemental_breaker/Constants/elements.dart';
import 'package:elemental_breaker/blocks/effects/air_effect.dart';

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'game_block.dart';

class AirBlock extends GameBlock {
  late List<GameBlock> randomBlocks;
  final int baseHealth;

  AirBlock({
    required super.gridManager,
    required super.health,
    required super.size,
    required super.vectorPosition,
    required super.gridXIndex,
    required super.gridYIndex,
    required super.levelManager,
    required Forge2DGame gameRef, // Reference to the game for effects
    super.spritePath, // Optional
  })  : baseHealth = health,
        super(
          color: Colors.grey,
          element: Elements.air,
          elementalEffect: AirEffect.create(gridManager, levelManager, gameRef),
        );

  @override
  String toString() {
    return 'AirBlock(health: $health, stack: $stack, size: $size, position: ${body.position}, color: ${elementColorMap[element]})';
  }

  @override
  int get damage => stack;
}
