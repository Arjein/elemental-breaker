// block_factory.dart

import 'package:elemental_breaker/Constants/elements.dart';
import 'package:elemental_breaker/components/blocks/air_block.dart';
import 'package:elemental_breaker/components/blocks/earth_block.dart';
import 'package:elemental_breaker/components/blocks/fire_block.dart';
import 'package:elemental_breaker/components/blocks/game_block.dart';
import 'package:elemental_breaker/components/blocks/water_block.dart';
import 'package:flutter/material.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

class BlockFactory {
  final Forge2DGame game;

  BlockFactory({required this.game});

  /// Creates a [GameBlock] based on the provided [BlockType].
  Future<GameBlock> createBlock({
    required Elements type,
    required int health,
    required Vector2 size,
    required Vector2 position,
  }) async {
    GameBlock block;

    switch (type) {
      case Elements.fire:
        block = FireBlock(
          health: health,
          size: size,
          initialPosition: position,
        );
        break;
      case Elements.water:
        block = WaterBlock(
          health: health,
          size: size,
          initialPosition: position,
        );
        break;
      case Elements.earth:
        block = EarthBlock(
          health: health,
          size: size,
          initialPosition: position,
        );
        break;
      case Elements.air:
        block = AirBlock(
          health: health,
          size: size,
          initialPosition: position,
        );
        break;
      default:
        throw ArgumentError('Unsupported BlockType: $type');
    }

    // Add the block to the game world
    await game.world.add(block);

    return block;
  }
}
