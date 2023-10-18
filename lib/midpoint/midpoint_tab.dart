import 'package:bezier_curves/midpoint/midpoint_cubit/midpoint_cubit.dart';
import 'package:bezier_curves/midpoint/midpoint_paint.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MidpointTab extends StatelessWidget {
  const MidpointTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return BlocProvider<MidpointCubit>(
          create: (context) => MidpointCubit(
              startOffset: Offset(0, constraints.maxHeight - 60),
              endOffset: Offset(constraints.maxWidth, constraints.maxHeight - 60),
              roughness: 20,
              minStep: 1),
          child:
              BlocBuilder<MidpointCubit, MidpointState>(builder: (context, state) {
            return state is MidpointLoading
                ? const Center(
                    child: SizedBox(
                        height: 30, width: 30, child: CircularProgressIndicator()),
                  )
                : Column(
                    children: [
                      SizedBox(
                        height: 60,
                        child: Row(
                          children: [
                            Slider(
                              value: 1,
                              //max: 100,
                              //divisions: 5,
                              //label: _currentSliderValue.round().toString(),
                              onChanged: (double value) {},
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ClipRRect(
                          child: CustomPaint(
                            foregroundPainter: MidpointPainter(
                                points: (state as MidpointDraw).points),
                            child: Container(
                              width: double.infinity,
                              height: double.infinity,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    ],
                  );
          }),
        );
      }
    );
  }
}
