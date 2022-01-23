import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tranding_signal_system/Constants.dart';
import 'package:tranding_signal_system/CustomWidget/drawer.dart';
import 'package:tranding_signal_system/Models/notificationModel.dart';
import 'package:tranding_signal_system/Screen/login.dart';
import 'package:tranding_signal_system/Services/local_Notifications.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Dashboard extends StatefulWidget {
  String kpass;

  Dashboard({key, this.kpass});

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  SharedPreferences sp;
  String notifi_title, notifi_body;
  String token;
  Timer timer;
  String pass;
  String errormsg;
  DateTime datetime = DateTime.now();
  Timestamp time;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  String imgURL = "";
  String imgURL2 = "";
  final FirebaseMessaging fcm = FirebaseMessaging.instance;
  final firestore = FirebaseFirestore.instance;
  List<Notifications> notify_list = [];
  final Stream<QuerySnapshot> _notificationsStream = FirebaseFirestore.instance
      .collection('messages')
      .orderBy("date_time", descending: true)
      .snapshots(includeMetadataChanges: true);

  void configureCallback() {
    Timestamp mystamp = Timestamp.fromDate(datetime);
    fcm.getToken().then((value) => print("vapid: " + value));
    fcm.getInitialMessage();
    //when the app is in foreground
    FirebaseMessaging.onMessage.listen((message) {
      if (message.notification != null) {
        print(message.notification.title);
        print(message.notification.body);
//knkjnjln
        firestore.collection("messages").add({
          "notification_title": message.notification.title,
          "date_time": DateTime.now(),
          // "notification_body": message.notification.body
        }).then((value) => print(value.id));
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

  @override
  void initState() {
    getsp();
    /*FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage message) {
      if (message != null) {
        Navigator.pushNamed(context, "crypto",
            arguments: message.notification.body);
      }
    });*/
    super.initState();
    configureCallback();
  }

  getsp() async {
    sp = await SharedPreferences.getInstance();
    setState(() {
      token = sp.get("token");
      pass = sp.get("pass");
      getData(token);
      timer = Timer.periodic(
          Duration(seconds: 10), (Timer t) => CheckLoginStatus(token));
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SafeArea(
        child: Scaffold(
          key: scaffoldKey,
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
            actions: [
              IconButton(
                  icon: Icon(Icons.more_vert_outlined),
                  onPressed: () => scaffoldKey.currentState.openEndDrawer())
            ],
          ),
          endDrawer: rightDrawer(),
          body: Container(
            color: backgroundcolor,
            child: RefreshIndicator(
              color: Colors.white,
              backgroundColor: Colors.purple,
              triggerMode: RefreshIndicatorTriggerMode.anywhere,
              onRefresh: _refreshData,
              child: Column(
                children: [
                  Padding(
                    padding: kdefaultpadding,
                    child: GestureDetector(
                      onTap: _launchURL,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 150,
                        decoration: BoxDecoration(
                            /*image: new DecorationImage(
                              image: (imgURL == null)
                                  ? AssetImage("assets/pic.jpg")
                                  : NetworkImage(imgURL),
                              fit: BoxFit.fitWidth,
                            ),*/
                            borderRadius: BorderRadius.circular(10)),
                        child: (imgURL != "")
                            ? Image(image: NetworkImage(imgURL))
                            : Center(
                                child: CircularProgressIndicator(),
                              ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Row(
                      children: [
                        Text(
                          "Recent Notifications",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.60,
                    color: Colors.white,
                    child: getNotifications(),
                  )
                  /* Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Row(
                      children: [
                        Text(
                          " ",
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
                          " ",
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
                  )*/
                ],
              ),
            ),
          ),
          drawer: Drawer_side(),
        ),
      ),
    );
  }

  CheckLoginStatus(String token) async {
    var result;
    var headers = {'Authorization': 'Bearer ${token}'};
    var request =
        http.Request('GET', Uri.parse('http://appadmin1.xyz/api/check-user'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    var jsonResponse = await response.stream.bytesToString();
    if (response.statusCode == 200) {
      result = json.decode(jsonResponse)["data"]["token"];
      if (result == null) {
        ShowDialog();
      }
    } else {
      ShowDialog();
      print(response.reasonPhrase);
    }
  }

  getNotifications() {
    return StreamBuilder<QuerySnapshot>(
      stream: _notificationsStream,
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text("Something Went Wrong"),
          );
        }else if
          (!snapshot.hasData){
          return Center(child: Text("No Data Found"),);
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Loading..',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          );
        }
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children:
                snapshot.data.docs.map((DocumentSnapshot documentSnapshot) {
              Map<String, dynamic> data =
                  documentSnapshot.data() as Map<String, dynamic>;

                time = data["date_time"];

              return Card(
                  elevation: 5,
                  child: ListTile(
                    title: Text(data["notification_title"]),
                    subtitle: Text("Received at: ${(DateTime.fromMillisecondsSinceEpoch(time.millisecondsSinceEpoch).toString())}",
                  )));
            }).toList(),
          ),
        );
      },
    );
  }

  ShowDialog() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Session Expired"),
            content: Text("Please Contact Admin to Support this problem"),
            actions: [
              MaterialButton(
                onPressed: () {
                  sp.clear();
                  sp.commit();
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (BuildContext context) => Login()),
                      (Route<dynamic> route) => false);
                },
                child: Text("Ok"),
              )
            ],
          );
        });
  }

  rightDrawer() {
    return Drawer(
        elevation: 5,
        child: Container(
          color: backgroundcolor,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                        //color: Colors.red,
                        borderRadius: BorderRadius.circular(10)),
                    child: Image.asset("assets/logo_new.png")),
              ),
              ListTile(
                title: Text(
                  "App Info",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              ListTile(
                  title: Text(
                "Share Information",
                style: TextStyle(color: Colors.white),
              )),
            ],
          ),
        ));
  }

  Future<void> getData(String token) async {
    var headers = {'Authorization': 'Bearer ${token}'};
    var request =
        http.Request('GET', Uri.parse('http://appadmin1.xyz/api/setting'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var newdata = await response.stream.bytesToString();
      var result = json.decode(newdata)['message'];
      setState(() {
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

  Future _refreshData() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {});
  }
}
