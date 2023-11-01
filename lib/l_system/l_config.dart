import 'package:json_annotation/json_annotation.dart';

part 'l_config.g.dart';

@JsonSerializable()
class LConfig {
  String axiom;
  int rotation;
  int initialDegree;
  Map<String, String> rules;

  LConfig(this.axiom, this.rotation, this.initialDegree, this.rules);
  factory LConfig.fromJson(Map<String, dynamic> json) => _$LConfigFromJson(json);
}
