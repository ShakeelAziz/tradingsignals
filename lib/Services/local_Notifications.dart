import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  static void initialize() {
    final InitializationSettings initializationSettings = InitializationSettings(
        android: AndroidInitializationSettings("@mipmap/ic_launcher"));

    _notificationsPlugin.initialize(initializationSettings);
  }

  static void display(RemoteMessage message) async {
    try {
      final id = DateTime
          .now()
          .millisecondsSinceEpoch ~/ 1000;
      final NotificationDetails notificationDetails = NotificationDetails(
          android: AndroidNotificationDetails(
            "tradingSignals",
            "tradingSignals ",
            importance: Importance.max,
            priority: Priority.high,
            icon: "@mipmap/ic_launcher"
          )
      );

      await _notificationsPlugin.show(
          id, message.notification.title," ",
          notificationDetails);
    } on Exception catch (e) {
      print(e);
    }
  }


}