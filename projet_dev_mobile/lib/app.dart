import 'package:flutter/material.dart';
import 'package:projet_dev_mobile/screen/Profile_screen.dart';
import 'package:projet_dev_mobile/screen/home_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ProfilePage(),
    );
  }
}