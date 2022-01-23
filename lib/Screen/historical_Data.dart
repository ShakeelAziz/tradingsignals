import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tranding_signal_system/CustomWidget/drawer.dart';
import 'package:tranding_signal_system/Models/Forex_model.dart';
import 'package:http/http.dart' as http;

import '../Constants.dart';

class Historical_Data extends StatefulWidget {
  const Historical_Data({Key key}) : super(key: key);

  @override
  _Historical_DataState createState() => _Historical_DataState();
}

class _Historical_DataState extends State<Historical_Data> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: SafeArea(
        child: Scaffold(
            backgroundColor: backgroundcolor,
            appBar: AppBar(
              backgroundColor: backgroundcolor,
              title: Text("Closed Signals"),
              bottom: PreferredSize(
                  preferredSize: Size.fromHeight(55),
                  child: TabBar(
                    tabs: [
                      Tab(
                        icon: Icon(Icons.import_export),
                        text: "Forex",
                      ),
                      Tab(
                        icon: Icon(Icons.moving_outlined),
                        text: "Crypto",
                      ),
                    ],
                  )),
            ),
            body: TabBarView(children: [
              Forex(),
              Crypto(),
            ]),),
      ),
    );
  }
}

class Forex extends StatefulWidget {
  const Forex({Key key}) : super(key: key);

  @override
  _ForexState createState() => _ForexState();
}

class _ForexState extends State<Forex> {
  List<Datum> forex_list = [];
  final f = new DateFormat('yyyy-MM-dd hh:mm');

  @override
  Widget build(BuildContext context) {
    final Height = MediaQuery.of(context).size.height;
    final Width = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Container(
          height: Height - 60,
          width: Width,
          child: FutureBuilder<List<Datum>>(
              future: getForex(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  );
                } else if (snapshot.connectionState == ConnectionState.none) {
                  return Center(
                      child: Text("Please Enable your Internet Connection!"));
                } else if (snapshot.connectionState == ConnectionState.done) {
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
                        child:RefreshIndicator(
                          color: Colors.white,
                          backgroundColor: Colors.purple,
                          triggerMode: RefreshIndicatorTriggerMode.anywhere,
                          onRefresh: _refreshData,
                          child: ListView.builder(
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  child: ListTile(
                                      title: Text("${forex_list[index].symbol}"),
                                      subtitle: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              "Type: " + forex_list[index].type),
                                          Text(
                                            "Opened at:" +
                                                f.format(new DateTime
                                                    .fromMillisecondsSinceEpoch(
                                                    forex_list[index]
                                                        .createdAt
                                                        .millisecondsSinceEpoch)),
                                          ),
                                          (forex_list[index].deletedAt != null)
                                              ? Text(
                                            "Closed at: " +
                                                f.format(DateTime.parse(
                                                    forex_list[index]
                                                        .deletedAt
                                                        )),
                                          )
                                              : Text(
                                            "Closed at: None",
                                            style: TextStyle(
                                                color: Colors.white),
                                          ),
                                        ],
                                      ),
                                      trailing:(forex_list[index].profit != null)
                                          ? Text("Profit: " +
                                          forex_list[index].profit)
                                          : Text("Profit: (-)")
                                     ),
                                );
                              }),
                        ),
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
    );
  }

  Future<List<Datum>> getForex() async {
    var headers = {
      'Accept': 'application/json'
    };
    var request = http.Request('GET', Uri.parse('https://appadmin1.xyz/api/get/all/historical/forex'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
        if (response.statusCode == 200) {
      var newdata = await response.stream.bytesToString();
      var result = json.decode(newdata)['data'];
      if(forex_list.isEmpty)
      for (var results in result) {
        forex_list.add(Datum.fromJson(results));
      }else return forex_list;
      print(result);
      return forex_list;
    } else {
      print(response.reasonPhrase);
    }
  }
  Future _refreshData() async {
    await Future.delayed(Duration(seconds: 2));
    forex_list.clear();
    getForex();
    setState(() {});
  }
}

class Crypto extends StatefulWidget {
  const Crypto({Key key}) : super(key: key);

  @override
  _CryptoState createState() => _CryptoState();
}

class _CryptoState extends State<Crypto> {
  List<Datum> crypto_list = [];
  final f = new DateFormat('yyyy-MM-dd hh:mm');
  @override
  Widget build(BuildContext context) {
    final Height = MediaQuery.of(context).size.height;
    final Width = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Container(
          height: Height - 60,
          width: Width,
          child: FutureBuilder<List<Datum>>(
              future: getCrypto(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  );
                } else if (snapshot.connectionState == ConnectionState.none) {
                  return Center(
                      child: Text("Please Enable your Internet Connection!"));
                } else if (snapshot.connectionState == ConnectionState.done) {
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
                        child:RefreshIndicator(
                          color: Colors.white,
                          backgroundColor: Colors.purple,
                          triggerMode: RefreshIndicatorTriggerMode.anywhere,
                          onRefresh: _refreshData,
                          child: ListView.builder(
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  child: ListTile(
                                      title: Text("${crypto_list[index].symbol}"),
                                      subtitle: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              "Type: " + crypto_list[index].type),
                                          Text(
                                            "Opened at:" +
                                                f.format(new DateTime
                                                        .fromMillisecondsSinceEpoch(
                                                    crypto_list[index]
                                                        .createdAt.millisecondsSinceEpoch)),
                                          ),
                                          (crypto_list[index].deletedAt != null)
                                              ? Text(
                                                  "Closed at: " +
                                                      f.format(DateTime.parse(
                                                          crypto_list[index]
                                                              .deletedAt
                                                      )),
                                                )
                                              : Text(
                                                  "Closed at: None",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                        ],
                                      ),
                                      trailing:
                                          (crypto_list[index].profit != null)
                                              ? Text("Profit: " +
                                                  crypto_list[index].profit)
                                              : Text("Profit: -")),
                                );
                              }),
                        ),
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
    );
  }

  Future<List<Datum>> getCrypto() async {
    var headers = {
      'Accept': 'application/json'
    };
    var request = http.Request('GET', Uri.parse('https://appadmin1.xyz/api/get/all/historical/crypto'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var newdata = await response.stream.bytesToString();
      var result = json.decode(newdata)['data'];
      if(crypto_list.isEmpty)
      for (var results in result) {
        crypto_list.add(Datum.fromJson(results));
      }else return crypto_list;
      print(result);
      return crypto_list;
    } else {
      print(response.reasonPhrase);
    }
  }
  Future _refreshData() async {
    await Future.delayed(Duration(seconds: 2));
    crypto_list.clear();
    getCrypto();
    setState(() {});
  }
}
