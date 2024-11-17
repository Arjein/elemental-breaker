import 'dart:async';
import 'dart:math';

import 'package:elemental_breaker/Constants/elements.dart';
import 'package:elemental_breaker/animations/lightning_effect.dart';
import 'package:elemental_breaker/components/game_ball.dart';
import 'package:elemental_breaker/elemental_breaker.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'game_block.dart';

class AirBlock extends GameBlock with HasGameRef<Forge2DGame> {
  final Elements element = Elements.air;
  List<GameBlock> randomBlocks = [];
  final int baseHealth;
  AirBlock({
    required super.health,
    required super.size,
    paint,
    super.color = Colors.grey,
    required super.vectorPosition,
    required super.gridManager,
  }) : baseHealth = health;

  // Stack değiştiğinde randomBlocks listesini ve vurgulamayı günceller
  void updateRandomBlocks(int level) {
    // Önceki vurgulamaları kaldır
    for (GameBlock block in randomBlocks) {
      block.isHighlighted = false;
    }

    // Yeni olasılık dağılımını oluştur
    List<Map<String, dynamic>> probabilityDistribution =
        generateProbabilityDistribution(stack, level);

    // Yeni x değerini seç
    int x = getRandomX(probabilityDistribution);

    // Yeni randomBlocks listesini oluştur
    randomBlocks = gridManager.getRandomBlocks(x);

    // Yeni blokları vurgula
    for (GameBlock block in randomBlocks) {
      block.highlight(elementColorMap[element]);
    }
  }

  @override
  void onHit(GameBall ball) {
    if (isStacking) {
      if (ball.element == element) {
        // Increase stack value
        stack++;
        // Update randomBlocks and highlighting
        updateRandomBlocks(baseHealth);
      }
    } else {
      health--;
      if (health <= 0) {
        if (ball.element == element) {
          // Start stacking mechanism
          isStacking = true;
          isReadyToTrigger = true; // Will trigger at the end of the level
          // Update randomBlocks and highlighting
          updateRandomBlocks(baseHealth);
        } else {
          // Remove block immediately
          removeBlock();
        }
      }
    }
  }

  @override
  Future<void> triggerElementalEffect() async {
    if (isReadyToTrigger) {
      // List to hold Futures of each lightning effect
      List<Future<void>> effectFutures = [];

      // Apply damage to selected blocks after lightning effect completes
      for (GameBlock block in randomBlocks) {
        block.isHighlighted = false;

        // Add the lightning effect to the block
        Future<void> effectFuture = addLightningEffectToBlock(block);

        effectFutures.add(effectFuture);
      }

      // Wait for all effects to complete
      await Future.wait(effectFutures);

      // Remove the AirBlock itself
      removeBlock();
    }
  }

  Future<void> addLightningEffectToBlock(GameBlock block) {
    Completer<void> completer = Completer<void>();

    // Get the target block's center position in world coordinates
    Vector2 endWorldPosition = block.body.position.clone();

    // Determine the start position above the target block in world coordinates
    Vector2 startWorldPosition =
        endWorldPosition + Vector2(0, -20); // TODO: Adjust this

    // Convert world positions to screen positions
    Vector2 startScreenPosition =
        gameRef.camera.localToGlobal(startWorldPosition);
    Vector2 endScreenPosition = gameRef.camera.localToGlobal(endWorldPosition);

    debugPrint(
        'StartPosition: $startScreenPosition | EndPosition: $endScreenPosition');

    // Create the lightning effect with a callback
    LightningEffect lightning = LightningEffect(
      start: startScreenPosition,
      end: endScreenPosition,
      onComplete: () {
        // This code runs after the lightning effect completes

        if (block.health - stack <= 0) {
          block.removeBlock();
        }
        block.health -= stack;
        // Complete the completer to signal that the effect is done
        completer.complete();
      },
    );

    // Add the effect to the game
    gameRef.add(lightning);

    // Return the Future
    return completer.future;
  }

  List<Map<String, dynamic>> generateProbabilityDistribution(
      int stack, int level) {
    int minBlocks = 2;
    int maxBlocks = 6;

    // Base ve Max olasılıklarını tanımlıyoruz
    Map<int, double> baseProbabilities = {
      2: 80.0,
      3: 10.0,
      4: 5.0,
      5: 3.0,
      6: 2.0,
    };

    Map<int, double> maxProbabilities = {
      2: 5.0,
      3: 25.0,
      4: 30.0,
      5: 20.0,
      6: 20.0,
    };

    // t değerini hesaplayalım
    double t = 0.0;
    if (level > 1) {
      t = (stack - 1) / (level - 1);
    } else {
      // When level is 1, base t solely on stack
      t = (stack - 1);
    }
    t = t.clamp(0.0, 1.0);

    // Olasılıkları hesaplayalım
    List<Map<String, dynamic>> distribution = [];
    double cumulativeProbability = 0.0;

    for (int n = minBlocks; n <= maxBlocks; n++) {
      double baseP = baseProbabilities[n]!;
      double maxP = maxProbabilities[n]!;

      // Interpolasyon ile olasılığı hesapla
      double probability = baseP + t * (maxP - baseP);

      cumulativeProbability +=
          probability / 100.0; // Yüzdelik değerleri normalize ediyoruz

      distribution.add({
        'x': n,
        'probability': probability / 100.0, // Normalize edilmiş olasılık
        'cumulativeProbability': cumulativeProbability,
      });
    }

    // Son olarak, olasılıkların toplamının 1.0 olduğundan emin olalım
    double totalProbability = distribution.last['cumulativeProbability'];
    for (var item in distribution) {
      item['probability'] = item['probability'] / totalProbability;
      item['cumulativeProbability'] =
          item['cumulativeProbability'] / totalProbability;
    }
    debugPrint("Olasılıklar distribution: $distribution");
    return distribution;
  }

  int getRandomX(List<Map<String, dynamic>> distribution) {
    double rand = Random().nextDouble();
    for (var item in distribution) {
      if (rand <= item['cumulativeProbability']) {
        return item['x'];
      }
    }
    return distribution.last['x'];
  }

  @override
  String toString() {
    return 'AirBlock(health: $health, size: $size, position: $position, color: ${paint.color})';
  }
}
