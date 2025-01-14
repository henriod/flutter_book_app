import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutterbookapp/constants/color_constant.dart';
import 'package:flutterbookapp/screens/home_screen.dart';
import 'package:flutterbookapp/screens/selected_book_screen.dart';
class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}

void main() {
  HttpOverrides.global = new MyHttpOverrides();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        accentColor: kMainColor,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent
      ),
      home: HomeScreen(),
      routes: {
        "/homeScreen":(_)=>new HomeScreen()
      },
    );
  }
}
