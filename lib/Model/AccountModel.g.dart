// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AccountModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountModel _$AccountModelFromJson(Map<String, dynamic> json) => AccountModel(
      json['dealer_idx'] as int?,
      json['state'] as int?,
      json['dealer_id'] as String?,
      json['dealer_password'] as String?,
      json['dealer_company'] as String?,
      json['dealer_name'] as String?,
      json['dealer_position'] as String?,
      json['dealer_phone'] as String?,
      json['dealer_company_img'] as String?,
      json['dealer_business_license'] as String?,
      json['dealer_alarm'] as int?,
      json['dealer_token'] as String?,
      json['dealer_createtime'] as String?,
      json['dealer_updatetime'] as String?,
    );

Map<String, dynamic> _$AccountModelToJson(AccountModel instance) =>
    <String, dynamic>{
      'dealer_idx': instance.dealer_idx,
      'state': instance.state,
      'dealer_id': instance.dealer_id,
      'dealer_password': instance.dealer_password,
      'dealer_company': instance.dealer_company,
      'dealer_name': instance.dealer_name,
      'dealer_position': instance.dealer_position,
      'dealer_phone': instance.dealer_phone,
      'dealer_company_img': instance.dealer_company_img,
      'dealer_business_license': instance.dealer_business_license,
      'dealer_alarm': instance.dealer_alarm,
      'dealer_token': instance.dealer_token,
      'dealer_createtime': instance.dealer_createtime,
      'dealer_updatetime': instance.dealer_updatetime,
    };
