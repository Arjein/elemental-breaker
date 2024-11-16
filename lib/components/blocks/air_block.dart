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
        // Stack değerini artır
        stack++;
        // RandomBlocks ve vurgulamayı güncelle
        updateRandomBlocks(baseHealth);
      }
    } else {
      health--;
      if (health <= 0) {
        if (ball.element == element) {
          // Stack mekanizmasını başlat
          isStacking = true;
          isReadyToTrigger = true; // Seviyenin sonunda tetiklenecek
          // RandomBlocks ve vurgulamayı güncelle
          updateRandomBlocks(this.baseHealth);
        } else {
          // Bloğu hemen kaldır
          removeBlock();
        }
      }
    }
  }

  @override
  void triggerElementalEffect() {
    if (isReadyToTrigger) {
      // Seçilen bloklara stack kadar hasar uygula
      for (GameBlock block in randomBlocks) {
        block.isHighlighted = false;

        addLightningEffectToBlock(block);

        block.health -= stack;
        if (block.health <= 0) {
          block.removeBlock();
        }
      }

      // Hava bloğunu kaldır
      removeBlock();
    }
  }

  void addLightningEffectToBlock(GameBlock block) {
    // Calculate the position and size for the lightning effect
    Vector2 position = block.position.clone();
    debugPrint("Block.size: ${block.size}");
    Vector2 size = block.size.clone() * 100;

    // Create the lightning effect
    LightningEffect lightning = LightningEffect(
      position: vectorPosition,
      size: size,
    );

    // Add the effect to the game
    gameRef.add(lightning);
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
