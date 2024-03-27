import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zoom/pages/webview_page.dart';

import '../utils/app_const.dart';
import 'download_zip.dart';

class QRCodeScannerPage extends StatefulWidget {
  const QRCodeScannerPage({Key? key}) : super(key: key);

  @override
  State<QRCodeScannerPage> createState() => _QRCodeScannerPageState();
}

class _QRCodeScannerPageState extends State<QRCodeScannerPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  bool isFlash = false;
  bool isCameraPause = false;
  bool isStartScan = true;

  @override
  Future<void> reassemble() async {
    super.reassemble();

    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(Icons.arrow_back_ios)),
          title: Text("QR Scanner"),
          actions: [
            GestureDetector(
              onTap: () async {
                if (isCameraPause) {
                  isCameraPause = false;
                  await controller?.resumeCamera();
                } else {
                  isCameraPause = true;
                  await controller?.pauseCamera();
                }
                setState(() {});
              },
              child: FutureBuilder(
                future: controller?.getFlashStatus(),
                builder: (context, snapshot) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Icon(isCameraPause ? Icons.play_arrow : Icons.pause),
                  );
                },
              ),
            ),
            GestureDetector(
              onTap: () async {
                isFlash = !isFlash;
                await controller?.toggleFlash();
                setState(() {});
              },
              child: FutureBuilder(
                future: controller?.getFlashStatus(),
                builder: (context, snapshot) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Icon(isFlash ? Icons.flash_off : Icons.flash_on),
                  );
                },
              ),
            ),
          ],
        ),
        body: Stack(
          children: [

            Column(
              children: [
              /* !isStartScan ?  GestureDetector(
                onTap: () async {
                  _buildQrView(context);


      },
            child: Container(
              height: height * 0.06,
              width: width * 0.3,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius:
                BorderRadius.circular(width * 0.02),
                color: Colors.red,
              ),
              child: const Text('Start Scan',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
            ),
      ) : */Expanded(flex: 2, child: _buildQrView(context)),
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        if (result != null)
                          Text('Data: ${result!.code}')
                        else
                          const Text('Scan a code',style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold)),
                        if (result != null)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              WebViewPage(scanData: result)));
                                },
                                child: Container(
                                  height: height * 0.06,
                                  width: width * 0.3,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(width * 0.02),
                                    color: Colors.red,
                                  ),
                                  child: Text('Play',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                              // Container(
                              //   padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                              //
                              //   child: ElevatedButton(
                              //
                              //       onPressed: () async {
                              //         Navigator.pushReplacement(
                              //             context,
                              //             MaterialPageRoute(
                              //                 builder: (context) => WebViewPage(scanData: result)));
                              //       },
                              //       child: const Text('Play')),
                              // ),


                              GestureDetector(
                                onTap: () async {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              DownloadZip(scanData: result!)));
                                },
                                child: Container(
                                  height: height * 0.06,
                                  width: width * 0.3,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.circular(width * 0.02),
                                    color: Colors.red,
                                  ),
                                  child: Text('Download',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),




                              // Container(
                              //   color: Colors.red,
                              //   padding: EdgeInsets.symmetric(
                              //       horizontal: 8.0, vertical: 8.0),
                              //   child: ElevatedButton(
                              //       onPressed: () async {
                              //         Navigator.pushReplacement(
                              //             context,
                              //             MaterialPageRoute(
                              //                 builder: (context) =>
                              //                     DownloadZip(scanData: result!)));
                              //       },
                              //       child: const Text('Download')),
                              // ),
                            ],
                          ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            if(isStartScan) Positioned(
              top:  height * 0.3,
              left: width * 0.45,
              child: Container(
                color: Colors.blueGrey,
                child: const Text('Wait....', style: TextStyle(color: Colors.yellow),),
              ),
            ) ,
          ],
        ),
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 350 ||
            MediaQuery.of(context).size.height < 350)
        ? 150.0
        : 300.0;
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      cameraFacing: CameraFacing.back,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  Future<void> _onQRViewCreated(QRViewController controller) async {
    setState(() {
      this.controller = controller;
      isStartScan = false;
    });
    await this.controller!.resumeCamera();
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
