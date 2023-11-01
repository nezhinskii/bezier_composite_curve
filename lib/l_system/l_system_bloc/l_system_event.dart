part of 'l_system_bloc.dart';

@immutable
sealed class LSystemEvent {
  const LSystemEvent();
}

class LSystemFilePickingStarted extends LSystemEvent {
  const LSystemFilePickingStarted();
}

class LSystemIterationsChanged extends LSystemEvent {
  const LSystemIterationsChanged(this.iterations);

  final int iterations;
}

class LSystemRandomizationSet extends LSystemEvent {
  const LSystemRandomizationSet(this.isRandom);

  final bool isRandom;
}