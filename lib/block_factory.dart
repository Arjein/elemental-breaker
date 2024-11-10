// block_factory.dart

import 'package:elemental_breaker/Constants/elements.dart';
import 'package:elemental_breaker/Constants/user_device.dart';
import 'package:elemental_breaker/components/blocks/air_block.dart';
import 'package:elemental_breaker/components/blocks/earth_block.dart';
import 'package:elemental_breaker/components/blocks/fire_block.dart';
import 'package:elemental_breaker/components/blocks/game_block.dart';
import 'package:elemental_breaker/components/blocks/water_block.dart';
import 'package:flutter/material.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

class BlockFactory {
  final Forge2DGame game;


  BlockFactory({required this.game}) {
  }

// Flame'de ben pozisoyn olarak koymak istiyorum ama flame bunu kendi game world sizeına göre yapiyo

  Future<GameBlock> createBlock({
    required Elements type,
    required int health,
    required int xAxisIndex,
    required int yAxisIndex,
  }) async {
    final Vector2 size = Vector2.all(GameConstants.blockEdgeLength! / 10);
    Vector2 vectorPosition =
        Vector2(GameConstants.positionValsX[xAxisIndex], GameConstants.positionValsY[yAxisIndex]);
    debugPrint("Block Size: $size");
    GameBlock block;
    debugPrint("Health:  $health");
    switch (type) {
      case Elements.fire:
        debugPrint("ONCESI");
        block = FireBlock(
            health: health,
            size: size,
            gridPosition: [xAxisIndex, 0],
            vectorPosition: vectorPosition);

        break;
      case Elements.water:
        block = WaterBlock(
            health: health,
            size: size,
            gridPosition: [xAxisIndex, 0],
            vectorPosition: vectorPosition);
        break;
      case Elements.earth:
        block = EarthBlock(
            health: health,
            size: size,
            gridPosition: [xAxisIndex, 0],
            vectorPosition: vectorPosition);
        break;
      case Elements.air:
        block = AirBlock(
            health: health,
            size: size,
            gridPosition: [xAxisIndex, 0],
            vectorPosition: vectorPosition);
        break;
      default:
        throw ArgumentError('Unsupported BlockType: $type');
    }

    // Add the block to the game world
    await game.world.add(block);

    return block;
  }
}
