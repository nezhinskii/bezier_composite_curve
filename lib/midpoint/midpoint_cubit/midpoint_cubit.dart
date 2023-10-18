import 'dart:math';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

part 'midpoint_state.dart';

class MidpointCubit extends Cubit<MidpointState> {
  MidpointCubit({
    required Offset startOffset,
    required Offset endOffset,
    required double roughness,
    required double minStep,
    int? step,
  })  : pointsBySteps =
            _calculatePoints(startOffset, endOffset, roughness, minStep),
        super(MidpointDraw(
            points: _calculatePoints(startOffset, endOffset, roughness, minStep)
                .last));

  List<List<Offset>> pointsBySteps;

  void draw(
      Offset startOffset, Offset endOffset, double roughness, double minStep,
      {int? step}) {
    emit(const MidpointLoading());

    List<Offset> points = [];
    if (step == null) {
      pointsBySteps =
          _calculatePoints(startOffset, endOffset, roughness, minStep);
      points = pointsBySteps.last;
    } else {
      points = pointsBySteps[step];
    }

    emit(MidpointDraw(points: points));
  }
}

List<List<Offset>> _calculatePoints(
    Offset startOffset, Offset endOffset, double roughness, double minStep) {
  var pointsBySteps = [
    [
      startOffset,
      Offset((startOffset + endOffset).dx / 2,
          startOffset.dy - (endOffset - startOffset).distance / 2),
      endOffset,
    ]
  ];

  Random random = Random();

  var stack = List.from(pointsBySteps.first)..insert(1, pointsBySteps.first[1]);

  while (stack.isNotEmpty) {
    var end = stack.removeLast();
    var start = stack.removeLast();

    if (end.dx - start.dx < minStep) {
      continue;
    }

    double midX = (start.dx + end.dx) / 2;
    double midY = (start.dy + end.dy) / 2;

    double displacement = (random.nextDouble() * 2 - 1) * roughness;

    var midPoint = Offset(midX, midY + displacement);

    pointsBySteps.add(List.from(pointsBySteps.last)..add(midPoint));

    stack.add(start);
    stack.add(midPoint);
    stack.add(midPoint);
    stack.add(end);
  }

  return pointsBySteps;
}
