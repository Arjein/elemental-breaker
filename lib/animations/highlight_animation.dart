// highlight_animation.dart

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class HighlightStep {
  final double targetOpacity;
  final double duration; // Duration in seconds

  HighlightStep(this.targetOpacity, this.duration);
}

/// A generic component to handle highlight animations.
class HighlightAnimation extends Component {
  final Color baseColor;
  final List<HighlightStep> steps;
  final VoidCallback onComplete;

  double currentOpacity = 0.0;
  int currentStep = 0;
  double stepTimer = 0.0;

  HighlightAnimation({
    required this.baseColor,
    required this.steps,
    required this.onComplete,
  });

  @override
  void update(double dt) {
    if (currentStep >= steps.length) return;

    HighlightStep step = steps[currentStep];
    stepTimer += dt;

    if (step.duration > 0) {
      double progress = stepTimer / step.duration;
      if (progress >= 1.0) {
        currentOpacity = step.targetOpacity;
        stepTimer = 0.0;
        currentStep += 1;
      } else {
        double previousOpacity =
            currentStep == 0 ? 0.0 : steps[currentStep - 1].targetOpacity;
        currentOpacity = previousOpacity +
            (step.targetOpacity - previousOpacity) * progress;
      }
    } else {
      // Instant change
      currentOpacity = step.targetOpacity;
      currentStep += 1;
    }

    // Update the paint color's opacity
    // This requires the parent to access this component's currentOpacity.
    // Alternatively, use callbacks or state management to reflect the opacity.
    // For simplicity, we'll assume the parent accesses currentOpacity directly.

    if (currentStep >= steps.length) {
      onComplete();
    }
  }
}
