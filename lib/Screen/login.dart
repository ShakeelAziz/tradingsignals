import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tranding_signal_system/Constants.dart';
import 'package:tranding_signal_system/Screen/dashboard.dart';
import 'menu.dart';
import 'package:device_info/device_info.dart';


class Login extends StatefulWidget {
  String deviceid;
  Login({key, this.deviceid}): super(key: key);
  @override
  _LoginState createState() => _LoginState(deviceid);
}

class _LoginState extends State<Login> {
  String deviceid;
  _LoginState(String deviceid){
    this.deviceid= deviceid;
  }
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  bool _isLoading = false;
  FirebaseMessaging fcm = FirebaseMessaging.instance;
  String device_token;
  bool is_visible = false;
  var errorMsg;
  String kpassword;

@override
  void initState() {
  getId();
  fcm.getToken().then((token) =>
  setState(() {
    device_token = token;
    print(device_token);
  })
  );
    super.initState();


}
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: backgroundcolor,
          appBar: AppBar(automaticallyImplyLeading: true,elevation: 0,backgroundColor: backgroundcolor,),
          body:SingleChildScrollView(
            child: Column(mainAxisAlignment:MainAxisAlignment.center,children: [
              Center(child: Text("Log In",style: TextStyle(fontSize: 30,color: Colors.white),)),
            Container(
              child: Image(image: AssetImage("assets/logo_new.png"),height: 250,),
            ),
            SizedBox(height: 20,),

            Container(
              color: backgroundcolor,
              child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white24,
                              borderRadius: BorderRadius.circular(10)),
                          child: TextFormField(
                            controller: emailController,
                            style: TextStyle(color: Colors.white),
                            keyboardType: TextInputType.emailAddress,
                            // inputFormatters: [
                            //   LengthLimitingTextInputFormatter(12),
                            //   FilteringTextInputFormatter.allow(
                            //       RegExp("[0-9,@#*&^%?_/>< a-z A-Z]"))
                            // ],
                            validator: (val) {
                              if (val.isEmpty) {
                                return "Please enter email ";
                              }
                            },
                            decoration: InputDecoration(
                                filled: true,
                                border: InputBorder.none,

                                // fillColor: const Color(0xFF1e2742),
                                hintText: "Email",
                                hintStyle: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 12.0, bottom: 10.0, left: 20.0, right: 20.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white24,
                              borderRadius: BorderRadius.circular(10)),
                          child: TextFormField(
                            controller: passController,
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: true,
                            style: TextStyle(color: Colors.white),
                            // inputFormatters: [
                            //   LengthLimitingTextInputFormatter(12),
                            //   FilteringTextInputFormatter.allow(
                            //       RegExp("[0-9,@#*&^%?/>< a-z A-Z]"))
                            // ],
                            validator: (val) {
                              if (val.isEmpty || val.length <= 2) {
                                return "Password must contain more than 2";
                              }
                            },
                            decoration: InputDecoration(
                                filled: true,
                                border: InputBorder.none,

                                //  fillColor: const Color(0xFF1e2742),
                                hintText: "Password",
                                hintStyle: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ),
                      InkWell(
                          onTap: () {
                            setState(() {
                              _isLoading = true;

                            });
                            if (_formKey.currentState.validate()) {
                              is_visible = true;
                              signIn(emailController.text, passController.text, deviceid,device_token);
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 20.0, left: 20, right: 20),
                            child: Container(
                              height: 45,
                              child: Center(
                                  child: Text(
                                    "Log In",
                                    style: TextStyle(color: backgroundcolor),
                                  )),
                              decoration: BoxDecoration(
                                  color: Colors.white70,
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                          )),
                      Padding(
                        padding: const EdgeInsets.only(top: 10, right: 22.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              " ",
                              style: TextStyle(color: Colors.red, fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                        const EdgeInsets.only(top: 30.0, left: 20, right: 20),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white24,
                              borderRadius: BorderRadius.circular(0)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text((DateFormat.d()!=null)?
                              "Device ID: ${deviceid}":"Getting Device Id...",
                              style: TextStyle(color: Colors.white70),
                            ),
                          ),
                        ),
                      ),
                      Visibility(visible: is_visible,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(child: CircularProgressIndicator(
                              color: Colors.white,),),
                          ))
                    ],
                  ),
                ),
            ),
            ]),
          ),
        ),
      ),
    );
  }

  // Future signIn(String email, pass)async
  // {
  //   var request = http.MultipartRequest('POST', Uri.parse('http://appadmin1.xyz/api/login'));
  //   request.fields.addAll({
  //     'email': email,
  //     'password': pass
  //   });
  //
  //
  //   http.StreamedResponse response = await request.send();
  //
  //   if (response.statusCode == 200) {
  //     print(await response.stream.bytesToString());
  //   }
  //   else {
  //     print(response.reasonPhrase);
  //   }
  //
  //
  // }

  signIn(String email, String pass, String deviceId, String device_token) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {'email': email, 'password': pass, "device_key":deviceId, "device_token": device_token};
    String url = 'http://appadmin1.xyz/api/login';
    var jsonResponse = null;
    var response = await http.post(Uri.parse(url), body: data);
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      if (jsonResponse != null) {
        setState(() {
          _isLoading = false;
          kpassword = pass;
          print(kpassword);
        });
        Fluttertoast.showToast(
            msg: "User Logged in Successfully", toastLength: Toast.LENGTH_LONG);
        sharedPreferences.setString("token", jsonResponse['data']['token']);
        sharedPreferences.setString("email", jsonResponse['data']['email']);
        sharedPreferences.setString("name", jsonResponse['data']['name']);
        sharedPreferences.setString("pass", pass);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => Dashboard()),
                (Route<dynamic> route) => false);
      }
    } else {
      setState(() {
        _isLoading = false;
        is_visible=false;
      });
      errorMsg = json.decode(response.body)["message"];
      _showDialog(errorMsg);
      print("The error message is: ${response.body}");
    }
  }

  _showDialog(String msg) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error Signing In:"),
            content: Text(msg),
            actions: [
              MaterialButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  emailController.clear();
                  passController.clear();

                },
                child: Text("Ok"),
              )
            ],
          );
        });
  }

  getId() async{

    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

     deviceid =  androidInfo.model;
  }


}
