part of 'bezier_bloc.dart';

@immutable
sealed class BezierState {
  final List<BezierPoint> points;
  const BezierState({required this.points});

  BezierState copyWith({
    List<BezierPoint>? points,
  });
}

class BezierCommonState extends BezierState {
  const BezierCommonState({required super.points});

  @override
  BezierCommonState copyWith({List<BezierPoint>? points}) {
    return BezierCommonState(
      points: points ?? this.points
    );
  }
}

class BezierPointHeld extends BezierState {
  const BezierPointHeld({
    required this.index,
    required this.isPrevious,
    required super.points
  });
  final int index;
  final bool isPrevious;

  @override
  BezierPointHeld copyWith({
    List<BezierPoint>? points
  }) {
    return BezierPointHeld(
      index: index,
      isPrevious: isPrevious,
      points: points ?? this.points
    );
  }
}

