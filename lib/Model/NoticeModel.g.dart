// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'NoticeModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NoticeModel _$NoticeModelFromJson(Map<String, dynamic> json) => NoticeModel(
      json['notice_idx'] as int?,
      json['notice_state'] as int?,
      json['notice_title'] as String?,
      json['notice_detail'] as String?,
      json['notice_createtime'] as String?,
      json['notice_updatetime'] as String?,
      json['faq_idx'] as int?,
      json['faq_title'] as String?,
      json['faq_detail'] as String?,
    );

Map<String, dynamic> _$NoticeModelToJson(NoticeModel instance) =>
    <String, dynamic>{
      'notice_idx': instance.notice_idx,
      'notice_state': instance.notice_state,
      'notice_title': instance.notice_title,
      'notice_detail': instance.notice_detail,
      'notice_createtime': instance.notice_createtime,
      'notice_updatetime': instance.notice_updatetime,
      'faq_idx': instance.faq_idx,
      'faq_title': instance.faq_title,
      'faq_detail': instance.faq_detail,
    };
