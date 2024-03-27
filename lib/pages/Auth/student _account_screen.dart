import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:zoom/pages/downloaded_files.dart';

import '../../utils/app_const.dart';
import '../../utils/theme_manager.dart';

class StudentAccountScreen extends StatefulWidget {
  const StudentAccountScreen({Key? key}) : super(key: key);

  @override
  State<StudentAccountScreen> createState() => _StudentAccountScreenState();
}

class _StudentAccountScreenState extends State<StudentAccountScreen> {
  ThemeManager themeManager = ThemeManager();
  TextEditingController nameController = TextEditingController();
  TextEditingController classController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  Dio dio = Dio();
  bool isValid = true;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: themeManager.whiteColor,
      body: Container(
        // decoration: BoxDecoration(
        //   image: DecorationImage(
        //       image: AssetImage('assets/images/Background.jpg'),
        //       fit: BoxFit.fill),
        // ),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(clipBehavior: Clip.none,children: [
                Image(image: AssetImage("assets/images/Background.jpg")),
                Container(
                  padding:
                  EdgeInsets.only(right: width * 0.05, left: width * 0.05,top: height*0.38),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [

                      Text("Create Your Account",
                          style: TextStyle(
                              color: themeManager.blackColor,
                              fontSize: width * 0.07,
                              fontWeight: FontWeight.bold)),
                      SizedBox(
                        height: height * 0.03,
                      ),
                      TextFormField(
                        controller: nameController,
                        style: TextStyle(
                            fontSize: width * 0.034,
                            color: themeManager.blackColor),
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: width * 0.06),
                            hintText: "Enter Name",
                            hintStyle: TextStyle(
                                fontSize: width * 0.034,
                                color: themeManager.blackColor),
                            fillColor: themeManager.whiteColor,
                            filled: true),
                      ),
                      SizedBox(
                        height: height * 0.03,
                      ),
                      TextFormField(
                        controller: emailController,
                        style: TextStyle(
                            fontSize: width * 0.034,
                            color: themeManager.blackColor),
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: width * 0.06),
                            hintText: "Enter your email",
                            hintStyle: TextStyle(
                                fontSize: width * 0.034,
                                color: themeManager.blackColor),
                            fillColor: themeManager.whiteColor,
                            filled: true),
                      ),
                      SizedBox(
                        height: height * 0.03,
                      ),
                      TextFormField(
                        controller: mobileController,
                        style: TextStyle(
                            fontSize: width * 0.034,
                            color: themeManager.blackColor),
                        keyboardType: TextInputType.number,
                        maxLength: 10,
                        decoration: InputDecoration(
                            counterText: '',
                            contentPadding: EdgeInsets.only(
                              left: width * 0.06,
                            ),
                            hintText: "Enter Mobile Number",
                            hintStyle: TextStyle(
                                fontSize: width * 0.034,
                                color: themeManager.blackColor),
                            fillColor: themeManager.whiteColor,
                            filled: true),
                      ),
                      SizedBox(
                        height: height * 0.03,
                      ),
                      TextFormField(
                        controller: classController,
                        style: TextStyle(
                            fontSize: width * 0.034,
                            color: themeManager.blackColor),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left: width * 0.06),
                          hintText: "Enter Class",
                          hintStyle: TextStyle(
                              fontSize: width * 0.034,
                              color: themeManager.blackColor),
                          fillColor: themeManager.whiteColor,
                          filled: true,
                          // enabledBorder: OutlineInputBorder(
                          //   borderSide: BorderSide(width: 3, color: themeManager.whiteColor),
                          //   //<-- SEE HERE
                          //   borderRadius: BorderRadius.circular(60),
                          // ),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.03,
                      ),
                      GestureDetector(
                        onTap: () {
                          if (!isLoading) {
                            setState(() {
                              isValid = true;
                            });
                            if (nameController.text.isEmpty ||
                                classController.text.isEmpty) {
                              Fluttertoast.showToast(
                                  msg: 'please fill data to continue');
                              setState(() {
                                isValid = false;
                              });
                            } else if (mobileController.text.length != 10) {
                              setState(() {
                                isValid = false;
                              });
                              Fluttertoast.showToast(
                                  msg: 'please enter valid mobile number');
                            } else if (!(RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(emailController.text))) {
                              setState(() {
                                isValid = false;
                              });
                              Fluttertoast.showToast(
                                  msg: 'please enter valid email address');
                            }
                            if (isValid) {
                              loginStudent();
                            }
                          }
                        },
                        child: Container(
                          height: height * 0.06,
                          width: width * 0.4,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Colors.red.shade500,
                              borderRadius:
                              BorderRadius.circular(width * 0.03)),
                          child: Text(isLoading ? 'Loading.....' : "Save",
                              style: TextStyle(
                                  fontSize: height * 0.022,
                                  fontWeight: FontWeight.bold,
                                  color: themeManager.whiteColor)),
                        ),
                      )
                    ],
                  ),
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  void loginStudent() async {
    try {
      setState(() {
        isLoading = true;
      });
      var res = await dio.post(
          'http://websupport.fivefingers-edu.com/r_api/student_reg_api.php',
          data: {
            'name': nameController.text,
            'email': emailController.text,
            'mobile': mobileController.text,
            'class': classController.text,
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
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: 'Login failed, try again');
    }
  }
}
