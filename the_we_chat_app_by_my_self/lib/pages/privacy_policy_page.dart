import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';
import 'package:the_we_chat_app_by_my_self/blocs/privacy_page_bloc.dart';
import 'package:the_we_chat_app_by_my_self/rescources/colors.dart';
import 'package:the_we_chat_app_by_my_self/rescources/dimens.dart';
import 'package:the_we_chat_app_by_my_self/rescources/strings.dart';
import 'package:the_we_chat_app_by_my_self/utils/extensions.dart';

class PrivacyPolicyPage extends StatelessWidget {
  PrivacyPolicyPage({Key? key, required this.mdFileName})
      : assert(mdFileName.contains(".md"), 'Privacy Policy'),
        super(key: key);

  final String mdFileName;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => PrivacyPageBloc(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: BACKGROUND_COLOR,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.close_outlined,
                color: Colors.black,
              )),
          title: const Text(
            PRIVACY_POLICY,
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Container(
          color: Colors.white,
          child: Column(
            children: [
              PrivacyPolicyTextSectionView(mdFileName: mdFileName),
              const AcceptPolicyAndNextButtonSectionView(),
            ],
          ),
        ),
      ),
    );
  }
}

class PrivacyPolicyTextSectionView extends StatelessWidget {
  const PrivacyPolicyTextSectionView({Key? key, required this.mdFileName})
      : super(key: key);
  final String mdFileName;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: FutureBuilder(
            future: Future.delayed(const Duration(milliseconds: 1500))
                .then((value) {
              return rootBundle.loadString('assets/$mdFileName');
            }),
            builder: (context, snapShot) {
              if (snapShot.hasData) {
                return Markdown(data: snapShot.data.toString());
              }
              return const Center(child: CircularProgressIndicator());
            }));
  }
}

class AcceptPolicyAndNextButtonSectionView extends StatelessWidget {
  const AcceptPolicyAndNextButtonSectionView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<PrivacyPageBloc>(
      builder: (BuildContext context, bloc, Widget? child) {
        return Container(
          color: BACKGROUND_COLOR,
          height: 100,
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Radio(
                      fillColor: MaterialStateColor.resolveWith(
                          (states) => BUTTON_COLOR),
                      value: 1,
                      groupValue: bloc.val,
                      toggleable: true,
                      onChanged: (value) {
                        bloc.acceptPolicy(value);
                      }),
                  const Text("I have read and accept the above terms"),
                ],
              ),
              MaterialButton(
                minWidth: 200,
                color: (bloc.val == 1) ? BUTTON_COLOR : Colors.white70,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(MARGIN_SMALL - 4),
                ),
                onPressed: () {
                  if (bloc.val == 1) {
                    print("Tap at privacy ");
                  } else {
                    showSnackBarWithMessage(
                        context, "Please accept the privacy policy");
                  }
                },
                child: Text(
                  NEXT,
                  style: TextStyle(
                      fontSize: TEXT_REGULAR,
                      color: (bloc.val == 1) ? Colors.white : Colors.black12),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
