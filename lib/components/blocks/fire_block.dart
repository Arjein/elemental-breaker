// fire_block.dart
import 'package:elemental_breaker/Constants/elements.dart';

import 'package:flutter/material.dart';
import 'game_block.dart';

class FireBlock extends GameBlock {
  late List<GameBlock> adjacentBlocks;
  FireBlock({
    required super.gridManager,
    required super.health,
    required super.size,
    required super.vectorPosition,
    super.color = Colors.red,
    super.element = Elements.fire,
    //super.spritePath = 'fire_block_sprite.png',
    required super.gridXIndex,
    required super.gridYIndex,
    required super.levelManager, // Provide the sprite path
  });

  @override
  Future<void> triggerElementalEffect() async {
    debugPrint("isReadyToTrigger: $isReadyToTrigger");

    if (isReadyToTrigger && stack > 0) {
      adjacentBlocks = gridManager.getAdjacentBlocks(this);
      for (GameBlock block in adjacentBlocks) {
        block.highlight(elementColorMap[element]);
      }
      // Where animation takes places
      await Future.delayed(Duration(milliseconds: 500));
      // Damage adjacent blocks based on the stack count
      for (GameBlock block in adjacentBlocks) {
        block.isHighlighted = false;
        block.receiveDamage(this);
      }
      await Future.delayed(Duration(milliseconds: 500));

      // Remove this block
    }
    removeBlock();
  }

  @override
  String toString() {
    return 'FireBlock(health: $health, stack: $stack, size: $size, position: ${body.position}, color: ${paint.color})';
  }

  @override
  // TODO: implement damage
  int get damage => super.stack;
}
