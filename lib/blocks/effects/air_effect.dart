// air_effect.dart
import 'dart:async';
import 'dart:math';
import 'package:elemental_breaker/Constants/elements.dart';
import 'package:elemental_breaker/animations.dart/lightning_effect.dart';

import 'package:elemental_breaker/blocks/components/elemental_effect.dart';
import 'package:elemental_breaker/blocks/game_block.dart';
import 'package:elemental_breaker/grid_manager.dart';
import 'package:elemental_breaker/level_manager.dart';
import 'package:flutter/material.dart';
import 'package:flame_forge2d/flame_forge2d.dart'; // Correct public import

class AirEffect implements ElementalEffect {
  final GridManager gridManager;
  final LevelManager levelManager;
  final Forge2DGame gameRef;

  // Private constructor to prevent unnamed instantiation
  AirEffect._internal(this.gridManager, this.levelManager, this.gameRef);

  // Named factory constructor to create instances
  factory AirEffect.create(
    GridManager gridManager,
    LevelManager levelManager,
    Forge2DGame gameRef,
  ) {
    return AirEffect._internal(gridManager, levelManager, gameRef);
  }

  List<GameBlock> randomBlocks = [];

  @override
  Future<void> execute(GameBlock block) async {
    if (block.isReadyToTrigger && block.stack > 0) {
      _getRandomBlocks(block);

      // Highlight selected blocks
      for (GameBlock selected in randomBlocks) {
        selected.highlight(elementColorMap[block.element]!);
      }
      if (randomBlocks.length == 1 && randomBlocks[0] == block) {
        // Kind of earns money or etc...
        block.removeBlock();
        return;
      }
      // Apply lightning effects
      List<Future<void>> effectFutures = [];
      for (GameBlock selected in randomBlocks) {
        if (selected != block) {
          effectFutures.add(_addLightningEffectToBlock(selected, block));
        }
      }

      // Wait for all effects to complete
      await Future.wait(effectFutures);

      // Remove the block after effect
    }
    block.removeBlock();
  }

  void _getRandomBlocks(GameBlock block) {
    // Remove previous highlights
    for (GameBlock b in randomBlocks) {
      b.isHighlighted = false;
    }

    // Generate probability distribution
    List<Map<String, dynamic>> probabilityDistribution =
        _generateProbabilityDistribution(block.stack, levelManager.currentLevelNotifier.value);

    // Select a random x based on distribution
    int x = _getRandomX(probabilityDistribution);

    // Get random blocks based on x
    randomBlocks = gridManager.getRandomBlocks(x, block);
  }

  Future<void> _addLightningEffectToBlock(
      GameBlock targetBlock, GameBlock sourceBlock) async {
    Completer<void> completer = Completer<void>();

    // Get the target block's center position in world coordinates
    Vector2 endWorldPosition = targetBlock.body.position.clone();

    // Determine the start position above the target block in world coordinates
    Vector2 startWorldPosition =
        endWorldPosition + Vector2(0, -20); // Adjust as needed

    // Convert world positions to screen positions
    Vector2 startScreenPosition =
        gameRef.camera.localToGlobal(startWorldPosition);
    Vector2 endScreenPosition = gameRef.camera.localToGlobal(endWorldPosition);

    // Wait before showing the lightning
    await Future.delayed(Duration(milliseconds: 500));
    debugPrint(
        'StartPosition: $startScreenPosition | EndPosition: $endScreenPosition');

    // Create the lightning effect with a callback
    LightningEffect lightning = LightningEffect(
      start: startScreenPosition,
      end: endScreenPosition,
      onComplete: () {
        // After lightning effect completes
        targetBlock.isHighlighted = false;
        targetBlock.receiveDamage(sourceBlock);
        targetBlock.updateHealthDisplay();
        completer.complete();
      },
    );

    // Add the effect to the game
    gameRef.add(lightning);

    // Return the Future
    return completer.future;
  }

  List<Map<String, dynamic>> _generateProbabilityDistribution(
      int stack, int currentLevel) {
    int minBlocks = 2;
    int maxBlocks = 3;

    // Base and Max probabilities
    Map<int, double> baseProbabilities = {
      1: 65.0,
      2: 30.0,
      3: 5.0,
    };

    Map<int, double> maxProbabilities = {
      1: 5.0,
      2: 20.0,
      3: 75.0,
    };

    // Calculate t value
    double t = 0.0;
    if (currentLevel > 1) {
      t = (stack - 1) / (currentLevel - 1);
    } else {
      // When baseHealth is 1, base t solely on stack
      t = (stack - 1).toDouble();
    }
    t = t.clamp(0.0, 1.0);

    // Calculate probabilities
    List<Map<String, dynamic>> distribution = [];
    double cumulativeProbability = 0.0;

    for (int n = minBlocks; n <= maxBlocks; n++) {
      double baseP = baseProbabilities[n]!;
      double maxP = maxProbabilities[n]!;

      // Interpolate probability
      double probability = baseP + t * (maxP - baseP);

      cumulativeProbability += probability / 100.0; // Normalize to [0,1]

      distribution.add({
        'x': n,
        'probability': probability / 100.0, // Normalized probability
        'cumulativeProbability': cumulativeProbability,
      });
    }

    // Normalize the distribution
    double totalProbability = distribution.isNotEmpty
        ? distribution.last['cumulativeProbability']
        : 0.0;

    if (totalProbability == 0.0) {
      throw Exception("Total probability cannot be zero.");
    }

    for (var item in distribution) {
      item['probability'] = item['probability'] / totalProbability;
      item['cumulativeProbability'] =
          item['cumulativeProbability'] / totalProbability;
    }
    debugPrint("Probability distribution: $distribution");
    return distribution;
  }

  int _getRandomX(List<Map<String, dynamic>> distribution) {
    double rand = Random().nextDouble();
    for (var item in distribution) {
      if (rand <= item['cumulativeProbability']) {
        return item['x'];
      }
    }
    // Ensure a value is returned
    if (distribution.isNotEmpty) {
      return distribution.last['x'];
    } else {
      throw Exception("Probability distribution is empty.");
    }
  }
}
