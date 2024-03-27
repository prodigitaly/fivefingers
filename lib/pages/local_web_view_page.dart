import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'dart:collection';

import 'downloaded_files.dart';

class LocalWebViewPage extends StatefulWidget {
  String path;
  bool isTeacher;

  LocalWebViewPage({required this.path, required this.isTeacher});

  @override
  State<LocalWebViewPage> createState() => _LocalWebViewPageState();
}

class _LocalWebViewPageState extends State<LocalWebViewPage> {
  final GlobalKey webViewKey = GlobalKey();

  InAppWebViewController? _webViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              if (!widget.isTeacher) {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DownloadedFiles(),
                    ));
              } else {
                Navigator.pop(context);
              }
            },
            child: const Icon(Icons.arrow_back_ios)),
      ),
      body: Container(
        // color: Colors.red,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: /*WebViewWidget(controller: controller),*/
            InAppWebView(
          key: webViewKey,
          initialUrlRequest:
              URLRequest(url: Uri.parse('${widget.path}/index.html')),
          // initialUrlRequest:
          // URLRequest(url: WebUri(Uri.base.toString().replaceFirst("/#/", "/") + 'page.html')),
          // initialFile: "assets/index.html",

          initialUserScripts: UnmodifiableListView<UserScript>([]),
          // initialSettings: settings,
          // contextMenu: contextMenu,
          // pullToRefreshController: pullToRefreshController,
          onWebViewCreated: (controller) async {
            _webViewController = controller;
            print(await controller.getUrl());
          },
          onLoadStart: (controller, url) async {
            /*   setState(() {
              this.url = url.toString();
              urlController.text = this.url;
            });*/
          },
          /*  onPermissionRequest: (controller, request) async {
            return PermissionResponse(
                resources: request.resources,
                action: PermissionResponseAction.GRANT);
          },*/
          shouldOverrideUrlLoading: (controller, navigationAction) async {
            var uri = navigationAction.request.url!;

            /* if (![
              "http",
              "https",
              "file",
              "chrome",
              "data",
              "javascript",
              "about"
            ].contains(uri.scheme)) {
              if (await canLaunchUrl(uri)) {
                // Launch the App
                await launchUrl(
                  uri,
                );
                // and cancel the request
                return NavigationActionPolicy.CANCEL;
              }
            }*/

            return NavigationActionPolicy.ALLOW;
          },
          onLoadStop: (controller, url) async {
            // pullToRefreshController?.endRefreshing();
            // setState(() {
            //   this.url = url.toString();
            //   urlController.text = this.url;
            // });
          },
          /* onReceivedError: (controller, request, error) {
            pullToRefreshController?.endRefreshing();
          },*/
          /* onProgressChanged: (controller, progress) {
            if (progress == 100) {
              pullToRefreshController?.endRefreshing();
            }
            setState(() {
              this.progress = progress / 100;
              urlController.text = this.url;
            });
          },*/
          /* onUpdateVisitedHistory: (controller, url, isReload) {
            setState(() {
              this.url = url.toString();
              urlController.text = this.url;
            });
          },*/
          onConsoleMessage: (controller, consoleMessage) {
            print(consoleMessage);
          },
        ),
        /* progress < 1.0
            ? LinearProgressIndicator(value: progress)
            : Container(),*/
      ),
    );
  }
}
