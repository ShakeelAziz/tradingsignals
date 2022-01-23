import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tranding_signal_system/Constants.dart';
import 'package:tranding_signal_system/CustomWidget/drawer.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

class Analysis extends StatefulWidget {
  @override
  _AnalysisState createState() => _AnalysisState();
}

class _AnalysisState extends State<Analysis> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: backgroundcolor,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Analysis",
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
            child: Container(
              color: backgroundcolor,
              child: Column(
                children: [
                  Padding(
                    padding: kdefaultpadding,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height*0.4,
                      color: backgroundcolor,
                      child: WebViewPlus(
                        javascriptMode: JavascriptMode.unrestricted,
                        onWebViewCreated: (controller){
                          controller.loadUrl('assets/files/analysis1.html');
                        },
                      ),
                    ),
                  ),Padding(
                    padding: kdefaultpadding,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height*0.4,
                      color: backgroundcolor,
                      child: WebViewPlus(
                        javascriptMode: JavascriptMode.unrestricted,
                        onWebViewCreated: (controller){
                          controller.loadUrl('assets/files/analysis2.html');
                        },
                      ),

                    ),
                  ),Padding(
                    padding: kdefaultpadding,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height*0.4,
                      color: backgroundcolor,
                      child: WebViewPlus(
                        javascriptMode: JavascriptMode.unrestricted,
                        onWebViewCreated: (controller){
                          controller.loadUrl('assets/files/analysis3.html');
                        },
                      ),

                    ),
                  ),Padding(
                    padding: kdefaultpadding,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height*0.4,
                      color: backgroundcolor,
                      child: WebViewPlus(
                        javascriptMode: JavascriptMode.unrestricted,
                        onWebViewCreated: (controller){
                          controller.loadUrl('assets/files/analysis4.html');
                        },
                      ),

                    ),
                  ),Padding(
                    padding: kdefaultpadding,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height*0.4,
                      color: backgroundcolor,
                      child: WebViewPlus(
                        javascriptMode: JavascriptMode.unrestricted,
                        onWebViewCreated: (controller){
                          controller.loadUrl('assets/files/analysis5.html');
                        },
                      ),

                    ),
                  ),Padding(
                    padding: kdefaultpadding,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height*0.4,
                      color: backgroundcolor,
                      child: WebViewPlus(
                        javascriptMode: JavascriptMode.unrestricted,
                        onWebViewCreated: (controller){
                          controller.loadUrl('assets/files/analysis6.html');
                        },
                      ),

                    ),
                  ),
                  /*Padding(
                    padding: kdefaultpadding,
                    child: Container(
                      width: 350,
                      height: 400,
                      color: backgroundcolor,
                      child: WebView(
                        initialUrl: Uri.dataFromString(
                                '<html><body><iframe src="https://ssltsw.investing.com?lang=1&forex=1,2,3,5,7,945629,18&commodities=8830,8836,8831,8849,8833,8862,8832&indices=175,166,172,27,179,170,174&stocks=345,346,347,348,349,350,352&tabs=1,2,3,4" width="317" height="467"></iframe>'
                                    '<div class="poweredBy" style="font-family:arial,helvetica,sans-serif; direction:ltr;"><span style="font-size: 11px;color: #333333;text-decoration: none;">Technical Summary Widget Powered by <a href="https://www.investing.com/" rel="nofollow" target="_blank" style="font-size: 11px;color: #06529D; font-weight: bold;" class="underline_link">Investing.com</a></span></div></body></html>',
                                mimeType: 'text/html')
                            .toString(),
                        javascriptMode: JavascriptMode.unrestricted,
                        gestureRecognizers: Set()
                          ..add(Factory<VerticalDragGestureRecognizer>(
                              () => VerticalDragGestureRecognizer())),
                      ),
                    ),
                  ),*/
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
