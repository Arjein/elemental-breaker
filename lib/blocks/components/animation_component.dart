import 'package:flame/components.dart';
import 'package:flame/flame.dart';

class AnimationComponent extends SpriteAnimationComponent {
  final Vector2 spriteSize;
  final int frameCount;
  final bool loop;
  final double stepTime;
  final String spriteSheetPath;
  AnimationComponent({
    required Vector2 size,
    required this.loop,
    required this.frameCount,
    required this.spriteSize,
    required this.stepTime,
    required this.spriteSheetPath,
    super.angle = 0,
  }) : super(
          size: size,
          anchor: Anchor.center,
        );

  @override
  onLoad() async {
    super.animation = await loadAnimation();
  }

  Future<SpriteAnimation> loadAnimation() async {
    // Load the sprite sheet image
    final spriteSheet = await Flame.images.load(spriteSheetPath);

    // Create a list of sprites from the sprite sheet
    List<Sprite> sprites = List.generate(frameCount, (i) {
      return Sprite(
        spriteSheet,
        srcPosition: Vector2(i * spriteSize.x, 0),
        srcSize: spriteSize,
      );
    });

    // Create the animation
    return SpriteAnimation.spriteList(
      sprites,
      stepTime: stepTime, // Duration per frame
      loop: loop,
    );
  }
}
