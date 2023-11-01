import 'dart:math';
import 'dart:ui';

import 'package:bezier_curves/l_system/l_config.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart' as v;
import 'dart:core';

class LSystemPainter extends CustomPainter {
  final int iterations;
  final LConfig config;
  final bool isRandom;

  bool dog = false;

  static const Set<String> _actions = {"+", "-", "[", "]"};

  LSystemPainter(
    this.config,
    this.iterations,
    this.isRandom,
  );

  @override
  void paint(Canvas canvas, Size size) {
    String symbols = config.axiom;
    for (int i = 1; i <= iterations; i++) {
      symbols = step(symbols);
    }

    var points = toPoints(symbols);
    scale(points, size);
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    for (int i = 1; i < points.length; i++) {
      if (points[i] != null && points[i - 1] != null) {
        canvas.drawLine(points[i - 1]!, points[i]!, paint);
      }
    }
  }

  String step(String axiom) {
    final result = StringBuffer();
    for (int i = 0; i < axiom.length; i++) {
      var char = axiom[i];
      if (_isLetter(char)) {
        result.write(config.rules[char]);
      } else {
        result.write(char);
      }
    }
    return result.toString();
  }

  List<Offset?> toPoints(String symbols) {
    int currentDegree = config.initialDegree;
    final savedPoints = List<Offset>.empty(growable: true);
    final savedDegrees = List<int>.empty(growable: true);
    ;
    Offset currentPoint = const Offset(0, 0);

    List<Offset?> result = [currentPoint];

    for (int i = 0; i < symbols.length; i++) {
      var char = symbols[i];
      if (_isLetter(char)) {
        currentPoint = isRandom
            ? newPointRand(currentPoint, currentDegree)
            : newPoint(currentPoint, currentDegree);
        result.add(currentPoint);
      } else {
        switch (char) {
          case '+':
            if (dog) {
              currentDegree = (Random().nextDouble() * 45).round();
            } else {
              currentDegree += config.rotation;
            }
            break;
          case '-':
            if (dog) {
              currentDegree = -(Random().nextDouble() * 45).round();
            }
            currentDegree -= config.rotation;
            break;
          case '[':
            savedPoints.add(currentPoint);
            savedDegrees.add(currentDegree);
            break;
          case ']':
            if (savedPoints.isNotEmpty) {
              currentPoint = savedPoints.last;
              savedPoints.removeLast();
              result.add(null);
              result.add(currentPoint);
            }
            if (savedDegrees.isNotEmpty) {
              currentDegree = savedDegrees.last;
              savedDegrees.removeLast();
            }
            dog = false;
            break;
          case '@':
            dog = true;
            break;
        }
      }
    }
    return result;
  }

  void scale(List<Offset?> points, Size size) {
    double minX = points[0]!.dx;
    double minY = points[0]!.dy;
    double maxX = points[0]!.dx;
    double maxY = points[0]!.dy;
    for (int i = 1; i < points.length; i++) {
      if (points[i] != null) {
        final x = points[i]!.dx;
        final y = points[i]!.dy;
        if (x < minX) {
          minX = x;
        } else if (x > maxX) {
          maxX = x;
        }

        if (y < minY) {
          minY = y;
        } else if (y > maxY) {
          maxY = y;
        }
      }
    }

    final xCoef = size.width / (maxX - minX);
    final yCoef = size.height / (maxY - minY);

    for (int i = 0; i < points.length; i++) {
      if (points[i] != null) {
        points[i] = Offset(
          points[i]!.dx * xCoef,
          (points[i]!.dy * yCoef).abs(),
        );
      }
    }
  }

  Offset newPoint(Offset point, int degree) {
    return Offset(
      point.dx + cos(v.radians(degree.roundToDouble())),
      point.dy + sin(v.radians(degree.roundToDouble())),
    );
  }

  Offset newPointRand(Offset point, int degree) {
    final length = Random().nextDouble();
    return Offset(
      point.dx + cos(v.radians(degree.roundToDouble())) * length,
      point.dy + sin(v.radians(degree.roundToDouble())) * length,
    );
  }

  bool _isLetter(String ch) {
    const int aCode = 65;
    const int zCode = 90;
    return aCode <= ch.codeUnitAt(0) && ch.codeUnitAt(0) <= zCode;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
