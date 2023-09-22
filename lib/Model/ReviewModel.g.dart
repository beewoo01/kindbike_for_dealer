// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ReviewModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReviewModel _$ReviewModelFromJson(Map<String, dynamic> json) => ReviewModel(
      json['dealer_review_idx'] as int?,
      json['dealer_review_buy_idx'] as int?,
      json['dealer_review_rating'] as String?,
      json['dealer_review_detail'] as String?,
      json['dealer_review_createtime'] as String?,
      json['dealer_review_updatetime'] as String?,
      json['buy_dealer_idx'] as int?,
      json['product_model'] as String?,
      json['product_image'] as String?,
      json['pay_price'] as int?,
      json['pay_detail'] as String?,
    );

Map<String, dynamic> _$ReviewModelToJson(ReviewModel instance) =>
    <String, dynamic>{
      'dealer_review_idx': instance.dealer_review_idx,
      'dealer_review_buy_idx': instance.dealer_review_buy_idx,
      'dealer_review_rating': instance.dealer_review_rating,
      'dealer_review_detail': instance.dealer_review_detail,
      'dealer_review_createtime': instance.dealer_review_createtime,
      'dealer_review_updatetime': instance.dealer_review_updatetime,
      'buy_dealer_idx': instance.buy_dealer_idx,
      'product_model': instance.product_model,
      'product_image': instance.product_image,
      'pay_price': instance.pay_price,
      'pay_detail': instance.pay_detail,
    };
