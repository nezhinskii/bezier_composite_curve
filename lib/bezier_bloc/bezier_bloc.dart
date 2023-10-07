import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:bezier_curves/bezier_point.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'bezier_event.dart';
part 'bezier_state.dart';
final initialCurve = [
  BezierPoint.fromSide(const Offset(100, 100), const Offset(120, 150)),
  BezierPoint.fromSide(const Offset(400, 370), const Offset(440, 320)),
  BezierPoint.fromSide(const Offset(650, 220), const Offset(650, 180))
];
class BezierBloc extends Bloc<BezierEvent, BezierState> {
  BezierBloc() : super(BezierCommonState(points: initialCurve)) {
    on<BezierPanDownEvent>(_onPanDown);
    on<BezierPanUpdateEvent>(_onPanUpdate);
    on<BezierPanEndEvent>(_onPanEnd);
  }

  void _onPanDown(BezierPanDownEvent event, Emitter emit) {
    for (int i = 0; i < state.points.length; ++ i){
      if ((event.position - state.points[i].previousPoint).distance < 15){
        emit(
          BezierPointHeld(
            index: i,
            isPrevious: true,
            points: state.points
          )
        );
        return;
      } else if ((event.position - state.points[i].nextPoint).distance < 15) {
        emit(
          BezierPointHeld(
            index: i,
            isPrevious: false,
            points: state.points
          )
        );
        return;
      }
    }

    for (int i = 0; i < state.points.length; ++i){
      if ((event.position - state.points[i].centralPoint).distance < 10 && state.points.length > 2) {
        emit(
          state.copyWith(
            points: state.points..removeAt(i)
          )
        );
        return;
      }
    }

    for (int i = 1; i < state.points.length; ++i){
      final curvePoints = bezierCurve(
        state.points[i - 1].centralPoint,
        state.points[i - 1].nextPoint,
        state.points[i].previousPoint,
        state.points[i].centralPoint);
      if (curvePoints.any((element) => (element - event.position).distance < 5)){
        emit(
          state.copyWith(
            points: state.points..insert(i, BezierPoint.fromCenter(event.position))
          )
        );
        return;
      }
    }

    emit(
      state.copyWith(
          points: state.points..add(BezierPoint.fromCenter(event.position))
      )
    );
  }

  void _onPanUpdate(BezierPanUpdateEvent event, Emitter emit){
    if (state is BezierPointHeld){
      final heldState = (state as BezierPointHeld);
      if (heldState.isPrevious){
        state.points[heldState.index].updatePrevious(event.position);
      } else {
        state.points[heldState.index].updateNext(event.position);
      }
      emit(
        state.copyWith(points: state.points)
      );
    }
  }

  void _onPanEnd(BezierPanEndEvent event, Emitter emit) {
    if (state is BezierPointHeld){
      emit(BezierCommonState(points: state.points));
    }
  }

  static const tStep = 1e-2;

  static List<Offset> bezierCurve(Offset p0, Offset p1, Offset p2, Offset p3){
    final res = <Offset>[];
    for (var t = tStep; t < 1.0; t += tStep){
      final nextPoint = p0 * pow((1 - t), 3).toDouble()
          + p1 * pow((1 - t), 2).toDouble() * t * 3
          + p2 * (1 - t) * pow(t, 2).toDouble() * 3
          + p3 * pow(t, 3).toDouble();
      res.add(nextPoint);
    }
    return res;
  }
}
