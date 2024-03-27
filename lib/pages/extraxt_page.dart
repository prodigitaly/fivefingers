import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_archive/flutter_archive.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:zoom/pages/downloaded_files.dart';
import 'package:zoom/pages/webview_page.dart';

import '../data/models/pdf_model.dart';
import '../utils/app_const.dart';
import 'local_web_view_page.dart';

class ExtractPage extends StatefulWidget {
  String pathData;
  String title;

  ExtractPage({required this.pathData, required this.title});

  @override
  State<ExtractPage> createState() => _ExtractPageState();
}

class _ExtractPageState extends State<ExtractPage> {
  @override
  void initState() {
    requestPermission();
    extractZip(File(widget.pathData),
        progress: true, zipIncludesBaseDirectory: true);
    super.initState();
  }

  requestPermission() async {
    await Permission.storage.request();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        body: Center(
          child: GestureDetector(
            onTap: () {
              if (isUnzip) {
                getItem();
              }
            },
            child: Container(
              height: height * 0.06,
              width: width * 0.6,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.red.shade500,
                  borderRadius: BorderRadius.circular(width * 0.03)),
              child: Text(isUnzip ? 'Next' : "UnZipping...",
                  style: TextStyle(
                      fontSize: width * 0.034,
                      fontWeight: FontWeight.w500,
                      color: Colors.white)),
            ),
          )







          // Container(
          //   padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          //   child: ElevatedButton(
          //       onPressed: () async {
          //         if (isUnzip) {
          //           getItem();
          //         }
          //       },
          //       child: isUnzip
          //           ? const Text('Next')
          //           : const Text('UnZipping.......')),
          // ),
        ),
      ),
    );
  }

  String url = '';
  bool isUnzip = false;

  List<PdfProduct> _pdfList = [];
  bool isLoading = true;

  getItem() async {
    final box = await Hive.openBox<PdfProduct>('Pdfs');

    setState(() {
      _pdfList = box.values.toList();
    });

    if(box.isNotEmpty){
      final Map<dynamic, PdfProduct> pdfMap = box.toMap();
      pdfMap.forEach((key, value) {
        if (value.title.toString() != widget.title.toString()) {
          PdfProduct book =
              PdfProduct(id: widget.pathData, title: widget.title, link: url);

          addItem(book);
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LocalWebViewPage(path: url,isTeacher: false),
              ));
        } else {
          showAlertDialog(context, () {
            PdfProduct book =
                PdfProduct(id: widget.pathData, title: widget.title, link: url);

            addItem(book);
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LocalWebViewPage(path: url,isTeacher: false),
                ));
          });
        }
      });
    }else {
      PdfProduct book =
      PdfProduct(id: widget.pathData, title: widget.title, link: url);
      addItem(book);
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LocalWebViewPage(path: url,isTeacher: false),
          ));
    }

    setState(() {
      isLoading = false;
    });
    // log('wishlist ::: ' + _pdfList[0].toString());
  }

  showAlertDialog(BuildContext context, Function callBack) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("No"),
      onPressed: () {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => DownloadedFiles(),), (route) => false);
      },
    );
    Widget continueButton = TextButton(
      child: Text("Yes"),
      onPressed: () {
        callBack();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Alert"),
      content: const Text(
          'you have already downloaded this book you want download it again'),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  extractZip(File zipFile,
      {bool progress = false, bool zipIncludesBaseDirectory = false}) async {
    // final zipFile = File("/storage/sdcard0/Download/Shivay 1.zip");
    int index = widget.pathData.lastIndexOf('/');
    url = widget.pathData
        .replaceRange(index + 1, widget.pathData.length, 'zippedFiles');
    final destinationDir = Directory(url);
    if (!destinationDir.existsSync()) {
      destinationDir.createSync(recursive: true);
    }
    try {
      await ZipFile.extractToDirectory(
          zipFile: zipFile,
          destinationDir: destinationDir,
          onExtracting: progress
              ? (zipEntry, progress) {
                  if (progress == 100 && !isUnzip) {
                    setState(() {
                      isUnzip = true;
                    });
                  }
                  debugPrint('progress: ${progress.toStringAsFixed(1)}%');
                  /*debugPrint('name: ${zipEntry.name}');
                  debugPrint('isDirectory: ${zipEntry.isDirectory}');
                  debugPrint(
                      'modificationDate: ${zipEntry.modificationDate?.toLocal().toIso8601String()}');
                  debugPrint('uncompressedSize: ${zipEntry.uncompressedSize}');
                  debugPrint('compressedSize: ${zipEntry.compressedSize}');
                  debugPrint(
                      'compressionMethod: ${zipEntry.compressionMethod}');
                  debugPrint('crc: ${zipEntry.crc}');*/
                  return ZipFileOperation.includeItem;
                }
              : null);
    } catch (e) {
      debugPrint('Exception -> $e');
    }
    if (zipIncludesBaseDirectory) {
      _verifyFiles(Directory(destinationDir.path));
    } else {
      _verifyFiles(destinationDir);
    }
  }

  void _verifyFiles(Directory filesDir) {
    debugPrint("Verifying files at: ${filesDir.path}");
    final extractedItems = filesDir.listSync(recursive: true);
    for (final item in extractedItems) {
      debugPrint("extractedItem: ${item.path}");
    }
    debugPrint("File count: ${extractedItems.length}");
    // assert(extractedItems.whereType<File>().length == _dataFiles.length, "Invalid number of files");
    // for (final fileName in _dataFiles.keys) {
    //   final file = File('${filesDir.path}/$fileName');
    //   debugPrint("Verifying file: ${file.path}");
    //   assert(file.existsSync(), "File not found: ${file.path}");
    //   final content = file.readAsStringSync();
    //   assert(content == _dataFiles[fileName], "Invalid file content: ${file.path}");
    // }
    debugPrint("All files ok");
  }

  addItem(PdfProduct item) async {
    var box = await Hive.openBox<PdfProduct>('Pdfs');
    box.add(item);
  }
}
