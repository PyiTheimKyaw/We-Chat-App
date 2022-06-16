// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserVO _$UserVOFromJson(Map<String, dynamic> json) => UserVO(
      id: json['id'] as String?,
      userName: json['user_name'] as String?,
      profilePicture: json['profile_picture'] as String?,
      phoneNumber: json['phone_number'] as String?,
      email: json['email'] as String?,
      password: json['password'] as String?,
      qrCode: json['qr_code'] as String?,
      fcmToken: json['fcm_token'] as String?,
      conversationList: (json['conversation_list'] as List<dynamic>?)
          ?.map((e) => ContactAndMessageVO.fromJson(e as Map<String, dynamic>))
          .toList(),
      lastMessage: json['lastMessage'] as String?,
    );

Map<String, dynamic> _$UserVOToJson(UserVO instance) => <String, dynamic>{
      'id': instance.id,
      'user_name': instance.userName,
      'profile_picture': instance.profilePicture,
      'phone_number': instance.phoneNumber,
      'email': instance.email,
      'password': instance.password,
      'qr_code': instance.qrCode,
      'fcm_token': instance.fcmToken,
      'conversation_list': instance.conversationList,
      'lastMessage': instance.lastMessage,
    };
