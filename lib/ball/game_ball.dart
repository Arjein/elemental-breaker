import 'package:elemental_breaker/Constants/elements.dart';
import 'package:elemental_breaker/ball/components/ball_physics.dart';
import 'package:elemental_breaker/ball/components/base_ball_renderer.dart';
import 'package:elemental_breaker/ball/components/fire_ball_renderer.dart';
import 'package:elemental_breaker/game_components.dart/ball_launcher.dart';
import 'package:elemental_breaker/game_components.dart/damage_source.dart';
import 'package:elemental_breaker/game_components.dart/game_wall.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

class GameBall extends BallPhysics
    with ContactCallbacks
    implements DamageSource {
  @override
  final Elements element;
  final BallLauncher ballLauncher;

  GameBall({
    required this.element,
    required this.ballLauncher,
    required super.position,
    super.radius = 1.0,
  });

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    // Add rendering components or visuals here
    // For example, add a sprite or custom visual component
    debugMode = false; // Set to true to see the body's shape
    BaseBallRenderer renderer;

    switch (element) {
      case Elements.fire:
        renderer = FireBallRenderer(radius: radius, ball: this);
        await add(renderer);
        break;
      case Elements.water:
        //renderer = WaterBallRenderer(radius: radius, ball: this);
        //await add(renderer);
        break;
      case Elements.earth:
        break;
      case Elements.air:
        break;
    }
  }

  @override
  void beginContact(Object other, Contact contact) {
    super.beginContact(other, contact);
    // Game-specific contact handling
    if (other is GameBall) {
      // Ignore collisions with other GameBalls
      return;
    }
    if (other is Wall && other.isBottomWall) {
      // Notify the BallLauncher that this ball has hit the bottom wall
      ballLauncher.onBallHitBottom(this);
    }
  }

  @override
  int get damage => 1;
}
