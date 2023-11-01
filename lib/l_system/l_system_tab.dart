import 'package:bezier_curves/l_system/l_system_bloc/l_system_bloc.dart';
import 'package:bezier_curves/l_system/l_system_paint.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LSystemTab extends StatelessWidget {
  const LSystemTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LSystemBloc>(
      create: (context) => LSystemBloc(),
      child: BlocBuilder<LSystemBloc, LSystemState>(builder: (context, state) {
        return switch (state) {
          LSystemInitial() => Center(
              child: ElevatedButton(
                onPressed: () {
                  BlocProvider.of<LSystemBloc>(context).add(
                    const LSystemFilePickingStarted(),
                  );
                },
                child: const Text("Загрузить конфигурацию"),
              ),
            ),
          LSystemLoaded() => Stack(
              children: [
                CustomPaint(
                  foregroundPainter: LSystemPainter(
                    state.config,
                    state.iterations,
                    state.isRandom,
                  ),
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Colors.white,
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: SizedBox(
                    width: 100,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            BlocProvider.of<LSystemBloc>(context).add(
                              const LSystemFilePickingStarted(),
                            );
                          },
                          child: Icon(Icons.upload_outlined),
                        ),
                        TextField(
                          controller: TextEditingController(
                            text: state.iterations.toString(),
                          ),
                          onSubmitted: (String val) {
                            BlocProvider.of<LSystemBloc>(context).add(
                              LSystemIterationsChanged(
                                int.parse(
                                  val,
                                ),
                              ),
                            );
                          },
                        ),
                        Checkbox(
                          value: state.isRandom,
                          onChanged: (val) {
                            BlocProvider.of<LSystemBloc>(context).add(
                              LSystemRandomizationSet(
                                val!,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
        };
      }),
    );
  }
}
