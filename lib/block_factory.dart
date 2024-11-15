// block_factory.dart

import 'package:elemental_breaker/Constants/elements.dart';
import 'package:elemental_breaker/Constants/user_device.dart';
import 'package:elemental_breaker/components/blocks/air_block.dart';
import 'package:elemental_breaker/components/blocks/earth_block.dart';
import 'package:elemental_breaker/components/blocks/fire_block.dart';
import 'package:elemental_breaker/components/blocks/game_block.dart';
import 'package:elemental_breaker/components/blocks/water_block.dart';
import 'package:elemental_breaker/grid_manager.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

class BlockFactory {
  final Forge2DGame game;
  final GridManager gridManager;

  BlockFactory({required this.game, required this.gridManager});

  Future<GameBlock> createBlock({
    required Elements type,
    required int health,
    required int xAxisIndex,
    required int yAxisIndex,
  }) async {
    final Vector2 size = Vector2.all(GameConstants.blockEdgeLength! / 10);
    Vector2 vectorPosition =
        gridManager.getPositionFromGridIndices(xAxisIndex, yAxisIndex);
    GameBlock block;

    switch (type) {
      case Elements.fire:
        block = FireBlock(
          health: health,
          size: size,
          vectorPosition: vectorPosition,
          gridManager: gridManager,
        );
        break;
      case Elements.water:
        block = WaterBlock(
          health: health,
          size: size,
          vectorPosition: vectorPosition,
          gridManager: gridManager,
        );
        break;
      case Elements.earth:
        block = EarthBlock(
          health: health,
          size: size,
          vectorPosition: vectorPosition,
          gridManager: gridManager,
        );
        break;
      case Elements.air:
        block = AirBlock(
          health: health,
          size: size,
          vectorPosition: vectorPosition,
          gridManager: gridManager,
        );
        break;
      default:
        throw ArgumentError('Unsupported BlockType: $type');
    }

    // Add the block to the game world
    await game.world.add(block);

    // Add the block to the grid
    gridManager.addBlock(block, xAxisIndex, yAxisIndex);

    return block;
  }
}
