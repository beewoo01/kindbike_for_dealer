// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ProductModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductModel _$ProductModelFromJson(Map<String, dynamic> json) => ProductModel(
      json['product_idx'] as int?,
      json['product_user_idx'] as int?,
      json['product_state'] as int?,
      json['product_manufacturer'] as String?,
      json['product_model'] as String?,
      json['product_year'] as String?,
      json['product_mileage'] as String?,
      json['product_image'] as String?,
      json['product_detail'] as String?,
      json['product_town_idx'] as int?,
      json['product_createtime'] as String?,
      json['product_updatetime'] as String?,
      json['product_endtime'] as String?,
      json['town_idx'] as int?,
      json['town_city_idx'] as int?,
      json['town_name'] as String?,
      json['city_idx'] as int?,
      json['city_name'] as String?,
      json['count'] as int?,
    );

Map<String, dynamic> _$ProductModelToJson(ProductModel instance) =>
    <String, dynamic>{
      'product_idx': instance.product_idx,
      'product_user_idx': instance.product_user_idx,
      'product_state': instance.product_state,
      'product_manufacturer': instance.product_manufacturer,
      'product_model': instance.product_model,
      'product_year': instance.product_year,
      'product_mileage': instance.product_mileage,
      'product_image': instance.product_image,
      'product_detail': instance.product_detail,
      'product_town_idx': instance.product_town_idx,
      'product_createtime': instance.product_createtime,
      'product_updatetime': instance.product_updatetime,
      'product_endtime': instance.product_endtime,
      'town_idx': instance.town_idx,
      'town_city_idx': instance.town_city_idx,
      'town_name': instance.town_name,
      'city_idx': instance.city_idx,
      'city_name': instance.city_name,
      'count': instance.count,
    };
