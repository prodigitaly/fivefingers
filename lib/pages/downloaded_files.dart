import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zoom/pages/qr_code_scanner_page.dart';

import '../data/models/pdf_model.dart';
import '../utils/app_const.dart';
import 'local_web_view_page.dart';

class DownloadedFiles extends StatefulWidget {
  const DownloadedFiles({Key? key}) : super(key: key);

  @override
  State<DownloadedFiles> createState() => _DownloadedFilesState();
}

class _DownloadedFilesState extends State<DownloadedFiles> {
  List<PdfProduct> _pdfList = [];
  bool isLoading = true;

  getItem() async {
    final box = await Hive.openBox<PdfProduct>('Pdfs');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(firstTimeUser, 'true');
    setState(() {
      _pdfList = box.values.toList();
    });
    /*  final Map<dynamic, PdfProduct> pdfMap = box.toMap();
    pdfMap.forEach((key, value) {

    });*/

    setState(() {
      isLoading = false;
    });
    // log('wishlist ::: ' + _pdfList[0].toString());
  }

  @override
  void initState() {
    getItem();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.red,title: const Text('Your Books'),automaticallyImplyLeading: false, actions: [
        GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const QRCodeScannerPage(),
                  ));
            },
            child: const Padding(
              padding: EdgeInsets.only(right: 15.0),
              child: Icon(Icons.add),
            )),
      ]),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _pdfList.isEmpty
              ? const Center(
                  child: Text('No Books Available'),
                )
              : Container(
                  height: MediaQuery.of(context).size.height * 0.6,
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                    itemCount: _pdfList.length,
                    itemBuilder: (context, index) => Container(
                      padding: EdgeInsets.all(
                          MediaQuery.of(context).size.width * 0.06),
                      child: Container(
                        height: height * 0.08,
                        padding: EdgeInsets.only(
                            top: height * 0.01,
                            bottom: height * 0.01,
                            left: width * 0.03,
                            right: width * 0.03),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.circular(width * 0.02),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                blurRadius: 5.0,
                              ),
                            ]),
                        child: Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              Image(
                                  image:
                                      AssetImage("assets/images/book.png"),
                                  height: height * 0.06),
                              Container(
                                width: width * 0.4,
                                alignment: Alignment.center,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.center,
                                  children: [
                                    Text(_pdfList[index].title!,
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black)),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              LocalWebViewPage(
                                                  path: _pdfList[index]
                                                      .link!,
                                              isTeacher: false),
                                        ));
                                  },
                                  child: Container(
                                    height: height * 0.04,
                                    width: width * 0.2,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: Colors.red.shade500,
                                        borderRadius: BorderRadius.circular(
                                            width * 0.03)),
                                    child: Text("Play",
                                        style: TextStyle(
                                            fontSize: height * 0.014,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white)),
                                  )),
                            ]),
                      ),
                    ),
                  ),
                ),
    );
  }
}
