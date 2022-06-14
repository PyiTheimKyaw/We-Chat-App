import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:the_we_chat_app_by_my_self/rescources/dimens.dart';

class TextFieldView extends StatelessWidget {
  const TextFieldView({
    Key? key,
    required this.prefixText,
    this.isPassword = false,
    this.isPhone = false,
    required this.hintText,
    required this.onChanged,
    this.onTapUnSecure,
    this.isUnsecure = false,
  }) : super(key: key);
  final String prefixText;
  final String hintText;
  final bool isPassword;
  final bool isPhone;
  final Function(String) onChanged;
  final Function? onTapUnSecure;
  final bool isUnsecure;

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: isPhone ? TextInputType.number : null,
      inputFormatters: [
        (isPhone)
            ? FilteringTextInputFormatter.digitsOnly
            : FilteringTextInputFormatter.singleLineFormatter
      ],
      obscureText: (isPassword)
          ? (isUnsecure)
          ? true
          : false
          : false,
      decoration: InputDecoration(
        border: const OutlineInputBorder(borderSide: BorderSide.none),
        hintText: hintText,
        isDense: true,
        prefixIcon: Text(
          prefixText,
          style: const TextStyle(fontSize: MARGIN_MEDIUM_2),
        ),
        prefixIconConstraints:
        const BoxConstraints(minWidth: 100, minHeight: 0),
        suffixIcon: Visibility(
          visible: isPassword,
          child: IconButton(
            onPressed: () {
              onTapUnSecure!();
            },
            icon: Icon(
                (isUnsecure) ? Icons.remove_red_eye_outlined : Icons.security),
          ),
        ),
      ),
      onChanged: (text) {
        onChanged(text);
      },
    );
  }
}