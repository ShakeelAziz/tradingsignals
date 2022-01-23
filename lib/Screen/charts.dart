import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tranding_signal_system/Constants.dart';
import 'package:tranding_signal_system/CustomWidget/drawer.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

class Charts extends StatefulWidget {
  @override
  _ChartsState createState() => _ChartsState();
}

class _ChartsState extends State<Charts> {
  WebViewController _controller;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(

      child: Scaffold(
        backgroundColor: backgroundcolor,
        appBar: AppBar(
          backgroundColor: backgroundcolor,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Charts",
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
            height: MediaQuery.of(context).size.height,
            color: Colors.white,
            child: Column(
            children: [
              Padding(
                padding: kdefaultpadding,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height*0.3,
                  color: backgroundcolor,
                  child: WebViewPlus(
                    javascriptMode: JavascriptMode.unrestricted,
                    onWebViewCreated: (controller){
                      controller.loadUrl('assets/files/charts1.html');
                    },
                  ),
                  // WebView(
                  //   initialUrl: "https://www.tradingview.com/symbols/EURUSD/?exchange=FOREXCOM",
                  //   onWebViewCreated:
                  //       (WebViewController webViewController) async {
                  //     _controller = webViewController;
                  //     await loadHtmlfromAssets('assets/files/chart1.html',_controller);
                  //   },
                  // )
                ),
              ),
              SizedBox(height: 70),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.3,
                    color: backgroundcolor,
                    child: WebViewPlus(
                      javascriptMode: JavascriptMode.unrestricted,
                      onWebViewCreated: (controller){
                        controller.loadUrl('assets/files/charts2.html');
                      },
                    ),


                /*    WebView(
                      initialUrl: "",
                      onWebViewCreated:
                          (WebViewController webViewController) async {
                        _controller = webViewController;
                        await loadHtmlfromAssets('assets/files/chart2.html',_controller);
                      },
                    )*/
                ),
              ),
            ],
          ),
      ),
        ),
    ));
  }
  Future<void> loadHtmlfromAssets(String filename,  controller)async {
    String filetext = await rootBundle.loadString(filename);
    controller.loadUrl(Uri.dataFromString(filetext,mimeType: 'text/html', encoding:Encoding.getByName('utf-8')).toString());
  }
}
