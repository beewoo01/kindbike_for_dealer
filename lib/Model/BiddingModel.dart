
import 'package:json_annotation/json_annotation.dart';

part 'BiddingModel.g.dart';

@JsonSerializable()
class BiddingModel{

  int? product_idx;
  int? product_user_idx;
  int? product_state;
  String? product_manufacturer;
  String? product_model;
  String? product_year;
  String? product_mileage;
  String? product_image;
  String? product_detail;
  int? product_town_idx;
  String? product_endtime;
  String? city_name;
  String? town_name;

  int? buy_idx;
  int? buy_product_idx;
  int? buy_dealer_idx;
  int? buy_price;
  int? buy_state;
  String? buy_createtime;

  int? user_idx;
  String? user_id;
  String? user_name;
  String? user_phone;
  int? user_alarm;
  String? user_token;

  int? pay_idx;
  int? pay_buy_idx;
  int? pay_price;
  String? pay_detail;
  int? pay_state;

  String? dealer_id;
  String? dealer_name;
  String? dealer_phone;


  BiddingModel(
      this.product_idx,
      this.product_user_idx,
      this.product_state,
      this.product_manufacturer,
      this.product_model,
      this.product_year,
      this.product_mileage,
      this.product_image,
      this.product_detail,
      this.product_town_idx,
      this.product_endtime,
      this.city_name,
      this.town_name,
      this.buy_idx,
      this.buy_product_idx,
      this.buy_dealer_idx,
      this.buy_price,
      this.buy_state,
      this.buy_createtime,
      this.user_idx,
      this.user_id,
      this.user_name,
      this.user_phone,
      this.user_alarm,
      this.user_token,
      this.pay_idx,
      this.pay_buy_idx,
      this.pay_price,
      this.pay_detail,
      this.pay_state,
      this.dealer_id,
      this.dealer_name,
      this.dealer_phone);

  factory BiddingModel.fromJson(Map<String, dynamic> json) =>
      _$BiddingModelFromJson(json);

  Map<String, dynamic> toJson() => _$BiddingModelToJson(this);
}