import 'package:json_annotation/json_annotation.dart';
part 'contact_and_message_vo.g.dart';
@JsonSerializable()
class ContactAndMessageVO {
  @JsonKey(name: 'file')
  String? file;
  @JsonKey(name: 'messages')
  String? messages;
  @JsonKey(name: 'user_name')
  String? userName;
  @JsonKey(name: 'profile_picture')
  String? profilePicture;
  @JsonKey(name: 'time_stamp')
  int? timeStamp;
  @JsonKey(name: 'id')
  String? id;
  @JsonKey(name: 'file_type')
  String? fileType;

  ContactAndMessageVO({
    this.file,
    this.messages,
    this.userName,
    this.profilePicture,
    this.timeStamp,
    this.id,
    this.fileType,
  });

  factory ContactAndMessageVO.fromJson(Map<String, dynamic> json) =>
      _$ContactAndMessageVOFromJson(json);

  Map<String, dynamic> toJson() => _$ContactAndMessageVOToJson(this);
}
