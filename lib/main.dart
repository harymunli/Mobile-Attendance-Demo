import 'package:flutter/material.dart';
import 'package:mobile_attendance_demo/ui/home.dart';
import 'package:mobile_attendance_demo/ui/pick_offfice.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: "/home",
      routes: {
        "/home": (context) => Home(),
        "/pick-office": (context) => PickOffice()
      },
    );
  }
}
