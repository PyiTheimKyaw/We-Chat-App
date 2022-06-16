import 'package:json_annotation/json_annotation.dart';
import 'package:the_we_chat_app_by_my_self/data/vos/contact_and_message_vo.dart';

part 'user_vo.g.dart';

@JsonSerializable()
class UserVO {
  @JsonKey(name: 'id')
  String? id;
  @JsonKey(name: 'user_name')
  String? userName;
  @JsonKey(name: 'profile_picture')
  String? profilePicture;
  @JsonKey(name: 'phone_number')
  String? phoneNumber;
  @JsonKey(name: 'email')
  String? email;
  @JsonKey(name: 'password')
  String? password;
  @JsonKey(name: 'qr_code')
  String? qrCode;
  @JsonKey(name: 'fcm_token')
  String? fcmToken;
  @JsonKey(name: 'conversation_list')
  List<ContactAndMessageVO>? conversationList;

  UserVO(
      {this.id,
      this.userName,
      this.profilePicture,
      this.phoneNumber,
      this.email,
      this.password,
      this.qrCode,
      this.fcmToken,
      this.conversationList});

  factory UserVO.fromJson(Map<String, dynamic> json) => _$UserVOFromJson(json);

  Map<String, dynamic> toJson() => _$UserVOToJson(this);
}
