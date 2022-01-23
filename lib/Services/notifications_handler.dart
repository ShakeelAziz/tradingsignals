

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationsHandler {
  static final flutterLocalNotificationPlugin = FlutterLocalNotificationsPlugin();
  static BuildContext mycontext;

  static void initNotification(BuildContext context) {
    mycontext = context;

    var initAndroid = AndroidInitializationSettings("@mipmap/ic_launcher");
    var initIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidRecieveLocalNotifications);
    var initSettings = InitializationSettings(
        android: initAndroid, iOS: initIOS);
    flutterLocalNotificationPlugin.initialize(
        initSettings, onSelectNotification: onSelectNotification);
  }

  static Future onSelectNotification(String payload){
    if(payload!=null )print("get Payload "+payload);
  }


  static Future onDidRecieveLocalNotifications(int id, String title,
      String body, String payload) async {
    showDialog(context: mycontext,
        builder: (context) =>
            CupertinoAlertDialog(title: Text(title),
              content: Text(body),
              actions: [
                CupertinoDialogAction(isDefaultAction: true,
                  child: Text("Ok"),
                  onPressed: () =>
                      Navigator.of(context, rootNavigator: true).pop(),)
              ],));
  }
}