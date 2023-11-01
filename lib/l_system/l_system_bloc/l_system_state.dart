part of 'l_system_bloc.dart';

@immutable
sealed class LSystemState {
  const LSystemState({
    required this.iterations,
    required this.isRandom,
  });

  final int iterations;
  final bool isRandom;

  LSystemState copyWith({
    int? iterations,
    bool? isRandom,
  });
}

class LSystemInitial extends LSystemState {
  const LSystemInitial({required super.iterations, required super.isRandom});

  @override
  LSystemInitial copyWith({int? iterations, bool? isRandom}) {
    return LSystemInitial(
      iterations: iterations ?? this.iterations,
      isRandom: isRandom ?? this.isRandom,
    );
  }
}

class LSystemLoaded extends LSystemState {
  const LSystemLoaded({
    required super.iterations,
    required this.config,
    required super.isRandom,
  });

  final LConfig config;

  @override
  LSystemLoaded copyWith({int? iterations, LConfig? config, bool? isRandom}) {
    return LSystemLoaded(
      iterations: iterations ?? this.iterations,
      config: config ?? this.config,
      isRandom: isRandom ?? this.isRandom,
    );
  }
}
