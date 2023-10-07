part of 'bezier_bloc.dart';

@immutable
abstract class BezierEvent {
  const BezierEvent();
}

class BezierPanDownEvent extends BezierEvent{
  final Offset position;
  const BezierPanDownEvent(this.position);
}

class BezierPanUpdateEvent extends BezierEvent{
  final Offset position;
  const BezierPanUpdateEvent(this.position);
}

class BezierPanEndEvent extends BezierEvent{

}