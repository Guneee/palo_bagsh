import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../../constants.dart';
import 'register_page4.dart';

class RegisterPage3 extends StatefulWidget {
  final String phone;
  final String email;
  const RegisterPage3({
    Key? key,
    required this.phone,
    required this.email,
  }) : super(key: key);

  @override
  _RegisterPage3State createState() => _RegisterPage3State();
}

class _RegisterPage3State extends State<RegisterPage3> {
  final _userTEC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
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
                      style: TextStyle(color: Colors.white),
                      controller: _userTEC,
                      decoration: InputDecoration(
                        labelText: 'Овог',
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
                          Navigator.push(
                            context,
                            PageTransition(
                              duration: Duration(milliseconds: 200),
                              type: PageTransitionType.rightToLeft,
                              child: RegisterPage4(
                                phone: widget.phone,
                                email: widget.email,
                                firstname: _userTEC.text,
                              ),
                            ),
                          );
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
                  "Алхам 3/5",
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
