import 'dart:collection';
import 'dart:math';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

part 'midpoint_state.dart';

class MidpointCubit extends Cubit<MidpointState> {
  MidpointCubit() : super(const MidpointDraw(points: []));

  List<SplayTreeSet<Offset>> pointsBySteps = [];

  void draw(
      Offset startOffset, Offset endOffset, double roughness, double minStep,
      {int? step}) {
    emit(const MidpointLoading());

    List<Offset> points = [];
    if (step == null) {
      pointsBySteps =
          _calculatePoints(startOffset, endOffset, roughness, minStep);
      points = pointsBySteps.last.toList();
    } else {
      points = pointsBySteps[step].toList();
    }

    emit(MidpointDraw(points: points));
  }
}

List<SplayTreeSet<Offset>> _calculatePoints(
    Offset startOffset, Offset endOffset, double roughness, double minStep) {
  var maxY = max(endOffset.dy, startOffset.dy);
  var pointsBySteps = [
    SplayTreeSet<Offset>.from([
      startOffset,
      endOffset,
    ], (l, r) => l.dx.compareTo(r.dx))
  ];

  Random random = Random();

  var queue = List.from(pointsBySteps.first);

  while (queue.isNotEmpty) {
    var end = queue.removeLast();
    var start = queue.removeLast();

    var len = end.dx - start.dx;
    if (len / 2 < minStep) {
      continue;
    }

    double midX = (start.dx + end.dx) / 2;
    double midY = (start.dy + end.dy) / 2;

    double displacement = (random.nextDouble() * 2 - 1) * roughness * len / 2;

    var midPoint = Offset(midX, max(min(midY + displacement, maxY), 0));

    pointsBySteps.add(SplayTreeSet<Offset>.from(
        pointsBySteps.last, (l, r) => l.dx.compareTo(r.dx))
      ..add(midPoint));

    queue.insert(0, end);
    queue.insert(0, midPoint);
    queue.insert(0, midPoint);
    queue.insert(0, start);
  }
  return pointsBySteps;
}
