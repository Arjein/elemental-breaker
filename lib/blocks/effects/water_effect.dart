import 'dart:math';

import 'package:elemental_breaker/Constants/elements.dart';
import 'package:elemental_breaker/blocks/components/elemental_effect.dart';

import 'package:elemental_breaker/blocks/game_block.dart';
import 'package:elemental_breaker/grid_manager.dart';
import 'package:elemental_breaker/level_manager.dart';

class WaterEffect implements ElementalEffect {
  final GridManager gridManager;
  final LevelManager levelManager;
  late String direction;
  WaterEffect(this.gridManager, this.levelManager) {
    int randomNumber = Random().nextInt(2); // Generates either 0 or 1
    direction = randomNumber <= 0 ? "vertical" : "horizontal";
  }

  @override
  Future<void> execute(GameBlock block) async {
    if (block.isReadyToTrigger && block.stack > 0) {
      List<GameBlock> selectedBlocks = [];
      selectedBlocks = gridManager.getWaterExplosionBlocks(block, direction);
      if (selectedBlocks.isEmpty) {
        // Kind of earns money or etc...
        block.removeBlock();
        return;
      }

      block.renderer.executionAnimation();

      for (GameBlock selected in selectedBlocks) {
        if (selected != block) {
          selected.receiveDamage(block);
        }
      }

      await Future.delayed(Duration(milliseconds: 500));

      // Remove the block after effect
    }
    block.removeBlock();
  }
}
