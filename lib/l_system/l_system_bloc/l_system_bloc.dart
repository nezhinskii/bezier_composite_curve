import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bezier_curves/l_system/l_config.dart';
import 'package:file_picker/file_picker.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'l_system_event.dart';

part 'l_system_state.dart';

class LSystemBloc extends Bloc<LSystemEvent, LSystemState> {
  LSystemBloc()
      : super(
          const LSystemInitial(
            iterations: 2,
            isRandom: false,
          ),
        ) {
    on<LSystemFilePickingStarted>(
      (event, emit) async {
        FilePickerResult? result = await FilePicker.platform.pickFiles();

        if (result == null) {
          return;
        }
        final jsonString = await File(result.files.single.path!).readAsString();
        emit(
          LSystemLoaded(
            iterations: state.iterations,
            config: LConfig.fromJson(
              jsonDecode(
                jsonString,
              ),
            ),
            isRandom: state.isRandom,
          ),
        );
      },
    );

    on<LSystemIterationsChanged>(
      (event, emit) async {
        if (state is LSystemInitial) {
          emit(state.copyWith(iterations: event.iterations));
        } else if (state is LSystemLoaded) {
          emit(
            LSystemLoaded(
              iterations: event.iterations,
              config: (state as LSystemLoaded).config,
              isRandom: state.isRandom,
            ),
          );
        }
      },
    );

    on<LSystemRandomizationSet>(
      (event, emit) async {
        emit(
          state.copyWith(
            isRandom: event.isRandom,
          ),
        );
      },
    );
  }
}
