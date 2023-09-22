import 'package:json_annotation/json_annotation.dart';

part 'AlarmModel.g.dart';

@JsonSerializable()
class AlarmModel{ //수정후 flutter pub run build_runner build
  int? alarm_dealer_idx;
  int? alarm_dealer_dealer_idx;
  String? alarm_dealer_detail;
  int? alarm_dealer_isRead;
  String? alarm_dealer_updatetime;
  String? alarm_dealer_createtime;


  AlarmModel(
      this.alarm_dealer_idx,
      this.alarm_dealer_dealer_idx,
      this.alarm_dealer_detail,
      this.alarm_dealer_isRead,
      this.alarm_dealer_updatetime,
      this.alarm_dealer_createtime);

  factory AlarmModel.fromJson(Map<String, dynamic> json) =>
      _$AlarmModelFromJson(json);

  Map<String, dynamic> toJson() => _$AlarmModelToJson(this);
}