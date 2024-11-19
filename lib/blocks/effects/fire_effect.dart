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
      for (GameBlock adjacent in adjacentBlocks) {
        adjacent.highlight(elementColorMap[block.element]!);
      }
      // Wait for animation
      await Future.delayed(Duration(milliseconds: 500));
      // Damage adjacent blocks
      for (GameBlock adjacent in adjacentBlocks) {
        adjacent.isHighlighted = false;
        adjacent.receiveDamage(block);
      }
      await Future.delayed(Duration(milliseconds: 500));

      // Remove the block after effect
    }
    block.removeBlock();
  }
}
