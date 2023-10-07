import 'package:bezier_curves/bezier_bloc/bezier_bloc.dart';
import 'package:bezier_curves/bezier_paint.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: BlocProvider<BezierBloc>(
          create: (context) => BezierBloc(),
          child: const HomePage()
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BlocBuilder<BezierBloc, BezierState>(
          builder: (context, state) {
            return ClipRRect(
              child: GestureDetector(
                onPanDown: (details) {
                  context.read<BezierBloc>().add(BezierPanDownEvent(details.localPosition));
                },
                onPanUpdate: (details) {
                  context.read<BezierBloc>().add(BezierPanUpdateEvent(details.localPosition));
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
              ),
            );
          },
        ),
      ],
    );
  }
}
