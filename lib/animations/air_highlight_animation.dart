// air_highlight_animation.dart

import 'package:flutter/material.dart';
import 'highlight_animation.dart';

class AirHighlightAnimation extends HighlightAnimation {
  AirHighlightAnimation({
    required super.onComplete,
  }) : super(
          baseColor: Colors.grey,
          steps: [
            HighlightStep(0.2, 0.3), // Fade to 0.2 opacity over 0.3s
            HighlightStep(0.3, 0.2), // Increase to 0.3 over 0.2s
            HighlightStep(0.5, 0.2), // Increase to 0.5 over 0.2s
            HighlightStep(0.7, 0.0), // Instantly to 0.7 opacity
          ],
        );
}
