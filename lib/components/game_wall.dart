import 'package:flame_forge2d/flame_forge2d.dart';

class Wall extends BodyComponent {
  final Vector2 _start;
  final Vector2 _end;
  final bool isBottomWall;

  Wall(this._start, this._end, {this.isBottomWall = false});

  @override
  Body createBody() {
    final shape = EdgeShape()..set(_start, _end);
    final fixtureDef = FixtureDef(shape);
    final bodyDef = BodyDef(
      userData: this,
      type: BodyType.static,
      position: Vector2.zero(),
    );

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}
