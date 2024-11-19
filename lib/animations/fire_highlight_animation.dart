// fire_highlight_animation.dart

import 'package:flutter/material.dart';
import 'highlight_animation.dart';

class FireHighlightAnimation extends HighlightAnimation {
  FireHighlightAnimation({
    required super.onComplete,
  }) : super(
          baseColor: Colors.red,
          steps: [
            HighlightStep(0.3, 0.3), // Fade to 0.3 opacity over 0.3s
            HighlightStep(0.4, 0.1), // Increase to 0.4 over 0.1s
            HighlightStep(0.6, 0.1), // Increase to 0.6 over 0.1s
            HighlightStep(0.9, 0.0), // Instantly to 0.9 opacity
          ],
        );
}
