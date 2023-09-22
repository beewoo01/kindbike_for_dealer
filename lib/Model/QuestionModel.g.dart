// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'QuestionModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuestionModel _$QuestionModelFromJson(Map<String, dynamic> json) =>
    QuestionModel(
      json['question_idx'] as int?,
      json['question_state'] as int?,
      json['question_people_idx'] as int?,
      json['question_title'] as String?,
      json['question_detail'] as String?,
      json['question_createtime'] as String?,
      json['question_updatetime'] as String?,
      json['question_answer_idx'] as int?,
      json['question_answer_question_idx'] as int?,
      json['question_answer_detail'] as String?,
      json['question_answer_createtime'] as String?,
      json['question_answer_updatetime'] as String?,
    );

Map<String, dynamic> _$QuestionModelToJson(QuestionModel instance) =>
    <String, dynamic>{
      'question_idx': instance.question_idx,
      'question_state': instance.question_state,
      'question_people_idx': instance.question_people_idx,
      'question_title': instance.question_title,
      'question_detail': instance.question_detail,
      'question_createtime': instance.question_createtime,
      'question_updatetime': instance.question_updatetime,
      'question_answer_idx': instance.question_answer_idx,
      'question_answer_question_idx': instance.question_answer_question_idx,
      'question_answer_detail': instance.question_answer_detail,
      'question_answer_createtime': instance.question_answer_createtime,
      'question_answer_updatetime': instance.question_answer_updatetime,
    };
