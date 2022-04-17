import 'package:flutter/material.dart';
import 'package:palo/helpers/app_preferences.dart';

import '../../constants.dart';
import '../../data.dart';
import '../../helpers/components.dart';
import 'login_page.dart';
import 'register_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) {
    double height = size(context).height;
    double width = size(context).width;
    return Scaffold(
      backgroundColor: Colors.white,
      bottomSheet: (token == "")
          ? DraggableScrollableSheet(
              expand: true,
              initialChildSize: 0.26,
              minChildSize: 0.26,
              maxChildSize: 0.26,
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return SingleChildScrollView(
                  controller: scrollController,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24.0),
                      topRight: Radius.circular(24.0),
                    ),
                    child: Container(
                      color: kBackgroundColor,
                      child: Column(
                        children: [
                          SizedBox(height: height * 0.01),
                          Container(
                            width: width * 0.06,
                            height: 2.0,
                            color: Colors.black.withOpacity(0.2),
                          ),
                          SizedBox(height: height * 0.05),
                          Container(
                            decoration: BoxDecoration(
                              color: kPrimaryColor,
                              borderRadius: BorderRadius.circular(16.0),
                              border: Border.all(
                                width: 2.0,
                                color: kPrimaryColor,
                              ),
                            ),
                            child: Material(
                              borderRadius: BorderRadius.circular(16.0),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(16.0),
                                onTap: () {
                                  go(context, const LoginPage());
                                },
                                child: SizedBox(
                                  height: height * 0.056,
                                  width: width * 0.84,
                                  child: Center(
                                    child: Ctext(
                                      color: Colors.white,
                                      text: "Нэвтрэх",
                                      large: true,
                                      bold: true,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: height * 0.02),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.0),
                              border: Border.all(
                                width: 2.0,
                                color: kPrimaryColor,
                              ),
                            ),
                            child: Material(
                              borderRadius: BorderRadius.circular(16.0),
                              color: Colors.white,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(16.0),
                                onTap: () {
                                  go(context, const RegisterPage());
                                },
                                child: SizedBox(
                                  height: height * 0.056,
                                  width: width * 0.84,
                                  child: Center(
                                    child: Ctext(
                                      color: kPrimaryColor,
                                      text: "Бүртгүүлэх",
                                      large: true,
                                      bold: true,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: height * 0.1),
                        ],
                      ),
                    ),
                  ),
                );
              },
            )
          : null,
      body: SizedBox(
        height: height,
        width: width,
        child: Stack(
          children: [
            _authButtons(height, width),
          ],
        ),
      ),
    );
  }

  Widget _authButtons(double height, double width) => SizedBox(
        height: height,
        width: width,
        child: Stack(
          children: [
            Image.asset(
              "assets/splash1.jpeg",
              fit: BoxFit.cover,
              height: height,
              width: width,
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.only(
                  top: height * 0.2,
                ),
                child: Text(
                  "PALO",
                  style: TextStyle(
                    shadows: <Shadow>[
                      Shadow(
                        offset: Offset(0.0, 3.0),
                        blurRadius: 3.0,
                        color: Colors.black.withOpacity(0.3),
                      ),
                    ],
                    fontFamily: "TimesNewRoman",
                    color: Colors.black,
                    fontSize: height * 0.058,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}
