// earth_highlight_animation.dart

import 'package:flutter/material.dart';
import 'highlight_animation.dart';

class EarthHighlightAnimation extends HighlightAnimation {
  EarthHighlightAnimation({
    required super.onComplete,
  }) : super(
          baseColor: Colors.brown,
          steps: [
            HighlightStep(0.2, 0.4), // Fade to 0.2 opacity over 0.4s
            HighlightStep(0.35, 0.2), // Increase to 0.35 over 0.2s
            HighlightStep(0.5, 0.2), // Increase to 0.5 over 0.2s
            HighlightStep(0.8, 0.0), // Instantly to 0.8 opacity
          ],
        );
}
