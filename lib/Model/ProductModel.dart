
import 'package:json_annotation/json_annotation.dart';

part 'ProductModel.g.dart';

@JsonSerializable()
class ProductModel{

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
  String? product_createtime;
  String? product_updatetime;
  String? product_endtime;

  int? town_idx;
  int? town_city_idx;
  String? town_name;

  int? city_idx;
  String? city_name;

  int? count;


  ProductModel(
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
      this.product_createtime,
      this.product_updatetime,
      this.product_endtime,
      this.town_idx,
      this.town_city_idx,
      this.town_name,
      this.city_idx,
      this.city_name,
      this.count);

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductModelToJson(this);
}