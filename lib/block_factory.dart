// block_factory.dart

import 'package:elemental_breaker/Constants/elements.dart';
import 'package:elemental_breaker/Constants/user_device.dart';
import 'package:elemental_breaker/blocks/air_block.dart';
import 'package:elemental_breaker/blocks/earth_block.dart';
import 'package:elemental_breaker/blocks/fire_block.dart';
import 'package:elemental_breaker/blocks/game_block.dart';
import 'package:elemental_breaker/blocks/water_block.dart';
import 'package:elemental_breaker/grid_manager.dart';
import 'package:elemental_breaker/level_manager.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

class BlockFactory {
  final Forge2DGame game;
  final GridManager gridManager;
  final LevelManager levelManager;

  BlockFactory({
    required this.game,
    required this.gridManager,
    required this.levelManager,
  });

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
          levelManager: levelManager,
          gridXIndex: xAxisIndex,
          gridYIndex: yAxisIndex,
        );
        break;
      case Elements.water:
        block = WaterBlock(
          health: health,
          size: size,
          vectorPosition: vectorPosition,
          gridManager: gridManager,
          levelManager: levelManager,
          gridXIndex: xAxisIndex,
          gridYIndex: yAxisIndex,
        );
        break;
      case Elements.earth:
        block = EarthBlock(
          health: health,
          size: size,
          vectorPosition: vectorPosition,
          gridManager: gridManager,
          levelManager: levelManager,
          gridXIndex: xAxisIndex,
          gridYIndex: yAxisIndex,
        );
        break;
      case Elements.air:
        block = AirBlock(
          health: health,
          size: size,
          vectorPosition: vectorPosition,
          gridManager: gridManager,
          levelManager: levelManager,
          gridXIndex: xAxisIndex,
          gridYIndex: yAxisIndex,
          gameRef: game,
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
