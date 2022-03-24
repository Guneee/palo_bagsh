import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:palo/data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/pages/home/home_page.dart';
import '/helpers/api_url.dart';
import '/helpers/app_preferences.dart';
import 'package:http/http.dart' as https;
import '../../constants.dart';

class RegisterPage5 extends StatefulWidget {
  final String phone;
  final String email;
  final String firstname;
  final String lastname;
  const RegisterPage5({
    Key? key,
    required this.phone,
    required this.email,
    required this.firstname,
    required this.lastname,
  }) : super(key: key);

  @override
  _RegisterPage5State createState() => _RegisterPage5State();
}

class _RegisterPage5State extends State<RegisterPage5> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  final _userTEC = TextEditingController();
  bool _isLoad = false;

  Future<void> _saveUserData(String username, String password, String email,
      String id, String firstname, String lastname) async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setString("username", username.toString());
    prefs.setString("id", id.toString());
    prefs.setString("password", password.toString());
    prefs.setString("email", email.toString());
    prefs.setString("lastname", lastname.toString());
    prefs.setString("firstname", firstname.toString());
  }

  Future<void> _register() async {
    if (widget.phone.isNotEmpty &&
        widget.email.isNotEmpty &&
        widget.firstname.isNotEmpty &&
        widget.lastname.isNotEmpty &&
        _userTEC.text.isNotEmpty) {
      setState(() {
        _isLoad = true;
      });
      final responce = await https.post(
        Uri.parse(mainApiUrl + "auth/register"),
        headers: {
          "Authorization": "Bearer $token",
          // "Content-Type": "application/json"
        },
        body: {
          'firstname': widget.firstname.toString(),
          'lastname': widget.lastname.toString(),
          'phone': widget.phone.toString(),
          'email': widget.email.toString(),
          'password': _userTEC.text.toString()
        },
      );
      var body = json.decode(responce.body);
      if (responce.statusCode == 201) {
        token = body["access_token"].toString();
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
        _saveUserData(widget.phone, _userTEC.text, currentUserEmail,
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
          print(responce.body.toString());
        }

        showSnackBar("Утасны дугаар давхацсан байна!", _key);
      }
    } else {
      showSnackBar("Бүх хэсэгийг бөглөнө үү!", _key);
    }
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
        child: SafeArea(
          child: Align(
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
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
                      controller: _userTEC,
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
                            if (_userTEC.text.length >= 6) {
                              _register();
                            } else {
                              showSnackBar(
                                  "Таны нууц үг хамгийн багадаа 6 үсэгтэй байх шаардлагатай",
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
                                        Colors.white),
                                  ),
                                ),
                              if (!_isLoad)
                                Text(
                                  "Бүртгүүлэх",
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
                  "Бүртгүүлэх",
                  style: TextStyle(
                    fontSize: height * 0.024,
                    color: Colors.white,
                  ),
                ),
                Text(
                  "Алхам 5/5",
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
