import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zoom/pages/Auth/student%20_account_screen.dart';


import '../../utils/app_const.dart';
import '../../utils/theme_manager.dart';
import '../../pages/local_web_view_page.dart';
import '../downloaded_files.dart';

class ChooseUserTypeScreen extends StatefulWidget {
  const ChooseUserTypeScreen({Key? key}) : super(key: key);

  @override
  State<ChooseUserTypeScreen> createState() => _ChooseUserTypeScreenState();
}

class _ChooseUserTypeScreenState extends State<ChooseUserTypeScreen> {
  ThemeManager themeManager = ThemeManager();

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: themeManager.whiteColor,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/images/Background-2.jpg'),fit: BoxFit.fill),
        ),
        alignment: Alignment.center,
        padding: EdgeInsets.only(right: width * 0.05, left: width * 0.05),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Text("Choose your status",
              //     style: TextStyle(
              //         color: themeManager.blackColor,
              //         fontSize: width * 0.07,
              //         fontWeight: FontWeight.bold)),
              SizedBox(
                height: height * 0.05,
              ),
              GestureDetector(
                onTap: () async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  var isFirstTime = prefs.getString(firstTimeUser);
                  if (isFirstTime != null && isFirstTime == 'true') {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DownloadedFiles(),
                        ));
                  } else {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StudentAccountScreen(),
                        ));
                  }
                },
                child: Container(
                  height: height * 0.06,
                  width: width * 0.3,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(width * 0.02),
                    color: Colors.red,
                  ),
                  child: Text('Student', style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
                ),
              ),
              SizedBox(
                height: height * 0.03,
              ),
              GestureDetector(
                onTap: () {
                 /* Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TeacherLoginScreen(),
                      ));*/
                  Navigator.push(context, MaterialPageRoute(builder: (context) => LocalWebViewPage(path: 'http://websupport.fivefingers-edu.com/login.php',isTeacher: true),));
                },
                child: Container(
                  height: height * 0.06,
                  width: width * 0.3,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(width * 0.02),
                    color: Colors.red,
                  ),
                  child: Text('Teacher', style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
                ),
              ),
              SizedBox(
                height: height * 0.2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
