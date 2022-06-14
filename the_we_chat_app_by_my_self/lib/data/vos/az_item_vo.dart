import 'package:azlistview/azlistview.dart';
import 'package:the_we_chat_app_by_my_self/data/vos/user_vo.dart';

class AZItemVO extends ISuspensionBean {

  final UserVO person;
  final String tag;

  AZItemVO({
    required this.person,
    required this.tag,
  });

  @override
  String getSuspensionTag() => tag;



}