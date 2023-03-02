import 'package:flutter/material.dart';
import 'package:zwalpa/ui/user_details_update.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: const Color(0xff000000),
          backgroundColor: const Color(0xff222222),
          primaryColor: const Color(0xff852CFF)),
      home: const UserDetailUpdateScreen(),
    );
  }
}
