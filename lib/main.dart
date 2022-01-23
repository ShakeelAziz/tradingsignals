import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tranding_signal_system/Screen/historical_Data.dart';
import 'package:tranding_signal_system/Services/firebase_notification_handler.dart';

import 'Constants.dart';
import 'Screen/splash.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage( _backgroundHandler);

  runApp(ScreenUtilInit(
      builder: () => DevicePreview(
          enabled: false,
          builder: (context) => MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: ThemeData(primaryColor: primarycolor),
                 home: Splash(),
                routes: {
                  //'/': (BuildContext context) => Splash(),
                  "forex": (_)=> Forex(),
                  "crypto": (_)=> Crypto(),
                  "historical": (_)=> Historical_Data(),
                },
              ))));
}

Future<void> _backgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handle Background Service $message");
  dynamic data =  message.data['data'];
  FirebaseNotification.showNotifications(data['title'],"");
}
