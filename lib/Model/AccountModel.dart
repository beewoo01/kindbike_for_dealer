import 'package:json_annotation/json_annotation.dart';

part 'AccountModel.g.dart';

@JsonSerializable()
class AccountModel{ //수정후 flutter pub run build_runner build
  int? dealer_idx;
  int? state;
  String? dealer_id;
  String? dealer_password;
  String? dealer_company;
  String? dealer_name;
  String? dealer_position;
  String? dealer_phone;
  String? dealer_company_img;
  String? dealer_business_license;
  int? dealer_alarm;
  String? dealer_token;
  String? dealer_createtime;
  String? dealer_updatetime;


  AccountModel(
      this.dealer_idx,
      this.state,
      this.dealer_id,
      this.dealer_password,
      this.dealer_company,
      this.dealer_name,
      this.dealer_position,
      this.dealer_phone,
      this.dealer_company_img,
      this.dealer_business_license,
      this.dealer_alarm,
      this.dealer_token,
      this.dealer_createtime,
      this.dealer_updatetime);

  factory AccountModel.fromJson(Map<String, dynamic> json) =>
      _$AccountModelFromJson(json);

  Map<String, dynamic> toJson() => _$AccountModelToJson(this);
}