import 'package:json_annotation/json_annotation.dart';

part 'ReviewModel.g.dart';

@JsonSerializable()
class ReviewModel{ //수정후 flutter pub run build_runner build

  int? dealer_review_idx;
  int? dealer_review_buy_idx;
  String? dealer_review_rating;
  String? dealer_review_detail;
  String? dealer_review_createtime;
  String? dealer_review_updatetime;

  int? buy_dealer_idx;
  String? product_model;
  String? product_image;
  int? pay_price;
  String? pay_detail;


  ReviewModel(
      this.dealer_review_idx,
      this.dealer_review_buy_idx,
      this.dealer_review_rating,
      this.dealer_review_detail,
      this.dealer_review_createtime,
      this.dealer_review_updatetime,
      this.buy_dealer_idx,
      this.product_model,
      this.product_image,
      this.pay_price,
      this.pay_detail);

  factory ReviewModel.fromJson(Map<String, dynamic> json) =>
      _$ReviewModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReviewModelToJson(this);
}