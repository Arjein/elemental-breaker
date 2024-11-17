import 'package:flame/particles.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class FlameParticle extends Particle {
  final Random random = Random();

  FlameParticle({
    required double lifespan,
  }) : super(lifespan: lifespan);

  @override
  void render(Canvas canvas) {
    final paint = Paint()..color = Colors.orange.withOpacity(0.7);

    for (int i = 0; i < 5; i++) {
      final x = (random.nextDouble() - 0.5) * 20;
      final y = (random.nextDouble() - 0.5) * 20;
      final radius = random.nextDouble() * 5 + 2;

      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }
}
