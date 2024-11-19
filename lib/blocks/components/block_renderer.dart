// block_renderer.dart
import 'package:elemental_breaker/blocks/game_block.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'text_display_component.dart';

class BlockRenderer extends Component with HasGameRef {
  final GameBlock block;

  late Paint paint;
  late Paint highlightPaint;
  TextDisplayComponent? textDisplay;
  SpriteComponent? spriteComponent;

  BlockRenderer(this.block) {
    debugPrint("Block Color: ${block.color}");
    paint = Paint()
      ..color = block.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = block.strokeWidth;

    highlightPaint = Paint()
      ..color = Colors.transparent
      ..style = PaintingStyle.fill;
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    // Load background sprite if provided
    if (block.spritePath != null) {
      debugPrint("NULL");
      try {
        final sprite = await Sprite.load(block.spritePath!);
        spriteComponent = SpriteComponent(
          sprite: sprite,
          size: block.size,
          anchor: Anchor.center,
        )..priority = 0; // Render below text
        add(spriteComponent!);
      } catch (e) {
        debugPrint("Error loading sprite: $e");
      }
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

  /// Highlights the block with the given color.
  void highlight(Color color) {
    if (!block.isHighlighted) {
      block.isHighlighted = true;
      highlightPaint.color = color.withOpacity(0.4);
      debugPrint(
          "Highlighting block: $block with color ${highlightPaint.color.toString()}");
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    // Draw block with current paint
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset.zero,
        width: block.size.x,
        height: block.size.y,
      ),
      block.isHighlighted ? highlightPaint : paint,
    );
    if (block.isReadyToTrigger) {
      paint.style = PaintingStyle.fill;
    }
  }
}
