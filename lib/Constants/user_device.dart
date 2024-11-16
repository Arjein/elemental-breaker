import 'package:shared_preferences/shared_preferences.dart';

class UserDevice {
  static double? width;
  static double? height; // = 8 * width / 6
}

class GameConstants {
  static double? gameWidth;
  static double? gameHeight;
  static double? blockEdgeLength; // = width / 6
  static double? blockOffset; // = (3* height - 4 * width) / 21
  static const int numberOfColumns = 7;
  static const int numberOfRows = 10;
  static final List<double> positionValsX =
      List<double>.filled(GameConstants.numberOfColumns, 0.0);
  static final List<double> positionValsY =
      List<double>.filled(GameConstants.numberOfRows, 0.0);
}

class HighScoreManager {
  static const String _highScoreKey = 'high_score';

  /// Save a high score
  static Future<void> saveHighScore(int score) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_highScoreKey, score);
  }

  /// Retrieve the high score
  static Future<int> getHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_highScoreKey) ?? 0; // Default to 0 if no score exists
  }
}