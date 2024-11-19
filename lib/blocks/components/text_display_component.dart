// text_display_component.dart

import 'package:flame/components.dart';
import 'package:flame/text.dart';
import 'package:flutter/material.dart';

class TextDisplayComponent extends TextComponent {
  TextDisplayComponent({
    required String text,
    required Vector2 position,
    double fontSize = 2,
    Color textColor = Colors.white,
  }) : super(
          text: text,
          position: position,
          textRenderer: TextPaint(
            style: TextStyle(
              color: textColor,
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
          anchor: Anchor.center,
        );

  /// Updates the displayed text.
  void updateText(String newText) {
    text = newText;
  }
}
