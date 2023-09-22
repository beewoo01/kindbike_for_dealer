import 'package:json_annotation/json_annotation.dart';

part 'NoticeModel.g.dart';

@JsonSerializable()
class NoticeModel{

  int? notice_idx;
  int? notice_state;
  String? notice_title;
  String? notice_detail;
  String? notice_createtime;
  String? notice_updatetime;

  int? faq_idx;
  String? faq_title;
  String? faq_detail;


  NoticeModel(
      this.notice_idx,
      this.notice_state,
      this.notice_title,
      this.notice_detail,
      this.notice_createtime,
      this.notice_updatetime,
      this.faq_idx,
      this.faq_title,
      this.faq_detail);

  factory NoticeModel.fromJson(Map<String, dynamic> json) =>
      _$NoticeModelFromJson(json);

  Map<String, dynamic> toJson() => _$NoticeModelToJson(this);
}