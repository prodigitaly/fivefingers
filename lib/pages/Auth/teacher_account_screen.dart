import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:zoom/pages/downloaded_files.dart';

import '../../utils/app_const.dart';
import '../../utils/theme_manager.dart';
import 'package:dio/dio.dart';

class TeacherLoginScreen extends StatefulWidget {
  const TeacherLoginScreen({Key? key}) : super(key: key);

  @override
  State<TeacherLoginScreen> createState() => _TeacherLoginScreenState();
}

class _TeacherLoginScreenState extends State<TeacherLoginScreen> {
  ThemeManager themeManager = ThemeManager();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Dio dio = Dio();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: themeManager.whiteColor,
      body: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(right: width * 0.05, left: width * 0.05),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Create Your Account",
                  style: TextStyle(
                      color: themeManager.blackColor,
                      fontSize: width * 0.06,
                      fontWeight: FontWeight.bold)),
              SizedBox(
                height: height * 0.05,
              ),
              TextFormField(
                controller: nameController,
                style: TextStyle(fontSize: width * 0.034, color: Colors.black),
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: width * 0.06),
                    hintText: "Enter Name",
                    hintStyle: TextStyle(fontSize: width * 0.034),
                    fillColor: Colors.red.shade300,
                    filled: true),
              ),
              SizedBox(
                height: height * 0.03,
              ),
              TextFormField(
                controller: passwordController,
                style: TextStyle(fontSize: width * 0.034, color: Colors.black),
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: width * 0.06),
                    hintText: "Enter Your Password",
                    hintStyle: TextStyle(fontSize: width * 0.034),
                    fillColor: Colors.red.shade300,
                    filled: true),
              ),
              SizedBox(
                height: height * 0.03,
              ),
              GestureDetector(
                onTap: () {
                  if (nameController.text.isNotEmpty &&
                      passwordController.text.isNotEmpty) {
                    loginTeacher();
                  } else {
                    Fluttertoast.showToast(
                        msg: 'Please add your Id and Password for continue.');
                  }
                },
                child: Container(
                  height: height * 0.06,
                  width: width * 0.4,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.red.shade500,
                      borderRadius: BorderRadius.circular(width * 0.03)),
                  child: Text(isLoading ? 'Loading...' : "Save",
                      style: TextStyle(
                          fontSize: height * 0.022,
                          fontWeight: FontWeight.bold,
                          color: themeManager.whiteColor)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void loginTeacher() async {
    try {
      setState(() {
        isLoading = true;
      });
      var res = await dio.post(
          'http://websupport.fivefingers-edu.com/r_api/login_api_v1.php',
          data: {
            'username': nameController.text,
            'password': passwordController.text
          });

      if (res.statusCode == 200 || res.statusCode == 201) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const DownloadedFiles(),
            ),
            (Route<dynamic> route) => false);
        Fluttertoast.showToast(msg: res.data['message']);
      } else {
        Fluttertoast.showToast(msg: res.data['message']);
      }
      setState(() {
        isLoading = false;
      });
    } on Exception catch (e) {
      Fluttertoast.showToast(msg: 'Login failed.');
      setState(() {
        isLoading = false;
      });
    }
  }
}
