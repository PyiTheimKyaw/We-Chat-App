// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommentVO _$CommentVOFromJson(Map<String, dynamic> json) => CommentVO(
      id: json['id'] as int?,
      userName: json['user_name'] as String?,
      comment: json['comment'] as String?,
    );

Map<String, dynamic> _$CommentVOToJson(CommentVO instance) => <String, dynamic>{
      'id': instance.id,
      'user_name': instance.userName,
      'comment': instance.comment,
    };
