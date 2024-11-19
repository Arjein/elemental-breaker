// fire_block.dart

import 'package:elemental_breaker/Constants/elements.dart';
import 'package:flutter/material.dart';
import 'game_block.dart';

class WaterBlock extends GameBlock {
  late List<GameBlock> columnBlocks;
  late List<GameBlock> rowBlocks;
  late List<GameBlock> selectedBlocks = [];

  WaterBlock({
    required super.health,
    required super.size,
    super.color = Colors.blue,
    required super.vectorPosition,
    required super.gridManager,
    super.element = Elements.water,
    //super.spritePath = 'water_block_sprite.png',
    required super.gridXIndex,
    required super.gridYIndex,
    required super.levelManager,
  });

  @override
  String toString() {
    return 'WaterBlock(health: $health, stack: $stack, position: $gridXIndex, $gridYIndex )';
  }

  @override
  Future<void> triggerElementalEffect() async {
    if (isReadyToTrigger && stack > 0) {
      // Damage adjacent blocks based on the stack count
      debugPrint("BURDAYIZ");
      stack % 2 == 1
          ? selectedBlocks = gridManager.getBlockRow(this)
          : selectedBlocks = gridManager.getBlockColumn(this);
      debugPrint("Before Effect: $gridManager");

      for (GameBlock block in selectedBlocks) {
        if (block != this) {
          block.highlight(Colors.blue);
        }
      }

      await Future.delayed(Duration(milliseconds: 500));

      for (GameBlock block in selectedBlocks) {
        if (block != this) {
          block.isHighlighted = false;
          block.receiveDamage(this);
        }
      }
      // Remove this block
      await Future.delayed(Duration(milliseconds: 500));
    }

    removeBlock();
    debugPrint("After Effect: $gridManager");
  }

  @override
  int get damage => super.stack;
}
