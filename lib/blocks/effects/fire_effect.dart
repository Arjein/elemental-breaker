import 'package:elemental_breaker/Constants/elements.dart';
import 'package:elemental_breaker/blocks/components/elemental_effect.dart';

import 'package:elemental_breaker/blocks/game_block.dart';
import 'package:elemental_breaker/grid_manager.dart';
import 'package:elemental_breaker/level_manager.dart';

class FireEffect implements ElementalEffect {
  final GridManager gridManager;
  final LevelManager levelManager;

  FireEffect(this.gridManager, this.levelManager);

  @override
  Future<void> execute(GameBlock block) async {
    if (block.isReadyToTrigger && block.stack > 0) {
      List<GameBlock> adjacentBlocks = gridManager.getAdjacentBlocks(block);
      if (adjacentBlocks.isEmpty) {
        // Kind of earns money or etc...
        block.removeBlock();
        return;
      }

      // Wait for animation
      block.renderer.executionAnimation();

      // Damage adjacent blocks
      for (GameBlock adjacent in adjacentBlocks) {
        adjacent.receiveDamage(block);
      }
      await Future.delayed(Duration(milliseconds: 500));

      // Remove the block after effect
    }
    block.removeBlock();
  }
}
