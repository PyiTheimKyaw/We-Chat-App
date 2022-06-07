import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:the_we_chat_app_by_my_self/rescources/colors.dart';
import 'package:the_we_chat_app_by_my_self/rescources/dimens.dart';
import 'package:the_we_chat_app_by_my_self/rescources/strings.dart';

class MomentPage extends StatelessWidget {
  const MomentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: PRIMARY_COLOR,
        automaticallyImplyLeading: true,
        leadingWidth: 90,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Row(
            children: const [
              Icon(
                Icons.chevron_left,
                size: TEXT_LARGE,
              ),
              Text(
                LABEL_WECHAT,
                style:
                    TextStyle(color: Colors.white60, fontSize: MARGIN_MEDIUM_2),
              ),
            ],
          ),
        ),
        title: const Text(LABEL_MOMENTS),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.person_outline_outlined),
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            GestureDetector(
              onTap: ()async{
                final ImagePicker _picker = ImagePicker();
                final XFile? image = await _picker.pickImage(
                    source: ImageSource.gallery);
              },
              child: Container(
                height: MediaQuery.of(context).size.height / 3,
                color: Colors.black38,
                child: const Center(
                  child: const Text(TAP_TO_CHANGE_COVER),
                ),
              ),
            ),
            Expanded(
                child: Container(
              height: MediaQuery.of(context).size.height / 2,
              color: Colors.white,
            )),
          ],
        ),
      ),
    );
  }
}
