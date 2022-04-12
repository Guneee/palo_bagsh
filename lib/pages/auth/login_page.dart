import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:palo/helpers/app_preferences.dart';
import 'package:palo/pages/auth/register_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data.dart';
import '../../helpers/api_url.dart';
import '../../helpers/components.dart';
import 'package:http/http.dart' as https;
import '../../constants.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  bool _isLoad = false;
  final _userPhoneTEC = TextEditingController();
  final _userPasswordTEC = TextEditingController();

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString("username") != null) {
      _userPhoneTEC.text = prefs.getString("username")!;
    }
    if (prefs.getString("password") != null) {
      _userPasswordTEC.text = prefs.getString("password")!;
    }

    setState(() {});
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
    if (_userPhoneTEC.text.isNotEmpty && _userPasswordTEC.text.isNotEmpty) {
      setState(() {
        _isLoad = true;
      });
      final responce =
          await https.post(Uri.parse(mainApiUrl + "auth/login"), headers: {
        "Authorization": "Bearer $token",
        // "Content-Type": "application/json"
      }, body: {
        'phone': _userPhoneTEC.text.toString(),
        'password': _userPasswordTEC.text.toString()
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
        _saveUserData(
          _userPhoneTEC.text,
          _userPasswordTEC.text,
          currentUserEmail,
          currentUserId,
          currentUserFirstName,
          currentUserLastName,
        );

        if (kDebugMode) {
          print("Logged in!");
        }
        Future.delayed(
          const Duration(milliseconds: 100),
          () {
            goHome(context);
          },
        );
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
      backgroundColor: Colors.white,
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
                SizedBox(height: height * 0.28),
                Padding(
                  padding: EdgeInsets.only(
                    right: width * 0.06,
                    left: width * 0.06,
                  ),
                  child: Opacity(
                    opacity: 0.7,
                    child: TextFormField(
                      keyboardType: TextInputType.phone,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      controller: _userPhoneTEC,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: height * 0.022,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Утасны дугаар',
                        labelStyle: TextStyle(
                          color: kTextColor,
                          fontSize: height * 0.022,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: Colors.grey,
                            width: 2.0,
                          ),
                        ),
                        filled: true,
                        fillColor: Color(0xFFF2F2F5),
                        contentPadding: const EdgeInsets.all(16),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: height * 0.02),
                Padding(
                  padding: EdgeInsets.only(
                    right: width * 0.06,
                    left: width * 0.06,
                  ),
                  child: Opacity(
                    opacity: 0.7,
                    child: TextFormField(
                      controller: _userPasswordTEC,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: height * 0.022,
                      ),
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Нууц үг',
                        labelStyle: TextStyle(
                          color: kTextColor,
                          fontSize: height * 0.022,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: Colors.grey,
                            width: 2.0,
                          ),
                        ),
                        filled: true,
                        fillColor: Color(0xFFF2F2F5),
                        contentPadding: const EdgeInsets.all(16),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: height * 0.024),
                ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: Material(
                    color: _userPhoneTEC.text.isNotEmpty &&
                            _userPasswordTEC.text.isNotEmpty
                        ? kPrimaryColor
                        : Color(0xFFEBEBF0),
                    child: InkWell(
                      onTap: () {
                        if (!_isLoad) {
                          _login();
                        }
                      },
                      child: AnimatedSize(
                        curve: Curves.fastOutSlowIn,
                        duration: const Duration(milliseconds: 375),
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: height * 0.016,
                            bottom: height * 0.016,
                            left: _isLoad ? width * 0.04 : width * 0.35,
                            right: _isLoad ? width * 0.04 : width * 0.35,
                          ),
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
                                Ctext(
                                  color: Colors.white,
                                  text: "Нэвтрэх",
                                  large: true,
                                  bold: true,
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: width * 0.06,
                      top: height * 0.01,
                    ),
                    child: TextButton(
                      onPressed: () {},
                      child: Text("Нууц үг мартсан"),
                    ),
                  ),
                ),
                SizedBox(height: height * 0.13),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Ctext(
                      text: "Бүртгүүлэх",
                      small: true,
                    ),
                    SizedBox(height: height * 0.01),
                    Material(
                      color: kPrimaryColor,
                      borderRadius: BorderRadius.circular(50.0),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(50.0),
                        onTap: () {
                          goRepalce(context, const RegisterPage());
                        },
                        child: Container(
                          height: height * 0.06,
                          width: height * 0.06,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                                size: height * 0.02,
                              ),
                              Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                                size: height * 0.02,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: height * 0.1),
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
                Icons.arrow_back,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
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
