import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tranding_signal_system/Constants.dart';
import 'package:tranding_signal_system/CustomWidget/drawer.dart';
import 'package:tranding_signal_system/Services/local_Notifications.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;
import 'Forex_Signals.dart';
import 'analysis.dart';
import 'charts.dart';
import 'historical_Data.dart';
import 'login.dart';
import 'market.dart';

class Menu_page extends StatefulWidget {
  @override
  _Menu_pageState createState() => _Menu_pageState();
}

class _Menu_pageState extends State<Menu_page> {
  String deviceid;
  String android_version = "";
  String supportEmail = "";
  String imgURL = "";
  String imgURL2 = "";
  final FirebaseFirestore db = FirebaseFirestore.instance;
 final FirebaseMessaging fcm = FirebaseMessaging.instance;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
    getId();
   configureCallback();
  }

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
                  "Dashboard",
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
          body: Container(
            color: backgroundcolor,
            child: ListView(
              children: [
                Padding(
                  padding: kdefaultpadding,
                  child: GestureDetector(
                    onTap: _launchURL,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 150,
                      decoration: BoxDecoration(
                         /* image: new DecorationImage(
                            image: (imgURL == null)
                                ? AssetImage("assets/pic.jpg")
                                : NetworkImage(imgURL),
                            fit: BoxFit.fitWidth,
                          ),*/
                          borderRadius: BorderRadius.circular(10)),
                      child: (imgURL!="")?Image(image:NetworkImage(imgURL)):Center(child: CircularProgressIndicator(),), ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Row(
                    children: [
                      Text(
                        "Live Currency Cross Rates",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: kdefaultpadding,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.5,
                    color: backgroundcolor,
                    child: WebView(
                      initialUrl: Uri.dataFromString(
                              '<html><body><iframe src="https://www.widgets.investing.com/live-currency-cross-rates?theme=darkTheme&cols=bid,prev,high,low,change,changePerc,time&pairs=1,3,2,4,7,5,8,6,9,10,49,11,13,16,47,51,58,50,53,15,12,52,48,55,54,18" width="100%" height="600" frameborder="0" allowtransparency="true" marginwidth="0" marginheight="0"></iframe></body></html>',
                              mimeType: 'text/html')
                          .toString(),
                      javascriptMode: JavascriptMode.unrestricted,
                      gestureRecognizers: Set()
                        ..add(Factory<VerticalDragGestureRecognizer>(
                            () => VerticalDragGestureRecognizer())),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 20),
                  child: Row(
                    children: [
                      Text(
                        "Live Cryptocurrency Rates ",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    color: const Color(0xFF1a2238),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: WebView(
                      initialUrl: Uri.dataFromString(
                              '<html><body><iframe src="https://www.widgets.investing.com/crypto-currency-rates?theme=darkTheme&cols=bid,last,prev,high,low,change,changePerc,time&pairs=945629,997650,1031068,1130879,1071025,1179277,1073899,1075256,1161143,1070910,1070677,1057870,1070392,1070463,1155982,1062033,1056828,1070432,1060635,1122515,1070887,1070982,1089397,1093970,1179791,1142178,1070872,1118146,1118121,1070628" width="100%" height="600" frameborder="0" allowtransparency="true" marginwidth="0" marginheight="0"></iframe></body></html>',
                              mimeType: 'text/html')
                          .toString(),
                      javascriptMode: JavascriptMode.unrestricted,
                      gestureRecognizers: Set()
                        ..add(Factory<VerticalDragGestureRecognizer>(
                            () => VerticalDragGestureRecognizer())),
                    ),
                  ),
                )
              ],
            ),
          ),
          drawer: newDrawer(),
        ),
      ),
    );
  }

  newDrawer() {
    return Container(
      width: 300,
      color: const Color(0xFF1e2742),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 30.0, bottom: 50, left: 8.0),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 10),
                  child: Container(
                    height: 55,
                    width: 50,
                    decoration: BoxDecoration(
                        color: Colors.deepPurple,
                        borderRadius: BorderRadius.circular(10)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        "assets/no-photo.png",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Text(
                  "Guest",
                  //  "${sharedPreferences.getString("name")}",
                  style: TextStyle(color: Colors.white),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Container(
              height: 55,
              width: 280,
              decoration: BoxDecoration(
                  border: Border.all(width: 1.0, color: Colors.white),
                  color: const Color(0xFF1a2238),
                  borderRadius: BorderRadius.circular(5)),
              child: ListTile(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Login(
                                deviceid: deviceid,
                              )));
                },
                leading: Icon(
                  Icons.login,
                  color: Colors.white,
                ),
                title: Text(
                  "Login",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Container(
              height: 55,
              width: 280,
              decoration: BoxDecoration(
                  border: Border.all(width: 1.0, color: Colors.white),
                  color: const Color(0xFF1a2238),
                  borderRadius: BorderRadius.circular(5)),
              child: ListTile(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Market()));
                },
                leading: Icon(
                  Icons.add_road,
                  color: Colors.white,
                ),
                title: Text(
                  "Market",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          /* Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Container(
              height: 50,
              width: 280,
              decoration: BoxDecoration(
                // border: Border.all(width: 1.0, color: Colors.white),
                  color: const Color(0xFF1a2238),
                  borderRadius: BorderRadius.circular(5)),
              child: ListTile(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Forex_signals()));
                },
                leading: Icon(
                  Icons.moving_outlined,
                  color: Colors.white,
                ),
                title: Text(
                  "Active Forex Signals",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Container(
              height: 50,
              width: 280,
              decoration: BoxDecoration(
                // border: Border.all(width: 1.0, color: Colors.white),
                  color: const Color(0xFF1a2238),
                  borderRadius: BorderRadius.circular(5)),
              child: ListTile(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Crypto_signals()));
                },
                leading: Icon(
                  Icons.sensors_outlined,
                  color: Colors.white,
                ),
                title: Text(
                  "Active Crypto Signals",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),*/
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Container(
              height: 55,
              width: 280,
              decoration: BoxDecoration(
                  border: Border.all(width: 1.0, color: Colors.white),
                  color: const Color(0xFF1a2238),
                  borderRadius: BorderRadius.circular(5)),
              child: ListTile(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Historical_Data()));
                },
                leading: Icon(
                  Icons.trending_down_outlined,
                  color: Colors.white,
                ),
                title: Text(
                  "Closed Signals",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Container(
              height: 55,
              width: 280,
              decoration: BoxDecoration(
                  border: Border.all(width: 1.0, color: Colors.white),
                  color: const Color(0xFF1a2238),
                  borderRadius: BorderRadius.circular(5)),
              child: Align(
                alignment: Alignment.center,
                child: ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Analysis()));
                  },
                  leading: Icon(
                    Icons.analytics_outlined,
                    color: Colors.white,
                  ),
                  title: Text(
                    "Analysis",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Container(
              height: 55,
              width: 280,
              decoration: BoxDecoration(
                  border: Border.all(width: 1.0, color: Colors.white),
                  color: const Color(0xFF1a2238),
                  borderRadius: BorderRadius.circular(5)),
              child: ListTile(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Charts()));
                },
                leading: Icon(
                  Icons.stacked_bar_chart_outlined,
                  color: Colors.white,
                ),
                title: Text(
                  "Charts",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 180,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Align(
                alignment: Alignment.bottomLeft,
                child: (android_version != null)
                    ? Text(
                        "version: $android_version",
                        style: TextStyle(color: Colors.white),
                      )
                    : Text("")),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  "$supportEmail",
                  style: TextStyle(color: Colors.white),
                )),
          )
        ],
      ),
    );
  }

  Future<void> getData() async {
    var headers = {
      'Cookie':
          'XSRF-TOKEN=eyJpdiI6InRLUXdSR1YwM3ZQejZwN2VIQUhNWFE9PSIsInZhbHVlIjoibzdVM25oSWZVY215MWh6L0oyanJuQ1hIWkhjT3lhUStJWm01VmdUUnBhdi9UdFAvMk5OemROMGs3cUF0SXVmL1NCdTdRalo0T1BJV0g4Umx0ZVhIL3V0bGwybS95NVAyeVFZaUZzcC9sTmZWWDZiZFFQeGVuR29tdU1UVXl4d24iLCJtYWMiOiI3MjQ4MTQ4MmYwZTdlNWE5ZjU2NzBlMWRhNzUzZDlmMTAzYzNiMTFiMzMzYTI5Mzc0MWY5OTBhOTA0MTU0MjQxIn0%3D; laravel_session=eyJpdiI6Ink5N0lNcUxZeW9UNjZLMTliQ1BnaUE9PSIsInZhbHVlIjoiUWpYYVhvQVdLYWZQTDRxcVpGV09JNzV6Mnp0cVhXeDFuMzdzckVKNWVMNE9VT1o3RVRKT2prSDZzR3U4aFdUNjZDbFdrUm1YSkFzMThaRFRxendIWmF1TnJ2TG5ISUxIYzVBeU1OUXRRY3NrNXYvSFhBM3N4OXdJTnNnVFlYMWIiLCJtYWMiOiJiYmVhYzM3NDRlYWFmOWY5ZjZhOGM3MWQ2MzkyYTQyYTM0MzE5M2UyN2NlYjM2MDBlN2FmZjY0M2I5NWI2MjU5In0%3D'
    };
    var request =
        http.Request('GET', Uri.parse('http://appadmin1.xyz/api/setting'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var newdata = await response.stream.bytesToString();
      var result = json.decode(newdata)['message'];
      setState(() {
        android_version = result['android_version'];
        supportEmail = result['support_email'];
        imgURL = result['cover_image'];
        imgURL2 = result['image_url'];
      });
    } else {
      print(response.reasonPhrase);
    }
  }

  _launchURL() async {
    var url = '${imgURL2}';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      Fluttertoast.showToast(msg: "No Link associated with Image!");
      throw 'Could not launch $url';
    }
  }

  getId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

    deviceid = androidInfo.model;
    print(deviceid);
  }

  void configureCallback() {
    fcm.getToken().then((value) => print("vapid: "+value));
    fcm.getInitialMessage();
    //when the app is in foreground
    FirebaseMessaging.onMessage.listen((message) {
      if (message.notification != null) {
        print(message.notification.title);
        print(message.notification.body);
      }
      LocalNotificationService.display(message);
    });
    //when the app is in background but not closed
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      final routefromMessage = event.data["route"];
      Navigator.of(context).pushNamed(routefromMessage);
      LocalNotificationService.display(event);
    });
  }
}
