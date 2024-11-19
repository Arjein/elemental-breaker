// lib/Constants/difficulty_settings.dart

import 'dart:math';

class DifficultySettings {
  // Scaling factors
  final double k = 10.0; // Controls the scaling function f(L)
  final int m = 50; // Determines how frequently n_max(L) increases

  // Probability of spawning double-health blocks
  final double p = 0.1; // 10% chance

  // Initial maximum number of blocks
  final int nInitialMax = 7;

  // Base weights (β_n) and scaling coefficients (α_n) for n = 1 to 10
  // Extend these lists if you plan to have n_max(L) > 10
  final List<double> betaN = [
    15.0, // n=1
    20.0, // n=2
    20.0, // n=3
    20.0, // n=4
    15.0, // n=5
    5.0, // n=6
    5.0, // n=7
    2.0, // n=8
    2.0, // n=9
    1.0 // n=10
  ];

  final List<double> alphaN = [
    0.1, // n=1
    0.15, // n=2
    0.2, // n=3
    0.25, // n=4
    0.3, // n=5
    0.35, // n=6
    0.4, // n=7
    0.45, // n=8
    0.5, // n=9
    0.55 // n=10
  ];

  final Random _random = Random();

  /// Determines the maximum number of blocks for a given level.
  int getMaxBlocks(int level) {
    return nInitialMax + (level ~/ m);
  }

  /// Scaling function f(L) = L / (k + L)
  double f(int level) {
    return level / (k + level);
  }

  /// Calculates weights for each possible number of blocks at level L.
  List<double> getWeights(int level) {
    int nMax = getMaxBlocks(level);
    double fL = f(level);
    List<double> weights = [];

    for (int n = 1; n <= nMax; n++) {
      if (n <= betaN.length) {
        // Use predefined β_n and α_n
        weights.add(betaN[n - 1] + alphaN[n - 1] * fL);
      } else {
        // For n beyond predefined, extend the pattern or assign default values
        // Example: Minimal base weight and increasing alpha
        double beta = 1.0;
        double alpha =
            0.6 + 0.05 * (n - betaN.length); // Increment alpha for higher n
        weights.add(beta + alpha * fL);
      }
    }

    return weights;
  }

  /// Samples the number of blocks to spawn based on the probability distribution P(n | L).
  int getNumberOfBlocks(int level) {
    List<double> weights = getWeights(level);
    double totalWeight = weights.reduce((a, b) => a + b);
    double rand = _random.nextDouble() * totalWeight;
    double cumulative = 0.0;

    for (int i = 0; i < weights.length; i++) {
      cumulative += weights[i];
      if (rand < cumulative) {
        return i + 1; // n ranges from 1 to nMax
      }
    }

    // Fallback in case of rounding errors
    return weights.length;
  }

  /// Determines whether a block should spawn with double health at the current level.
  bool shouldSpawnDoubleHealth(int level) {
    if (level >= 10 && level % 5 == 0) {
      return _random.nextDouble() < p;
    }
    return false;
  }
}
