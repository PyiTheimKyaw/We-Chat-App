import 'package:json_annotation/json_annotation.dart';
part 'message_vo.g.dart';
@JsonSerializable()
class CommentVO{
  @JsonKey(name: 'id')
  int? id;
  @JsonKey(name: 'user_name')
  String? userName;
  @JsonKey(name: 'comment')
  String? comment;

  CommentVO({this.id, this.userName, this.comment});

  factory CommentVO.fromJson(Map<String,dynamic> json) => _$CommentVOFromJson(json);
  Map<String,dynamic> toJson() => _$CommentVOToJson(this);
}