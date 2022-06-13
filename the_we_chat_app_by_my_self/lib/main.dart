import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:the_we_chat_app_by_my_self/pages/privacy_policy_page.dart';
import 'package:the_we_chat_app_by_my_self/pages/welcome_page.dart';
import 'package:the_we_chat_app_by_my_self/pages/start_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:  const WelcomePage(),
    );
  }
}
