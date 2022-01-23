import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tranding_signal_system/Constants.dart';
import 'package:tranding_signal_system/Screen/dashboard.dart';
import 'package:tranding_signal_system/Services/firebase_notification_handler.dart';

import 'login.dart';
import 'menu.dart';

class Splash extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<Splash> {
  FirebaseNotification firebaseNotification = FirebaseNotification();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      firebaseNotification.setupFirebase(context);
    });
    Future.delayed(Duration(seconds: 4), () {
      checkLoginStatus();

    });
  }
  Future<void> checkLoginStatus() async {
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var email = prefs.getString('email');
    print(email);
    email == null?
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (BuildContext context) => Menu_page()),
            (Route<dynamic> route) => false)

    : Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (BuildContext context) => Dashboard()),
            (Route<dynamic> route) => false);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: backgroundcolor,
        child: Center(
          child: Image(height: 200,
            image:  AssetImage("assets/logo_new.png"))),
      ),
    );
  }

}
