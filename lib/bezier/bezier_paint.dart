import 'dart:math';
import 'dart:ui';

import 'package:bezier_curves/bezier/bezier_bloc/bezier_bloc.dart';
import 'package:bezier_curves/bezier/bezier_point.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BezierPainter extends CustomPainter{
  final List<BezierPoint> points;
  const BezierPainter({
    required this.points
  });
  static const _tStep = 1e-2;

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()..color = Colors.red..strokeWidth = 1..strokeCap = StrokeCap.round;
    final circlePaint = Paint()..color = Colors.purple..strokeWidth = 10..strokeCap = StrokeCap.round;
    final squarePaint = Paint()..color = Colors.greenAccent..strokeWidth = 10..strokeCap = StrokeCap.square;
    final curvePaint = Paint()..color = Colors.black..strokeWidth = 2..strokeCap = StrokeCap.round..style = PaintingStyle.stroke;

    for(int i = 1; i < points.length; ++i){
      final curvePoints = BezierBloc.bezierCurve(points[i - 1].centralPoint, points[i - 1].nextPoint, points[i].previousPoint, points[i].centralPoint);
      final curve = Path()..moveTo(curvePoints[0].dx, curvePoints[0].dy);
      for(var p in curvePoints){
        curve.lineTo(p.dx, p.dy);
      }
      canvas.drawPath(curve, curvePaint);
    }

    for(var point in points){
      canvas.drawLine(point.previousPoint, point.nextPoint, linePaint);
      canvas.drawPoints(PointMode.points, [point.previousPoint, point.nextPoint], circlePaint);
      canvas.drawPoints(PointMode.points, [point.centralPoint], squarePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

}