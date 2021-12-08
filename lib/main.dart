import 'package:eventy_front/navigation/navigation.dart';
import 'package:flutter/material.dart';
import 'components/pages/login/login.dart';
import 'components/root.dart';
import 'package:eventy_front/persistence/my_shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  //final primaryBlue = Color.fromARGB(255, 204, 234, 253);

  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  bool isLoggedIn = false;
  MyAppState() {
    MySharedPreferences.instance
        .getBooleanValue("isLoggedIn")
        .then((value) => setState(() {
              isLoggedIn = value;
            }));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'FirsNeue', primaryColor: Colors.black),
      title: 'OnPoint',
      home: (isLoggedIn)
          ? Root(selectedPage: EventsNavigation.NAV_HOME)
          : LoginPage(),
    );
  }
}
