import 'package:json_annotation/json_annotation.dart';
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

    MomentVO(
      {required this.id,
      required this.description,
      required this.postFile,
      required this.profilePicture,
      required this.userName});

    factory MomentVO.fromJson(Map<String,dynamic> json) => _$MomentVOFromJson(json);
    Map<String,dynamic> toJson() => _$MomentVOToJson(this);
}