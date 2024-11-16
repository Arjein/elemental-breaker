import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart'; // Import for SpriteSheet
import 'package:flutter/material.dart';

class LightningEffect extends SpriteAnimationComponent {
  LightningEffect({
    required Vector2 position,
    required Vector2 size,
  }) : super(
          position: position,
          size: size,
          anchor: Anchor.center,
          removeOnFinish: true, // Automatically remove when animation finishes
        );

  @override
  Future<void> onLoad() async {
    super.onLoad();

    // Load the lightning sprite sheet
    final image = await Flame.images.load('lightning_effect.png');

    // Define the frame size and count
    final Vector2 frameSize =
        Vector2(64, 64); // Adjust based on your sprite sheet
    final int frameCount = 2; // Adjust based on your sprite sheet

    // Create the sprite sheet
    final spriteSheet = SpriteSheet(image: image, srcSize: frameSize);
    debugPrint("Lightning Animation");
    // Create the animation
    animation = spriteSheet.createAnimation(
      row: 0,
      stepTime: 0.2, // Adjust for desired speed
      to: frameCount,
      loop: false,
    );
  }
}
