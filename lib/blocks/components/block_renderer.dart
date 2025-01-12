// block_renderer.dart
import 'package:elemental_breaker/blocks/components/block_sprite_component.dart';
import 'package:elemental_breaker/blocks/components/animation_component.dart';
import 'package:elemental_breaker/blocks/effects/water_effect.dart';
import 'package:elemental_breaker/blocks/fire_block.dart';
import 'package:elemental_breaker/blocks/game_block.dart';
import 'package:elemental_breaker/blocks/water_block.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'text_display_component.dart';

class BlockRenderer extends Component with HasGameRef {
  final GameBlock block;

  late Paint paint;

  TextDisplayComponent? textDisplay;

  BlockSpriteComponent? borderDisplay;
  BlockSpriteComponent? insideDisplay;
  BlockSpriteComponent? backgroundDisplay;

  AnimationComponent? executeAnimationComponent;

  BlockRenderer(this.block) {
    debugPrint("Block Color: ${block.color}");
    paint = Paint()
      ..color = block.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = block.strokeWidth;
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();

    double angle = 0; // for water block only

    if (block is FireBlock) {
      executeAnimationComponent = AnimationComponent(
        spriteSheetPath: "fire_block/explosion_sprite_sheet.png",
        frameCount: 6,
        spriteSize: Vector2(64, 64),
        stepTime: 0.1,
        size: block.size,
        angle: angle,
        loop: false,
      );
    }

    if (block is WaterBlock) {
      if ((block.elementalEffect as WaterEffect).direction == "vertical") {
        angle = 90 * (3.14159 / 180);
      }

      executeAnimationComponent = AnimationComponent(
        spriteSheetPath: "water_block/wave_sprite_sheet.png",
        frameCount: 6,
        spriteSize: Vector2(64, 64),
        stepTime: 0.1,
        size: block.size,
        angle: angle,
        loop: false,
      );
    }

    // Load background sprite if provided
    if (block.spritePaths != null && block.spritePaths!.isNotEmpty) {
      Sprite borderSprite = await Sprite.load(
        block.spritePaths!['block_border_path']!,
      );

      borderDisplay = BlockSpriteComponent(
          blockSprite: borderSprite, blockSize: block.size + Vector2.all(0.3));

      Sprite backgroundSprite =
          await Sprite.load(block.spritePaths!['block_background_path']!);

      backgroundDisplay = BlockSpriteComponent(
        blockSprite: backgroundSprite,
        blockSize: block.size,
        spriteOpacity: 0.3,
      );

      Sprite insideSprite =
          await Sprite.load(block.spritePaths!['block_inside_path']!);

      insideDisplay = BlockSpriteComponent(
          blockSprite: insideSprite,
          blockSize: block.size,
          spriteOpacity: 0.0,
          angle: angle);

      add(borderDisplay!);
      add(backgroundDisplay!);
      add(insideDisplay!);
    }

    // Add text display
    textDisplay = TextDisplayComponent(
      text: '${block.health}',
      position: Vector2.zero(),
      fontSize: 2,
      textColor: Colors.white,
    )..priority = 100; // Render on top
    add(textDisplay!);
  }

  /// Updates the health display text.
  void updateHealthDisplay(String text) {
    textDisplay?.updateText(text);
  }

  void executionAnimation() {
    if (executeAnimationComponent != null) {
      add(executeAnimationComponent!);
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // Only draw the rectangle if no sprite paths were provided
    if (block.spritePaths == null || block.spritePaths!.isEmpty) {
      canvas.drawRect(
        Rect.fromCenter(
          center: Offset.zero,
          width: block.size.x,
          height: block.size.y,
        ),
        paint,
      );
    }
  }
}
