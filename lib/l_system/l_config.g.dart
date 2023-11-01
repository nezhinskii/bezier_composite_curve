// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'l_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LConfig _$LConfigFromJson(Map<String, dynamic> json) => LConfig(
      json['axiom'] as String,
      json['rotation'] as int,
      json['initialDegree'] as int,
      Map<String, String>.from(json['rules'] as Map),
    );

Map<String, dynamic> _$LConfigToJson(LConfig instance) => <String, dynamic>{
      'axiom': instance.axiom,
      'rotation': instance.rotation,
      'initialDegree': instance.initialDegree,
      'rules': instance.rules,
    };
