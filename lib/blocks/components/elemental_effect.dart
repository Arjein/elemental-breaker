// elemental_effect.dart


import 'package:elemental_breaker/blocks/game_block.dart';

/// An interface defining the contract for elemental effects.
abstract class ElementalEffect {
  /// Executes the elemental effect on the given block.
  Future<void> execute(GameBlock block);
}
