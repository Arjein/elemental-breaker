import 'package:flame/components.dart';
import 'package:flame/particles.dart';
import 'dart:math';
import 'package:flutter/material.dart';

class LightningParticle extends Particle {
  final Vector2 start;
  final Vector2 end;
  final Paint paint;
  final Random random = Random();

  LightningParticle({
    required this.start,
    required this.end,
    required double lifespan,
  })  : paint = Paint()
          ..color = Colors.blueGrey
          ..strokeWidth = 2.0
          ..style = PaintingStyle.stroke
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, 1),
        super(lifespan: lifespan);

  @override
  void render(Canvas canvas) {
    final path = Path();

    // Number of segments in the lightning
    const int segments = 15;
    final delta = end - start;

    path.moveTo(start.x, start.y);

    for (int i = 1; i <= segments; i++) {
      final t = i / segments;
      final currentPoint = start + delta * t;

      // Add randomness to create the zig-zag effect
      final offsetX = (random.nextDouble() - 0.5) * 20; // Adjust as needed
      final offsetY = (random.nextDouble() - 0.5) * 20;

      final randomPoint = currentPoint + Vector2(offsetX, offsetY);

      path.lineTo(randomPoint.x, randomPoint.y);
    }

    canvas.drawPath(path, paint);
  }
}

class LightningEffect extends PositionComponent {
  final VoidCallback onComplete; // Callback to notify when effect is done
  final double lifespan; // Duration of the lightning effect

  LightningEffect({
    required Vector2 start,
    required Vector2 end,
    required this.onComplete,
    this.lifespan = 0.15, // Default lifespan of the effect
  }) {
    position = start;
    size = (end - start);
    anchor = Anchor.topLeft;

    final particle = LightningParticle(
      start: Vector2.zero(),
      end: end - start,
      lifespan: lifespan,
    );

    final particleComponent = ParticleSystemComponent(
      particle: particle,
      position: Vector2.zero(),
    );

    add(particleComponent);

    // Set up a timer to call onComplete after the lifespan
    add(
      TimerComponent(
        period: lifespan,
        repeat: false,
        onTick: () {
          onComplete();
          removeFromParent(); // Remove the LightningEffect from the game
        },
      ),
    );
  }
}
