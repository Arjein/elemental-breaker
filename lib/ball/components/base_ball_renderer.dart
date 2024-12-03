// lib/ball/renderers/base_ball_renderer.dart

import 'package:elemental_breaker/Constants/elements.dart';
import 'package:flame/components.dart';

abstract class BaseBallRenderer extends SpriteComponent {
  final double radius;
  final Elements element;

  BaseBallRenderer({
    required this.radius,
    required this.element,
  }) : super(
          size: Vector2.all(radius * 2),
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad();
}
