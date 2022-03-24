// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '/pages/home/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/helpers/api_url.dart';
import '/helpers/app_preferences.dart';
import 'package:http/http.dart' as https;
import '../../constants.dart';
import '../../data.dart';

class LoginPage2 extends StatefulWidget {
  final String email;
  const LoginPage2({Key? key, required this.email}) : super(key: key);

  @override
  _LoginPage2State createState() => _LoginPage2State();
}

class _LoginPage2State extends State<LoginPage2> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  final _passwordTEC = TextEditingController();
  bool _isLoad = false;

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString("password") != null) {
      setState(() {
        _passwordTEC.text = prefs.getString("password")!;
      });
    }
  }

  Future<void> _saveUserData(String username, String password, String email,
      String id, String firstname, String lastname) async {
    final prefs = await SharedPreferences.getInstance();
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String device = "empty";
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      print('Running on ${androidInfo.model}');
      device = androidInfo.model.toString();
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      print('Running on ${iosInfo.utsname.machine}');
      device = iosInfo.utsname.machine.toString();
    }

    prefs.setString("username", username.toString());
    prefs.setString("id", id.toString());
    prefs.setString("password", password.toString());
    prefs.setString("email", email.toString());
    prefs.setString("lastname", lastname.toString());
    prefs.setString("firstname", firstname.toString());
    prefs.setString("device", device.toString());
  }

  Future<void> _login() async {
    if (widget.email.isNotEmpty && _passwordTEC.text.isNotEmpty) {
      setState(() {
        _isLoad = true;
      });
      final responce =
          await https.post(Uri.parse(mainApiUrl + "auth/login"), headers: {
        "Authorization": "Bearer $token",
        // "Content-Type": "application/json"
      }, body: {
        'phone': widget.email.toString(),
        'password': _passwordTEC.text.toString()
      });
      var body = json.decode(responce.body);
      if (responce.statusCode == 201) {
        token = body["access_token"].toString();
        user = body["user"];
        currentUserFirstName = body["user"]["firstname"] ?? "";
        currentUserLastName = body["user"]["lastname"] ?? "";
        currentUserAvatar = body["user"]["avatar"] ?? "";

        currentUserEmail = body["user"]["email"] ?? "";
        currentUserMoney = body["user"]["money"] ?? "";
        currentUserPhone = body["user"]["phone"] ?? "";
        currentUserId = body["user"]["id"].toString();
        currentUserBank = body["user"]["bank_name"] ?? "";
        currentUserAccount = body["user"]["bank_account"] ?? "";
        currentUserAccountName = body["user"]["bank_account_name"] ?? "";
        currentUserAge = body["user"]["age"] ?? "";
        currentUserGender = body["user"]["gender"] ?? "";
        currentUserIdFront = body["user"]["id_front"] ?? "";
        currentUserIdRear = body["user"]["id_rear"] ?? "";
        userPullRequestItems.clear();
        json.decode(responce.body)["pull_list"].forEach((value) {
          userPullRequestItems.add(value);
        });
        _saveUserData(widget.email, _passwordTEC.text, currentUserEmail,
            currentUserId, currentUserFirstName, currentUserLastName);

        if (kDebugMode) {
          print("Logged in!");
        }
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const HomePage()),
            (Route<dynamic> route) => false);
      } else {
        setState(() {
          _isLoad = false;
        });
        if (kDebugMode) {
          print(responce.body);
        }
        _saveUserData("", "", "", "", "", "");
        showSnackBar("Нууц үг эсвэл утас буруу байна", _key);
      }
    } else {
      showSnackBar("Бүх хэсэгийг бөглөнө үү!", _key);
    }
  }

  void _check() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      print('Running on ${androidInfo.model}');
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      print('Running on ${iosInfo.utsname.machine}');
    }
  }

  @override
  void initState() {
    _check();
    _loadUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _key,
      backgroundColor: kBackgroundColor,
      body: Container(
        height: height,
        width: width,
        child: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: height * 0.02),
                _top(height, width),
                SizedBox(
                  height: height * 0.02,
                ),
                Image.asset(
                  "assets/survey.png",
                  height: height * 0.4,
                ),
                SizedBox(height: height * 0.02),
                Padding(
                  padding: EdgeInsets.only(
                    right: width * 0.06,
                    left: width * 0.06,
                  ),
                  child: TextFormField(
                    controller: _passwordTEC,
                    obscureText: true,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Нууц үг',
                      labelStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.1),
                      contentPadding: const EdgeInsets.all(16),
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.04,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(
                    18.0,
                  ),
                  child: Material(
                    color: kBtnColor,
                    child: InkWell(
                      onTap: () {
                        if (!_isLoad) {
                          if (_passwordTEC.text.length >= 6) {
                            _login();
                          } else {
                            showSnackBar(
                                "Нууц үг хамгийн багадаа 6 үсэгтэй байх шаардлагатай",
                                _key);
                          }
                        }
                      },
                      child: SizedBox(
                        height: height * 0.06,
                        width: width * 0.88,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (_isLoad)
                              SizedBox(
                                height: height * 0.03,
                                width: height * 0.03,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 1.2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              ),
                            if (!_isLoad)
                              Text(
                                "Нэвтрэх",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: height * 0.02,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.1,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _top(double height, double width) => Padding(
        padding: EdgeInsets.only(
          left: width * 0.03,
          right: width * 0.03,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            Column(
              children: [
                Text(
                  "Нэвтрэх",
                  style: TextStyle(
                    fontSize: height * 0.024,
                    color: Colors.white,
                  ),
                ),
                Text(
                  "Алхам 2/2",
                  style: TextStyle(
                    fontSize: height * 0.016,
                    color: kPrimaryColor,
                  ),
                ),
              ],
            ),
            const IconButton(
              icon: Icon(
                Icons.person,
                color: Colors.transparent,
              ),
              onPressed: null,
            ),
          ],
        ),
      );
}
