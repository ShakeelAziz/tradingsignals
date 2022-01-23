import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tranding_signal_system/Constants.dart';
import 'package:tranding_signal_system/Screen/Crypto_Signals.dart';
import 'package:tranding_signal_system/Screen/Forex_Signals.dart';
import 'package:tranding_signal_system/Screen/analysis.dart';
import 'package:tranding_signal_system/Screen/charts.dart';
import 'package:tranding_signal_system/Screen/dashboard.dart';
import 'package:tranding_signal_system/Screen/historical_Data.dart';
import 'package:tranding_signal_system/Screen/login.dart';
import 'package:tranding_signal_system/Screen/market.dart';
import 'package:tranding_signal_system/Screen/menu.dart';
import 'package:http/http.dart' as http;


class Drawer_side extends StatefulWidget {
  @override
  _Drawer_sideState createState() => _Drawer_sideState();
}

class _Drawer_sideState extends State<Drawer_side> {
  SharedPreferences sharedPreferences;
  String username;
  String android_version = " ";
  String supportEmail = " ";
  String token = '';
  @override
  void initState() {
    super.initState();
    loginStatus();
    getData();
  }

  loginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      username = sharedPreferences.get("name");
      token = sharedPreferences.get("token");
    });
    if (sharedPreferences.getString("token") == null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => Login()),
              (Route<dynamic> route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      color: backgroundcolor,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 30.0, bottom: 50),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 10),
                  child: Container(
                    height: 50,
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
                  (username != null) ?
                  "${username}" : "Username",
                  style: TextStyle(color: Colors.white),
                )
              ],
            ),
          ),
          Container(
            height: 55,
            width: 270,
            decoration: BoxDecoration(
                border: Border.all(width: 1.0, color: Colors.white),
                color: backgroundcolor,
                borderRadius: BorderRadius.circular(5)),
            child: ListTile(
              onTap: () {
                Navigator.pop(context);
              },
              leading: Icon(
                Icons.dashboard,
                color: Colors.white,
              ),
              title: Text(
                "Dashboard",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: Container(
              height: 55,
              width: 270,
              decoration: BoxDecoration(
                  border: Border.all(width: 1.0, color: Colors.white),
                  color: backgroundcolor,
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
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: Container(
              height: 55,
              width: 270,
              decoration: BoxDecoration(
                  border: Border.all(width: 1.0, color: Colors.white),
                  color: backgroundcolor,
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
            padding: const EdgeInsets.only(top: 5.0),
            child: Container(
              height: 55,
              width: 270,
              decoration: BoxDecoration(
                  border: Border.all(width: 1.0, color: Colors.white),
                  color: backgroundcolor,
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
          ), Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: Container(
              height: 55,
              width: 270,
              decoration: BoxDecoration(
                  border: Border.all(width: 1.0, color: Colors.white),
                  color: backgroundcolor,
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
            padding: const EdgeInsets.only(top: 5.0),
            child: Container(
              height: 55,
              width: 270,
              decoration: BoxDecoration(
                  border: Border.all(width: 1.0, color: Colors.white),
                  color: backgroundcolor,
                  borderRadius: BorderRadius.circular(5)),
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
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: Container(
              height: 55,
              width: 270,
              decoration: BoxDecoration(
                // border: Border.all(width: 1.0, color: Colors.white),
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5)),
              child: ListTile(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Charts()));
                },
                leading: Icon(
                  Icons.stacked_bar_chart_outlined,
                  color: backgroundcolor,
                ),
                title: Text(
                  "Charts",
                  style: TextStyle(color: backgroundcolor),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: Container(
              height: 55,
              width: 270,
              decoration: BoxDecoration(
                // border: Border.all(width: 1.0, color: Colors.white),
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(5)),
              child: ListTile(
                onTap: () {
                  Navigator.pop(context);
                  sharedPreferences.clear();
                  sharedPreferences.commit();
                  Logout(token);
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (BuildContext context) => Menu_page()),
                          (Route<dynamic> route) => false);

                },
                leading: Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
                title: Text(
                  "Log Out",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Align(alignment: Alignment.bottomLeft,
                child: (android_version != null) ? Text(
                  "version: ${android_version}",
                  style: TextStyle(color: Colors.white),):Text("")),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Align(alignment: Alignment.bottomLeft,
                child: Text(
                  "${supportEmail}", style: TextStyle(color: Colors.white),)),
          )
        ],
      ),
    );
  }

  Future<void> getData() async {
    var headers = {
      'Cookie': 'XSRF-TOKEN=eyJpdiI6InRLUXdSR1YwM3ZQejZwN2VIQUhNWFE9PSIsInZhbHVlIjoibzdVM25oSWZVY215MWh6L0oyanJuQ1hIWkhjT3lhUStJWm01VmdUUnBhdi9UdFAvMk5OemROMGs3cUF0SXVmL1NCdTdRalo0T1BJV0g4Umx0ZVhIL3V0bGwybS95NVAyeVFZaUZzcC9sTmZWWDZiZFFQeGVuR29tdU1UVXl4d24iLCJtYWMiOiI3MjQ4MTQ4MmYwZTdlNWE5ZjU2NzBlMWRhNzUzZDlmMTAzYzNiMTFiMzMzYTI5Mzc0MWY5OTBhOTA0MTU0MjQxIn0%3D; laravel_session=eyJpdiI6Ink5N0lNcUxZeW9UNjZLMTliQ1BnaUE9PSIsInZhbHVlIjoiUWpYYVhvQVdLYWZQTDRxcVpGV09JNzV6Mnp0cVhXeDFuMzdzckVKNWVMNE9VT1o3RVRKT2prSDZzR3U4aFdUNjZDbFdrUm1YSkFzMThaRFRxendIWmF1TnJ2TG5ISUxIYzVBeU1OUXRRY3NrNXYvSFhBM3N4OXdJTnNnVFlYMWIiLCJtYWMiOiJiYmVhYzM3NDRlYWFmOWY5ZjZhOGM3MWQ2MzkyYTQyYTM0MzE5M2UyN2NlYjM2MDBlN2FmZjY0M2I5NWI2MjU5In0%3D'
    };
    var request = http.Request(
        'GET', Uri.parse('http://appadmin1.xyz/api/setting'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var newdata = await response.stream.bytesToString();
      var result = json.decode(newdata)['message'];
      setState(() {
        android_version = result['android_version'];
        supportEmail = result['support_email'];
      });
    }
    else {
      print(response.reasonPhrase);
    }
  }

  Future<void> Logout(String token) async {
    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer ${token}',
      'Cookie': 'XSRF-TOKEN=eyJpdiI6ImxGWWdPWmpZaXR1Z1lHTzRIZUw2ZlE9PSIsInZhbHVlIjoiWXJQT0'
          'cvclVsL09Ud1VOTGNVUlpiakZxZ0Ezdno2MlRuMDZVWkJJT0hHL2U1Sm1UaGNTbHgzQ1lGUjc1bFhsMDMzZ'
          'Dk4WE9zSklidjRFVjBwdFRGSTNWV0FFR2Y0UTNXU241ZkNqZDRycDZldlllQlVjMW9HaW5HUU9wNDg1SjYiL'
          'CJtYWMiOiIwMzM4NWFmNTc1MjYyNDkwNTQ2ZTdhMjJjNTRhM2U3MzFhOWRlODc5MjBkMzRjYmFjODA2YzY2M'
          'TNlMWQ1ZjEwIn0%3D; laravel_session=eyJpdiI6IjBNN1VGSm5peXdTUDlLMGNpRUdyREE9PSIsInZhbHV'
          'lIjoiTzV0eExMaTM0UGVGUk8rc3Zwb1RxRWNyZUEvUHcvN1hMZ0E2WGVITHZLZ1lKZXFoQy96NDlrb05CamRIMUN'
          'ZbGRRSmdxRVFFNEIrZ1pqZTI4dEhuVTdWOHJZdXRCUVpUdm5tUXhQb204blN1K1IzQTVZbTFIUFp6dUkxcTFXM1Ei'
          'LCJtYWMiOiI2Y2MxOTkwNzA3ODQwYjJkZDhiZTY1YjdlM2YwNWY0YTE1YWU4NDBiNWVhMGU2YWFhNGU3NmJkOTMyNGRi'
          'N2FkIn0%3D'
    };
    var request = http.Request('GET', Uri.parse('http://appadmin1.xyz/api/logout'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      Fluttertoast.showToast(msg: "User Logged out");
      print(await response.stream.bytesToString());

    }
    else {
    print(response.reasonPhrase);
    }

  }
}
