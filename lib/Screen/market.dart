import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tranding_signal_system/CustomWidget/drawer.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

import '../Constants.dart';

class Market extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<Market> {
  WebViewController _controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: backgroundcolor,
          appBar: AppBar(
            backgroundColor: backgroundcolor,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Market",
                  style: TextStyle(fontSize: 20),
                ),
                Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                        //color: Colors.red,
                        borderRadius: BorderRadius.circular(10)),
                    child: Image.asset("assets/logo_new.png")),
              ],
            ),
          ),
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Container(
              color: Colors.white,
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        color: backgroundcolor,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.4,
                        child: WebViewPlus(
                          zoomEnabled: true,
                          gestureNavigationEnabled: true,
                          javascriptMode: JavascriptMode.unrestricted,
                          onWebViewCreated: (controller){
                            controller.loadUrl('assets/files/market1.html');
                          },
                        ),
                        // child: WebView(
                        //   initialUrl: "",
                        //   onWebViewCreated:
                        //       (WebViewController webViewController) async {
                        //     _controller = webViewController;
                        //     await loadHtmlfromAssets('assets/files/market1.html',_controller);
                        //   },
                        // )
                        /*WebView(
                        initialUrl: Uri.dataFromString(
                                '<html><body><iframe src="https://www.widgets.investing.com/ico-calendar?theme=darkTheme" width="100%" height="600" frameborder="0" allowtransparency="true" marginwidth="0" marginheight="0"></iframe></body></html>',
                                mimeType: 'text/html')
                            .toString(),
                        javascriptMode: JavascriptMode.unrestricted,
                        gestureRecognizers: Set()
                          ..add(Factory<VerticalDragGestureRecognizer>(
                              () => VerticalDragGestureRecognizer())),
                      ),*/

                        ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.4,
                      color: backgroundcolor,
                      child:WebViewPlus(
                        javascriptMode: JavascriptMode.unrestricted,
                        onWebViewCreated: (controller){
                          controller.loadUrl('assets/files/market2.html');
                        },
                      ),
                      // WebView(
                      //   initialUrl: "",
                      //   onWebViewCreated:
                      //       (WebViewController webViewController) async {
                      //     _controller = webViewController;
                      //     await loadHtmlfromAssets('assets/files/market2.html',_controller);
                      //   },
                      // )
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> loadHtmlfromAssets(String filename,  controller)async {
    String filetext = await rootBundle.loadString(filename);
    controller.loadUrl(Uri.dataFromString(filetext,mimeType: 'text/html', encoding:Encoding.getByName('utf-8')).toString());
  }
}
