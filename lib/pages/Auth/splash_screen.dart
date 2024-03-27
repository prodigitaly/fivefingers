import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zoom/pages/downloaded_files.dart';
import '../../utils/app_const.dart';
import '../../utils/theme_manager.dart';
import 'choose_user.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  ThemeManager themeManager = ThemeManager();

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        width: width,
        height: height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image(
              image: AssetImage("assets/images/Five Finger.png"),
              width: width,
              height: height * 0.3,
            )
          ],
        ),
      ),
    );
  }

  void startTimer() async {
    Timer(const Duration(seconds: 3), () async {

        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => const ChooseUserTypeScreen()));

    });
  }
}
