// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AlarmModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AlarmModel _$AlarmModelFromJson(Map<String, dynamic> json) => AlarmModel(
      json['alarm_dealer_idx'] as int?,
      json['alarm_dealer_dealer_idx'] as int?,
      json['alarm_dealer_detail'] as String?,
      json['alarm_dealer_isRead'] as int?,
      json['alarm_dealer_updatetime'] as String?,
      json['alarm_dealer_createtime'] as String?,
    );

Map<String, dynamic> _$AlarmModelToJson(AlarmModel instance) =>
    <String, dynamic>{
      'alarm_dealer_idx': instance.alarm_dealer_idx,
      'alarm_dealer_dealer_idx': instance.alarm_dealer_dealer_idx,
      'alarm_dealer_detail': instance.alarm_dealer_detail,
      'alarm_dealer_isRead': instance.alarm_dealer_isRead,
      'alarm_dealer_updatetime': instance.alarm_dealer_updatetime,
      'alarm_dealer_createtime': instance.alarm_dealer_createtime,
    };
