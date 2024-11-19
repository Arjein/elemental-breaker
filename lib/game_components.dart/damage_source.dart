// damage_source.dart
import 'package:elemental_breaker/Constants/elements.dart';

/// An interface representing a source of damage.
abstract class DamageSource {
  /// The elemental type of the damage source.
  Elements get element;

  /// The amount of damage inflicted.
  int get damage;
}
