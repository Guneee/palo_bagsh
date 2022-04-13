import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as https;
import 'package:palo/helpers/app_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants.dart';
import '../../data.dart';
import '../../helpers/api_url.dart';
import '../../helpers/components.dart';

class RegisterPage2 extends StatefulWidget {
  final String phone;
  final String password;
  const RegisterPage2({
    Key? key,
    required this.phone,
    required this.password,
  }) : super(key: key);

  @override
  _RegisterPage2State createState() => _RegisterPage2State();
}

class _RegisterPage2State extends State<RegisterPage2> {
  final GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();
  bool _isLoad = false;
  final _userFirstNameTEC = TextEditingController();
  final _userLastNameTEC = TextEditingController();
  final _userAgeTEC = TextEditingController();
  bool? _isMale;

  Future<void> _registerRequest() async {
    if (_userFirstNameTEC.text.isNotEmpty &&
        _userLastNameTEC.text.isNotEmpty &&
        _userAgeTEC.text.isNotEmpty &&
        _isMale != null) {
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
          'firstname': _userFirstNameTEC.text.toString(),
          'lastname': _userLastNameTEC.text.toString(),
          'phone': widget.phone.toString(),
          'age': _userAgeTEC.text.toString(),
          'password': widget.password.toString(),
        },
      );
      var body = json.decode(responce.body);
      print(body);
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
        _saveUserData(widget.phone, widget.password, currentUserEmail,
            currentUserId, currentUserFirstName, currentUserLastName);

        if (kDebugMode) {
          print("Logged in!");
        }
        goHome(context);
      }
      if (mounted) {
        setState(() {
          _isLoad = false;
        });
      }
    } else {
      showSnackBar("Бүх хэсэгийг бөглөнө үү!", globalKey);
    }
  }

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

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: globalKey,
      backgroundColor: Colors.white,
      body: SizedBox(
        height: height,
        width: width,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _top(height, width),
                SizedBox(height: height * 0.16),
                Padding(
                  padding: EdgeInsets.only(
                    right: width * 0.06,
                    left: width * 0.06,
                  ),
                  child: Opacity(
                    opacity: 0.7,
                    child: TextFormField(
                      controller: _userFirstNameTEC,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: height * 0.022,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Овог',
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
                      controller: _userLastNameTEC,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: height * 0.022,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Нэр',
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
                      controller: _userAgeTEC,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: height * 0.022,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Нас',
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
                SizedBox(height: height * 0.03),
                Row(
                  children: [
                    SizedBox(width: width * 0.04),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16.0),
                        child: Material(
                          color: _isMale != null
                              ? (_isMale!
                                  ? kPrimaryColor
                                  : Colors.grey.withOpacity(0.3))
                              : Colors.grey.withOpacity(0.3),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _isMale = true;
                              });
                            },
                            child: SizedBox(
                              height: height * 0.07,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Ctext(
                                    text: "Эрэгтэй",
                                    color: Colors.white,
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
                    SizedBox(width: width * 0.03),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16.0),
                        child: Material(
                          color: _isMale != null
                              ? (!_isMale!
                                  ? kPrimaryColor
                                  : Colors.grey.withOpacity(0.3))
                              : Colors.grey.withOpacity(0.3),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _isMale = false;
                              });
                            },
                            child: SizedBox(
                              height: height * 0.07,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Ctext(
                                    text: "Эмэгтэй",
                                    color: Colors.white,
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
                    SizedBox(width: width * 0.04),
                  ],
                ),
                SizedBox(height: height * 0.03),
                ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: Material(
                    color: _userFirstNameTEC.text.isNotEmpty &&
                            _userLastNameTEC.text.isNotEmpty &&
                            _userAgeTEC.text.isNotEmpty &&
                            _isMale != null
                        ? kPrimaryColor
                        : Color(0xFFEBEBF0),
                    child: InkWell(
                      onTap: () {
                        if (!_isLoad) {
                          _registerRequest();
                        }
                      },
                      child: AnimatedSize(
                        curve: Curves.fastOutSlowIn,
                        duration: const Duration(milliseconds: 375),
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: height * 0.016,
                            bottom: height * 0.016,
                            left: _isLoad ? width * 0.04 : width * 0.28,
                            right: _isLoad ? width * 0.04 : width * 0.28,
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
                                  text: "Бүртгүүлэх",
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
                SizedBox(height: height * 0.11),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Ctext(
                      text: "Нэвтрэх",
                      small: true,
                    ),
                    SizedBox(height: height * 0.01),
                    Material(
                      color: Colors.grey.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(50.0),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(50.0),
                        onTap: null,
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
          top: height * 0.01,
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
