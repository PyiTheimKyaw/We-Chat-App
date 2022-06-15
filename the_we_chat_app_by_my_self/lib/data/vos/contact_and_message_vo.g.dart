// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_and_message_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContactAndMessageVO _$ContactAndMessageVOFromJson(Map<String, dynamic> json) =>
    ContactAndMessageVO(
      file: json['file'] as String?,
      messages: json['messages'] as String?,
      userName: json['user_name'] as String?,
      profilePicture: json['profile_picture'] as String?,
      timeStamp: json['time_stamp'] as int?,
      id: json['id'] as String?,
      fileType: json['file_type'] as String?,
    );

Map<String, dynamic> _$ContactAndMessageVOToJson(
        ContactAndMessageVO instance) =>
    <String, dynamic>{
      'file': instance.file,
      'messages': instance.messages,
      'user_name': instance.userName,
      'profile_picture': instance.profilePicture,
      'time_stamp': instance.timeStamp,
      'id': instance.id,
      'file_type': instance.fileType,
    };
