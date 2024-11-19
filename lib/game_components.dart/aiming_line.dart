import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';

class AimingLine extends Component with HasGameRef<Forge2DGame> {
  Vector2 startPoint = Vector2.zero();
  Vector2 endPoint = Vector2.zero();
  final Paint paint;

  AimingLine()
      : paint = Paint()
          ..color = Colors.white
          ..strokeWidth = 1.0
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;

  void updateLine({required Vector2 startPoint, required Vector2 endPoint}) {
    this.startPoint = startPoint;
    this.endPoint = endPoint;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    // Convert world coordinates to screen coordinates
    final startOffset = gameRef.camera.localToGlobal(startPoint).toOffset();
    final endOffset = gameRef.camera.localToGlobal(endPoint).toOffset();

    final path = Path()
      ..moveTo(startOffset.dx, startOffset.dy)
      ..lineTo(endOffset.dx, endOffset.dy);
    final dashedPath = _createDashedPath(path, dashWidth: 25, dashGap: 15);

    canvas.drawPath(dashedPath, paint);
  }

  Path _createDashedPath(Path path,
      {required double dashWidth, required double dashGap}) {
    final Path dashedPath = Path();
    final PathMetrics pathMetrics = path.computeMetrics();
    for (final PathMetric pathMetric in pathMetrics) {
      double distance = 0.0;
      bool draw = true;
      while (distance < pathMetric.length) {
        final double length = draw ? dashWidth : dashGap;
        final double nextDistance = distance + length;
        if (nextDistance > pathMetric.length) {
          final double remainingLength = pathMetric.length - distance;
          if (draw) {
            dashedPath.addPath(
              pathMetric.extractPath(distance, distance + remainingLength),
              Offset.zero,
            );
          }
          break;
        } else {
          if (draw) {
            dashedPath.addPath(
              pathMetric.extractPath(distance, nextDistance),
              Offset.zero,
            );
          }
          distance = nextDistance;
          draw = !draw;
        }
      }
    }
    return dashedPath;
  }
}
