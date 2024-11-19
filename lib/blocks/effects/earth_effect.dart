// earth_effect.dart
import 'dart:async';

import 'package:elemental_breaker/Constants/elements.dart';
import 'package:elemental_breaker/blocks/components/elemental_effect.dart';

import 'package:elemental_breaker/blocks/game_block.dart';
import 'package:elemental_breaker/grid_manager.dart';
import 'package:elemental_breaker/level_manager.dart';

class EarthEffect implements ElementalEffect {
  final GridManager gridManager;
  final LevelManager levelManager;

  EarthEffect(this.gridManager, this.levelManager);

  @override
  Future<void> execute(GameBlock block) async {
    if (block.isReadyToTrigger && block.stack > 0) {
      List<GameBlock> groundBlocks = gridManager.getGroundBlocks();
      for (GameBlock ground in groundBlocks) {
        ground.highlight(elementColorMap[block.element]!);
      }
      await Future.delayed(Duration(milliseconds: 500));
      // Damage ground blocks
      for (GameBlock ground in groundBlocks) {
        if (ground != block) {
          ground.isHighlighted = false;
          ground.receiveDamage(block);
        }
      }
      await Future.delayed(Duration(milliseconds: 500));
    }
    block.removeBlock();
  }
}
