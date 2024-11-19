import 'package:elemental_breaker/Constants/elements.dart';
import 'package:flutter/material.dart';
import 'game_block.dart';

class EarthBlock extends GameBlock {
  late List<GameBlock> groundBlocks;
  EarthBlock({
    required super.health,
    required super.size,
    super.color = Colors.brown,
    super.element = Elements.earth,
    //super.spritePath = 'earth_block_sprite.png',
    required super.vectorPosition,
    required super.gridManager,
    required super.gridXIndex,
    required super.gridYIndex,
    required super.levelManager,
  });

  @override
  String toString() {
    return 'EarthBlock(health: $health, size: $size, position: $position, color: ${paint.color})';
  }

  @override
  Future<void> triggerElementalEffect() async {
    // Requires optimisation
    if (isReadyToTrigger && stack > 0) {
      groundBlocks = gridManager.getGroundBlocks();
      for (GameBlock block in groundBlocks) {
        block.highlight(elementColorMap[element]);
      }
      await Future.delayed(Duration(milliseconds: 500));
      // Damage adjacent blocks based on the stack count
      for (GameBlock block in groundBlocks) {
        if (block != this) {
          block.isHighlighted = false;
          block.receiveDamage(this);
        }
      }
      // Remove this block
      await Future.delayed(Duration(milliseconds: 500));
    }
    removeBlock();
  }

  @override
  // TODO: implement damage
  int get damage => super.stack;
}
