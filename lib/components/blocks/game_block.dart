import 'package:elemental_breaker/Constants/collision_groups.dart';
import 'package:elemental_breaker/Constants/elements.dart';
import 'package:elemental_breaker/components/blocks/block_ui/text_display_component.dart';
import 'package:elemental_breaker/components/damage_source.dart';
import 'package:elemental_breaker/components/game_ball.dart';
import 'package:elemental_breaker/grid_manager.dart';
import 'package:elemental_breaker/level_manager.dart';
import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';

abstract class GameBlock extends BodyComponent
    with ContactCallbacks
    implements DamageSource {
  int health;
  final Vector2 size;
  final Vector2 vectorPosition;
  final GridManager gridManager;
  final double strokeWidth;

  @override
  late final Elements element;

  int gridXIndex;
  int gridYIndex;

  // Reference to LevelManager
  final LevelManager levelManager;
  bool isReadyToTrigger = false;
  bool isMoving = false;

  int stack = 0;

  @override
  final Paint paint;

  // **Highlight Properties**
  bool isHighlighted = false;
  late Paint highlightPaint;
  TextDisplayComponent? textDisplay;

  final String? spritePath;

  GameBlock({
    required this.health,
    required this.size,
    required this.vectorPosition,
    required Color color,
    required this.gridManager,
    required this.levelManager,
    required this.gridXIndex,
    required this.gridYIndex,
    this.strokeWidth = 0.2,
    required this.element,
    this.spritePath, // Optional sprite path
  })  : paint = Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth,
        super(paint: Paint()..color = Colors.white) {
    highlightPaint = Paint()
      ..color = Colors.transparent
      ..style = PaintingStyle.fill;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    // Enable debug mode if needed

    // **1. Load and Add Background Sprite (If Provided)**
    if (spritePath != null) {
      try {
        final sprite = await Sprite.load(spritePath!);
        final spriteComponent = SpriteComponent(
          sprite: sprite,
          size: size, // Adjust scaling factor as needed
          anchor: Anchor.center,
        )..priority = 0; // Lower priority to render below text
        add(spriteComponent);
      } catch (e) {
        debugPrint("Error loading sprite: $e");
      }
    }
    textDisplay = TextDisplayComponent(
      text: '$health',
      position: Vector2.zero(), // Centered on the block
      fontSize: 2, // Adjust as needed
      textColor: Colors.white, // Choose a color that contrasts with your block
    )..priority = 100; // Highest priority to render on top
    add(textDisplay!);
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

  void receiveDamage(DamageSource source) {
    //TODO:  Add Damage Here and change ball to element

    Elements sourceElement = source.element;
    int damage = source.damage;

    if (source is GameBall) {
      if (isReadyToTrigger) {
        if (sourceElement == element) {
          stack += damage;
          if (stack > 0) {
            if (levelManager.effectQueue.contains(this) == false) {
              levelManager.effectQueue.add(this);
            }
          }
        }
      } else {
        health -= damage;
        if (health <= 0) {
          if (sourceElement == element) {
            isReadyToTrigger = true;
            if (levelManager.effectQueue.contains(this) == false) {
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
        }
      } else {
        // Case is when the block is same element with source element
        if (damage > health) {
          if (sourceElement == element) {
            stack = damage - health;
            health = 0;
            isReadyToTrigger = true;
            if (levelManager.effectQueue.contains(this) == false) {
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

    /*
    if (isReadyToTrigger) {
      if (sourceElement == element) {
        // Continue stacking
        stack += damage;
        if (stack > 0) {
          if (levelManager.effectQueue.contains(this) == false) {
            levelManager.effectQueue.add(this);
          }
        }
      }
    } else {
      // TODO Modify here for chain effects maybe minor mistakes here.
      health -= damage;
      if (health <= 0) {
        if (sourceElement == element) {
          // Start stacking
          if (health == 0) {
            isReadyToTrigger = true;
          } else {
            isReadyToTrigger = true; // Mark for triggering at end of level
            if (levelManager.effectQueue.contains(this) == false) {
              levelManager.effectQueue.add(this);
            }

            stack += -health;
            health = 0;
            //  debugPrint("Block at $gridXIndex, $gridYIndex: $health and stack: $stack");
          }
        } else {
          // Remove the block immediately
          removeBlock();
        }
      }
    }
    updateHealthDisplay();
    */
  }

  Future<void> triggerElementalEffect();

  void removeBlock() {
    gridManager.removeBlockFromGrid(this);
  }

  @override
  void beginContact(Object other, Contact contact) {
    super.beginContact(other, contact);

    if (other is GameBall) {
      debugPrint("THis Happened : $other");
      receiveDamage(other); // Since damage is 1.
    }
  }

  /// **Highlight Method with Type-Specific Color**
  void highlight(Color color) {
    if (!isHighlighted) {
      isHighlighted = true;
      highlightPaint.color = color.withOpacity(0.4);
      debugPrint(
          "Highlighting block: $this with color ${highlightPaint.color.toString()}");

      // Add a TimerComponent to remove the highlight after the specified duration
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    // Draw the block as a rectangle with only borders
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset.zero,
        width: size.x,
        height: size.y,
      ),
      isHighlighted ? highlightPaint : paint,
    );

    if (isReadyToTrigger) {
      paint.style = PaintingStyle.fill;
    }
  }

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

  /// **Update the Health Text**
  void updateHealthDisplay() {
    if (textDisplay != null) {
      textDisplay!.updateText(isReadyToTrigger ? '$stack' : '$health');
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Shared update logic, if any
  }
}
