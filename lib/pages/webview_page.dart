// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart' as wb;
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:rxdart/rxdart.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

import 'package:zoom/pages/qr_code_scanner_page.dart';

import 'downloaded_files.dart';

class WebViewPage extends StatefulWidget {
  final Barcode? scanData;
  final String? path;

  const WebViewPage({Key? key, this.scanData, this.path}) : super(key: key);

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  WebViewController? webViewController;
  String url = '';
  final BehaviorSubject<bool> streamLoader = BehaviorSubject<bool>();
  // wb.InAppWebViewController? _webViewController;

  @override
  void initState() {
    if(widget.path == null) {
      if (widget.scanData!.code!.contains('http')) {
        // url = widget.scanData!.code!.replaceFirst('http', 'https');
        url = widget.scanData!.code!.replaceFirst('http', 'https');
        debugPrint('url --> $url');
      }
    } else {
      url = '${widget.path}/index.html';
    }

    if(widget.path == null) {
      late final PlatformWebViewControllerCreationParams params;
      if (WebViewPlatform.instance is WebKitWebViewPlatform) {
        params = WebKitWebViewControllerCreationParams(
          allowsInlineMediaPlayback: true,
          mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
        );
      } else {
        params = const PlatformWebViewControllerCreationParams();
      }
      final WebViewController controller =
          WebViewController.fromPlatformCreationParams(params);

      controller
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(const Color(0x00000000))
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (int progress) {
              debugPrint('WebView is loading (progress : $progress%)');
              if (progress == 100) {
                streamLoader.sink.add(false);
              }
            },
            onPageStarted: (String url) {
              streamLoader.sink.add(true);
              debugPrint('Page started loading: $url');
            },
            onPageFinished: (String url) {
              streamLoader.sink.add(false);
              debugPrint('Page finished loading: $url');
            },
            onWebResourceError: (WebResourceError error) {
              debugPrint('Page resource error: '
                  'code: ${error.errorCode}'
                  'description: ${error.description}'
                  'errorType: ${error.errorType}'
                  'isForMainFrame: ${error.isForMainFrame}');
            },
            onNavigationRequest: (NavigationRequest request) {
              debugPrint('allowing navigation to ${request.url}');
              return NavigationDecision.navigate;
            },
          ),
        )
        ..addJavaScriptChannel(
          'Toaster',
          onMessageReceived: (JavaScriptMessage message) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(message.message)));
          },
        )
        ..loadRequest(Uri.parse(url));

      webViewController = controller;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('scanData -> ${widget.scanData}');
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          leading: GestureDetector(
            onTap: () => Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => const DownloadedFiles())),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Icon(Icons.arrow_back_ios),
            ),
          ),
        ),
        body:StreamBuilder<bool>(
            stream: streamLoader,
            builder: (context, snapshot) {
              return Stack(
                children: [
                  WebViewWidget(controller: webViewController!),
                ],
              );
            })
      ),
    );
  }
}
