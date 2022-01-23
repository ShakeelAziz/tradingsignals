import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'notifications_handler.dart';

class FirebaseNotification{
  FirebaseMessaging _messaging;
  BuildContext mycontext;
  void setupFirebase(BuildContext context){
    _messaging = FirebaseMessaging.instance;
    NotificationsHandler.initNotification(context);
    firebaseCloudMessageListener(context);
    mycontext = context;
  }

  void firebaseCloudMessageListener(BuildContext context) async{
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true
    );
    // _messaging.getToken().then((message) =>print("mytoken"+ message));
    FirebaseMessaging.onMessage.listen((remoteMessage) {print(remoteMessage);
    if(Platform.isAndroid)
      showNotifications(remoteMessage.notification.title,"");
    else if(Platform.isIOS)
      showNotifications(remoteMessage.notification.title,"");

    });
    FirebaseMessaging.onMessageOpenedApp.listen((remoteMessage) {
print("Recieved open app: ${remoteMessage}");
if(Platform.isIOS)
  showDialog(context: mycontext,
      builder: (context) =>
          CupertinoAlertDialog(title: Text(remoteMessage.notification.title),
            content: Text(""),
            actions: [
              CupertinoDialogAction(isDefaultAction: true,
                child: Text("Ok"),
                onPressed: () =>
                    Navigator.of(context, rootNavigator: true).pop(),)
            ],));
    });
  }

  static void showNotifications(String title, String body) async {
    var androidChannel = AndroidNotificationDetails("com.tranding_signal_system", "MyChannel",importance: Importance.max,priority: Priority.high);
    var iOSChannel = IOSNotificationDetails();
    var platform = NotificationDetails(android: androidChannel,iOS: iOSChannel);
    await NotificationsHandler.flutterLocalNotificationPlugin.show(0, title, body, platform, payload: "My Payload");
  }
}