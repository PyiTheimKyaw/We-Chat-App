import 'package:json_annotation/json_annotation.dart';
import 'package:the_we_chat_app_by_my_self/data/vos/message_vo.dart';
part 'moment_vo.g.dart';
@JsonSerializable()
class MomentVO {
    @JsonKey(name: 'id')
    int? id;
    @JsonKey(name: 'description')
    String? description;
    @JsonKey(name: 'post_file')
    String? postFile;
    @JsonKey(name: 'profile_picture')
    String? profilePicture;
    @JsonKey(name: 'user_name')
    String? userName;
    @JsonKey(name: 'file_type')
    String? fileType;
    @JsonKey(name: 'time_stamp')
    int? timeStamp;
    @JsonKey(name: 'user_id')
    String? userId;
    List<CommentVO>? comments;

    MomentVO(
      {required this.id,
      required this.description,
      required this.postFile,
      required this.profilePicture,
      required this.userName,required this.fileType,required this.timeStamp, this.userId,this.comments});

    factory MomentVO.fromJson(Map<String,dynamic> json) => _$MomentVOFromJson(json);
    Map<String,dynamic> toJson() => _$MomentVOToJson(this);
}