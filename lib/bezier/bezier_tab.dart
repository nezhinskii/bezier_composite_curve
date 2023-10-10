import 'package:bezier_curves/bezier/bezier_bloc/bezier_bloc.dart';
import 'package:bezier_curves/bezier/bezier_paint.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BezierTab extends StatelessWidget {
  const BezierTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BezierBloc>(
      create: (context) => BezierBloc(),
      child: BlocBuilder<BezierBloc, BezierState>(
        builder: (context, state) {
          return GestureDetector(
            onPanDown: (details) {
              context.read<BezierBloc>().add(
                BezierPanDownEvent(details.localPosition));
            },
            onPanUpdate: (details) {
              context.read<BezierBloc>().add(
                BezierPanUpdateEvent(details.localPosition));
            },
            onPanEnd: (details) {
              context.read<BezierBloc>().add(BezierPanEndEvent());
            },
            child: CustomPaint(
              foregroundPainter: BezierPainter(
                points: state.points
              ),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.white,
              ),
            ),
          );
        }
      ),
    );
  }
}
