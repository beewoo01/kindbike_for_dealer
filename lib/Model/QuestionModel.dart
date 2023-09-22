import 'package:json_annotation/json_annotation.dart';

part 'QuestionModel.g.dart';

@JsonSerializable()
class QuestionModel{

  int? question_idx;
  int? question_state;
  int? question_people_idx;
  String? question_title;
  String? question_detail;
  String? question_createtime;
  String? question_updatetime;

  int? question_answer_idx;
  int? question_answer_question_idx;
  String? question_answer_detail;
  String? question_answer_createtime;
  String? question_answer_updatetime;


  QuestionModel(
      this.question_idx,
      this.question_state,
      this.question_people_idx,
      this.question_title,
      this.question_detail,
      this.question_createtime,
      this.question_updatetime,
      this.question_answer_idx,
      this.question_answer_question_idx,
      this.question_answer_detail,
      this.question_answer_createtime,
      this.question_answer_updatetime);

  factory QuestionModel.fromJson(Map<String, dynamic> json) =>
      _$QuestionModelFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionModelToJson(this);
}