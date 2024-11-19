// water_highlight_animation.dart

import 'package:flutter/material.dart';
import 'highlight_animation.dart';

class WaterHighlightAnimation extends HighlightAnimation {
  WaterHighlightAnimation({
    required VoidCallback onComplete,
  }) : super(
          baseColor: Colors.blue,
          steps: [
            HighlightStep(0.25, 0.3), // Fade to 0.25 opacity over 0.3s
            HighlightStep(0.35, 0.1), // Increase to 0.35 over 0.1s
            HighlightStep(0.55, 0.1), // Increase to 0.55 over 0.1s
            HighlightStep(0.85, 0.0), // Instantly to 0.85 opacity
          ],
          onComplete: onComplete,
        );
}
