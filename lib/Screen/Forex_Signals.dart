import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tranding_signal_system/Constants.dart';
import 'package:tranding_signal_system/CustomWidget/drawer.dart';
import 'package:tranding_signal_system/Models/Forex_model.dart';
import 'package:tranding_signal_system/Services/local_Notifications.dart';

class Forex_signals extends StatefulWidget {
  const Forex_signals({Key key}) : super(key: key);

  @override
  _Forex_signalsState createState() => _Forex_signalsState();
}

class _Forex_signalsState extends State<Forex_signals> {
  Datum datum;
  List<Datum> data_list = [];
  final f = new DateFormat('yyyy-MM-dd hh:mm');
  String token;
  Timer timer;
  SharedPreferences sp;

  @override
  void initState() {
    getsp();
    super.initState();
    FirebaseMessaging.onMessage.listen((message) {
      if (message.notification != null) {
        _refreshData();
      }
    //  LocalNotificationService.display(message);

    });
  }

  getsp() async {
    sp = await SharedPreferences.getInstance();
    setState(() {
      token = sp.get("token");
       timer = Timer.periodic(Duration(minutes: 1), (Timer t) => _getData(token));
    });
  }

  @override
  Widget build(BuildContext context) {
    final Height = MediaQuery.of(context).size.height;
    final Width = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: backgroundcolor,
      appBar: AppBar(
        title: Text("Active Forex Signals"),
        backgroundColor: backgroundcolor,
      ),
      body: SingleChildScrollView(
          child: Container(
              height: Height - 60,
              width: Width,
              child:  RefreshIndicator(
                  color: Colors.white,
                  backgroundColor: Colors.purple,
                  triggerMode: RefreshIndicatorTriggerMode.anywhere,
                  onRefresh: _refreshData,
                  child: FutureBuilder<List<Datum>>(
                  future: _getData(token),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      );
                    } else if (snapshot.connectionState ==
                        ConnectionState.none) {
                      return Center(
                          child:
                              Text("Please Enable your Internet Connection!"));
                    } else if (snapshot.connectionState ==
                        ConnectionState.done) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        );
                      } else {
                        return Container(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListView.builder(
                                itemCount: snapshot.data.length,
                                itemBuilder: (context, index) {
                                  return Card(
                                    color: (data_list[index]
                                            .type
                                            .toLowerCase()
                                            .startsWith("buy"))
                                        ? Colors.green
                                        : Colors.red,
                                    child: ListTile(
                                        title: Text(
                                          "${data_list[index].symbol}",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Type: " + data_list[index].type,
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            Text(
                                              "Opened at:" +
                                                  f.format(new DateTime
                                                          .fromMillisecondsSinceEpoch(
                                                      data_list[index]
                                                          .createdAt
                                                          .millisecondsSinceEpoch)),
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            (data_list[index].deletedAt != null)
                                                ? Text(
                                                    "Closed at: " +
                                                        f.format(new DateTime
                                                                .fromMillisecondsSinceEpoch(
                                                            data_list[index]
                                                                .deletedAt
                                                                .millisecondsSinceEpoch)),
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  )
                                                : Text(
                                                    "Closed at: None",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                          ],
                                        ),
                                        trailing: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "tp: " + data_list[index].tp,
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              "sl: " + data_list[index].sl,
                                              style: TextStyle(
                                                  color: Colors.white),
                                            )
                                          ],
                                        )),
                                  );
                                }),
                          ),
                        );
                      }
                    } else {
                      return Container(
                        child: Center(
                          child: Text("Unable to load data"),
                        ),
                      );
                    }
                  })),
        ),
      ),
    );
  }

  Future<List<Datum>> _getData(String token) async {
    var headers = {'Authorization': 'Bearer ${token}'};
    var request =
        http.Request('GET', Uri.parse('http://appadmin1.xyz/api/get/forex'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var newdata = await response.stream.bytesToString();
      var result = json.decode(newdata)['data'];
      if (data_list.isEmpty) {
        for (var results in result) {
          data_list.add(Datum.fromJson(results));
      } } else {
    return data_list;
    }
      print(result);
      return data_list;
    } else {
      print(response.reasonPhrase);
    }
  }

  Future _refreshData() async {
    await Future.delayed(Duration(seconds: 2));
    data_list.clear();
    _getData(token);
    setState(() {});
  }
}
