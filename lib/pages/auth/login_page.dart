import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:palo/helpers/app_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/pages/auth/login_page2.dart';

import '../../constants.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  final _userPhoneTEC = TextEditingController();

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString("username") != null) {
      setState(() {
        _userPhoneTEC.text = prefs.getString("username")!;
      });
    }
  }

  @override
  void initState() {
    _loadUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _key,
      body: Container(
        height: height,
        width: width,
        color: Colors.white,
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
                    keyboardType: TextInputType.phone,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    controller: _userPhoneTEC,
                    decoration: InputDecoration(
                      labelText: 'Хэрэглэгчийн утасны дугаар',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),
                      filled: true,
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
                        if (_userPhoneTEC.text.length >= 8) {
                          Navigator.push(
                            context,
                            PageTransition(
                              duration: Duration(milliseconds: 200),
                              type: PageTransitionType.rightToLeft,
                              child: LoginPage2(
                                email: _userPhoneTEC.text,
                              ),
                            ),
                          );
                        } else {
                          showSnackBar("Зөв утас оруулна уу", _key);
                        }
                      },
                      child: SizedBox(
                        height: height * 0.06,
                        width: width * 0.88,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Цааш",
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
                color: kPrimaryColor,
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
                  ),
                ),
                Text(
                  "Алхам 1/2",
                  style: TextStyle(
                    fontSize: height * 0.012,
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
