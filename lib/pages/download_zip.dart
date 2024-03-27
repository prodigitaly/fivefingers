import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'extraxt_page.dart';

class DownloadZip extends StatefulWidget {
  final Barcode scanData;

  const DownloadZip({Key? key, required this.scanData}) : super(key: key);

  @override
  State<DownloadZip> createState() => _DownloadZipState();
}

class _DownloadZipState extends State<DownloadZip> {
  Dio dio = Dio();
  double loadCount = 0;
  String fullPath = '';
  String fileName = '';
  String? zipPath;
  String? localZipFileName;

  @override
  void initState() {
    super.initState();
    getHtml();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('scanData -> ${widget.scanData}');
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Please wait your file is downloading..."),
                SizedBox(height: 10,),
                CircularPercentIndicator(
                  backgroundColor: Colors.blueGrey,
                  radius: 45.0,
                  lineWidth: 5.0,
                  percent: loadCount,
                  center: Text('${(loadCount * 100).toStringAsFixed(2)} %',
                      style: const TextStyle(color: Colors.black)),
                  progressColor: Colors.red,
                ),
              ],
            ),
          )),
    );
  }

  void getHtml() async {
    /// here it is coming as PermissionStatus.granted
    // if (!(await Permission.manageExternalStorage.isGranted)) {
    //   await Permission.manageExternalStorage.request();
    // }
    if (!(await Permission.storage.isGranted)) {
      await Permission.storage.request();
    }
    if (!(await Permission.accessMediaLocation.isGranted)) {
      await Permission.accessMediaLocation.request();
    }
    print("PERMISSION STORAGE: ${await Permission.storage.status}");
    // print(
    //     "PERMISSION EXTERNAL STORAGE: ${await Permission.manageExternalStorage.status}");
    print(
        "PERMISSION MEDIA LOCATION : ${await Permission.accessMediaLocation
            .status}");
    print("Fetching.....");

    var data = await dio.get(widget.scanData.code!);

    String str = data.toString();
    setState(() {});

    const start = "<a href=\"";
    const end = "\" download";

    final startIndex = str.indexOf(start);
    final endIndex = str.indexOf(end, startIndex + start.length);
    var tempDir = await getTemporaryDirectory();

    fileName = str.substring(startIndex + start.length, endIndex);

    fullPath =
    '${tempDir.path}/${str.substring(startIndex + start.length, endIndex)}';

    await File(fullPath).create().then((value) async {
      int index = widget.scanData.code!.lastIndexOf('/');
      String url = widget.scanData.code!.replaceRange(
          index + 1,
          widget.scanData.code!.length,
          str.substring(startIndex + start.length, endIndex));
      if (mounted) {
        download2(dio, url, fullPath);
      }
    });
  }

  Future download2(Dio dio, String url, String savePath) async {
    try {
      Response response = await dio.get(
        url,
        onReceiveProgress: showDownloadProgress,
        //Received data with List<int>
        options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            validateStatus: (status) {
              return status! < 500;
            }),
      );

      File file = File(savePath);
      var raf = file.openSync(mode: FileMode.write);

      raf.writeFromSync(response.data);
      await raf.close();
    } catch (e) {
      print(e);
    }
  }

  Future<void> showDownloadProgress(received, total) async {
    if (total != -1) {
      print((received / total * 100).toStringAsFixed(0) + "%");
      setState(() {
        loadCount = (received / total);
      });
    }
    if ((received / total * 100) >= 100) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  ExtractPage(
                    pathData: fullPath,
                    title: fileName,
                  )));
    }
  }
}
