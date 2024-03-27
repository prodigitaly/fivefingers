import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:zoom/pages/Auth/splash_screen.dart';
import 'package:zoom/pages/downloaded_files.dart';
import '../app/constant/color_constant.dart';
import '../app/widgets/app_theme.dart';

import 'data/models/pdf_model.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  Directory directory = await pathProvider.getApplicationDocumentsDirectory();

  Hive.init(directory.path);
  Hive.registerAdapter(PdfProductAdapter());
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: ZoomColorConstants.appWhite,
      statusBarColor: ZoomColorConstants.appPrimaryThemeColor,
      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Five Fingers Education',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.themeData,
      // home: const QRCodeScannerPage(),
      home:  const SplashScreen(),
    );
  }
}



