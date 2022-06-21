import 'package:json_annotation/json_annotation.dart';
part 'favourite_vo.g.dart';
@JsonSerializable()
class FavouriteVO{
  @JsonKey(name: 'id')
  String? id;
  @JsonKey(name: 'user_name')
  String? userName;

  FavouriteVO({this.id, this.userName});
  factory FavouriteVO.fromJson(Map<String,dynamic> json) => _$FavouriteVOFromJson(json);
  Map<String,dynamic> toJson() => _$FavouriteVOToJson(this);
}