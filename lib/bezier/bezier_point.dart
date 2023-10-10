import 'dart:ui';

class BezierPoint {
  Offset centralPoint;
  Offset previousPoint;
  Offset nextPoint;

  BezierPoint.fromSide(Offset a, Offset b) :
    previousPoint = a,
    nextPoint = b,
    centralPoint = Offset.lerp(a, b, 0.5)!;

  BezierPoint.fromCenter(Offset p) :
        previousPoint = Offset(p.dx - 50, p.dy),
        nextPoint = Offset(p.dx + 50, p.dy),
        centralPoint = p;

  void updatePrevious(Offset newPos){
    previousPoint = newPos;
    centralPoint = Offset.lerp(previousPoint, nextPoint, 0.5)!;
  }

  void updateNext(Offset newPos){
    nextPoint = newPos;
    centralPoint = Offset.lerp(previousPoint, nextPoint, 0.5)!;
  }
}