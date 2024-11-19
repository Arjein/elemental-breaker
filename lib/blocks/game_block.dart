// game_block.dart
import 'package:elemental_breaker/Constants/collision_groups.dart';
import 'package:elemental_breaker/Constants/elements.dart';
import 'package:elemental_breaker/blocks/components/block_renderer.dart';
import 'package:elemental_breaker/blocks/components/elemental_effect.dart';
import 'package:elemental_breaker/game_components.dart/damage_source.dart';
import 'package:elemental_breaker/game_components.dart/game_ball.dart';
import 'package:elemental_breaker/grid_manager.dart';
import 'package:elemental_breaker/level_manager.dart';
import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'dart:async';
import 'package:flutter/material.dart';

abstract class GameBlock extends BodyComponent
    with ContactCallbacks
    implements DamageSource {
  int health;
  final Vector2 size;
  final Vector2 vectorPosition;
  final GridManager gridManager;
  final double strokeWidth;
  final Color color;
  @override
  late final Elements element;

  int gridXIndex;
  int gridYIndex;

  // Reference to LevelManager
  final LevelManager levelManager;
  bool isReadyToTrigger = false;
  bool isMoving = false;

  int stack = 0;

  // **Highlight Properties**
  bool isHighlighted = false;

  final String? spritePath;

  late final BlockRenderer renderer;

  final ElementalEffect elementalEffect;

  GameBlock({
    required this.health,
    required this.size,
    required this.vectorPosition,
    required this.color,
    required this.gridManager,
    required this.levelManager,
    required this.gridXIndex,
    required this.gridYIndex,
    this.strokeWidth = 0.2,
    required this.element,
    this.spritePath, // Optional sprite path
    required this.elementalEffect,
  }) : super(
          paint: Paint()
            ..color = Colors.transparent // Set to transparent
            ..style = PaintingStyle.stroke // Use stroke style
            ..strokeWidth = strokeWidth,
        ) {
    // The paint is handled by BlockRenderer
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    // Initialize the renderer and add it as a child component
    renderer = BlockRenderer(this);
    await add(renderer);
    debugMode = false; // Set to true to see the body's shape
  }

  @override
  Body createBody() {
    final shape = PolygonShape();
    shape.set([
      Vector2(-size.x / 2, -size.y / 2),
      Vector2(size.x / 2, -size.y / 2),
      Vector2(size.x / 2, size.y / 2),
      Vector2(-size.x / 2, size.y / 2),
    ]);
    final fixtureDef = FixtureDef(shape)
      ..restitution = 1.0
      ..friction = 0.0
      ..density = 1.0
      ..filter.groupIndex = GROUP_BLOCK // Assign to block group
      ..userData = this;

    final bodyDef = BodyDef(
      position: vectorPosition,
      type: BodyType.static,
      userData: this,
    );
    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }

  @override
  void beginContact(Object other, Contact contact) {
    super.beginContact(other, contact);

    if (other is GameBall) {
      debugPrint("This Happened : $other");
      receiveDamage(other); // Since damage is 1.
    }
  }

  void receiveDamage(DamageSource source) {
    Elements sourceElement = source.element;
    int damage = source.damage;

    if (source is GameBall) {
      if (isReadyToTrigger) {
        if (sourceElement == element) {
          stack += damage;
          if (stack > 0 && !levelManager.effectQueue.contains(this)) {
            levelManager.effectQueue.add(this);
          }
        }
      } else {
        health -= damage;
        if (health <= 0) {
          if (sourceElement == element) {
            isReadyToTrigger = true;
            if (!levelManager.effectQueue.contains(this)) {
              levelManager.effectQueue.add(this);
            }
          } else {
            removeBlock();
          }
        }
      }
    }

    if (source is GameBlock) {
      if (isReadyToTrigger) {
        if (sourceElement == element) {
          stack += damage;
          if (stack > 0 && !levelManager.effectQueue.contains(this)) {
            levelManager.effectQueue.add(this);
          }
        }
      } else {
        if (damage > health) {
          if (sourceElement == element) {
            stack = damage - health;
            health = 0;
            isReadyToTrigger = true;
            if (!levelManager.effectQueue.contains(this)) {
              levelManager.effectQueue.add(this);
            }
          } else {
            removeBlock();
          }
        } else {
          health -= damage;
          if (health == 0) {
            removeBlock();
          }
        }
      }
    }
    updateHealthDisplay();
  }

  Future<void> triggerElementalEffect() async {
    await elementalEffect.execute(this);
  }

  void removeBlock() {
    gridManager.removeBlockFromGrid(this);
  }

  /// **Highlight Method with Type-Specific Color**
  void highlight(Color color) {
    renderer.highlight(color);
  }

  void updateHealthDisplay() {
    renderer.updateHealthDisplay(isReadyToTrigger ? '$stack' : '$health');
  }

  @override
  void update(double dt) {
    super.update(dt);
    // Shared update logic, if any
  }

  /// **Movement Method**
  void updatePosition(int newXAxisIndex, int newYAxisIndex,
      {VoidCallback? onComplete}) {
    if (isMoving) return;

    isMoving = true;

    // Calculate the new position in the game world
    Vector2 newPosition =
        gridManager.getPositionFromGridIndices(newXAxisIndex, newYAxisIndex);

    // Calculate the distance to move
    final Vector2 currentPosition = body.position.clone();
    final Vector2 movement = newPosition - currentPosition;

    // Calculate the required velocity
    final duration = 0.4; // Duration in seconds
    final Vector2 velocity = movement / duration;

    // Set the body to kinematic
    body.setType(BodyType.kinematic);

    // Set the linear velocity
    body.linearVelocity = velocity;

    // Schedule to stop the movement after the duration
    add(
      TimerComponent(
        period: duration,
        removeOnFinish: true,
        onTick: () {
          // Stop the block
          body.linearVelocity = Vector2.zero();
          body.setType(BodyType.static);

          isMoving = false;

          // Call the onComplete callback if provided
          if (onComplete != null) {
            onComplete();
          }
        },
      ),
    );
  }

  @override
  String toString() {
    return '${this.runtimeType}(health: $health, stack: $stack, size: $size, position: ${body.position}, color: ${renderer.paint.color})';
  }
}
