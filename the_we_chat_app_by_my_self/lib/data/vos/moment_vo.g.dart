// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moment_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MomentVO _$MomentVOFromJson(Map<String, dynamic> json) => MomentVO(
      id: json['id'] as int?,
      description: json['description'] as String?,
      postFile: json['post_file'] as String?,
      profilePicture: json['profile_picture'] as String?,
      userName: json['user_name'] as String?,
      fileType: json['file_type'] as String?,
      timeStamp: json['time_stamp'] as int?,
      userId: json['user_id'] as String?,
      comments: (json['comments'] as List<dynamic>?)
          ?.map((e) => CommentVO.fromJson(e as Map<String, dynamic>))
          .toList(),
      favourites: (json['favourites'] as List<dynamic>?)
          ?.map((e) => FavouriteVO.fromJson(e as Map<String, dynamic>))
          .toList(),
      isReacted: json['isReacted'] as bool? ?? false,
    );

Map<String, dynamic> _$MomentVOToJson(MomentVO instance) => <String, dynamic>{
      'id': instance.id,
      'description': instance.description,
      'post_file': instance.postFile,
      'profile_picture': instance.profilePicture,
      'user_name': instance.userName,
      'file_type': instance.fileType,
      'time_stamp': instance.timeStamp,
      'user_id': instance.userId,
      'comments': instance.comments,
      'favourites': instance.favourites,
      'isReacted': instance.isReacted,
    };
