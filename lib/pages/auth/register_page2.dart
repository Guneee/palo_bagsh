import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:palo/helpers/app_preferences.dart';

import '../../constants.dart';
import 'register_page3.dart';

class RegisterPage2 extends StatefulWidget {
  final String phone;
  const RegisterPage2({Key? key, required this.phone}) : super(key: key);

  @override
  _RegisterPage2State createState() => _RegisterPage2State();
}

class _RegisterPage2State extends State<RegisterPage2> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  final _userTEC = TextEditingController();

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
                      keyboardType: TextInputType.emailAddress,
                      controller: _userTEC,
                      decoration: InputDecoration(
                        labelText: 'И-мэйл хаяг',
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
                          if (_userTEC.text.contains("@") &&
                              _userTEC.text.contains("mail") &&
                              _userTEC.text.contains(".")) {
                            Navigator.push(
                              context,
                              PageTransition(
                                duration: Duration(milliseconds: 200),
                                type: PageTransitionType.rightToLeft,
                                child: RegisterPage3(
                                  email: _userTEC.text,
                                  phone: widget.phone,
                                ),
                              ),
                            );
                          } else {
                            showSnackBar("Зөв и-майл оруулна уу", _key);
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
                  "Бүртгүүлэх",
                  style: TextStyle(
                    fontSize: height * 0.024,
                  ),
                ),
                Text(
                  "Алхам 2/5",
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
