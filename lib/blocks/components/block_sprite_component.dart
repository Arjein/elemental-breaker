import 'package:flame/components.dart';

class BlockSpriteComponent extends SpriteComponent {
  final Sprite blockSprite;
  final Vector2 blockSize;
  final double spriteOpacity;
  BlockSpriteComponent({
    required this.blockSprite,
    required this.blockSize,
    this.spriteOpacity = 1,
    double angle = 0.0,
  }) : super(
          sprite: blockSprite,
          size: blockSize,
          anchor: Anchor.center,
          priority: 0,
          angle: angle,
        );

  @override
  void onLoad() {
    super.onLoad();
    paint.color = paint.color.withOpacity(spriteOpacity);
  }

  void updateOpacity(double opacityRatio, double clampRatio) {
    double newOpacity = paint.color.opacity + opacityRatio;
    newOpacity = newOpacity.clamp(0.0, clampRatio);
    paint.color = paint.color.withOpacity(newOpacity);
  }
}
