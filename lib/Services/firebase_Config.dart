import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DefaultFirebaseConfig {
  static FirebaseOptions get platformOptions {
    if (kIsWeb) {
      // Web
      return const FirebaseOptions(
        apiKey: 'AIzaSyD8aYy3TssyfdmnSPD-hUvO_0kOkcb3-OQ',
        authDomain: 'trading-signals-e5357.firebaseapp.com',
        projectId: 'trading-signals-e5357',
        storageBucket: 'trading-signals-e5357.appspot.com',
        messagingSenderId: '1031703260240',
        appId: '1:1031703260240:web:094c035a93e09c0b50f555',
        measurementId: 'G-VNPBBFFFE5',
      );
    } else {
      // Android
      return const FirebaseOptions(
        apiKey: 'AIzaSyD8aYy3TssyfdmnSPD-hUvO_0kOkcb3-OQ',
        authDomain: 'trading-signals-e5357.firebaseapp.com',
        projectId: 'trading-signals-e5357',
        messagingSenderId: '1031703260240',
        appId: '1:1031703260240:web:094c035a93e09c0b50f555',
        androidClientId:
        '1031703260240-a95st1hed13jrf97gmmb010k8355bc08.apps.googleusercontent.com',
      );
    }
  }
}