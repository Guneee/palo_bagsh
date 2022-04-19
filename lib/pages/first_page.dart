import 'package:flutter/material.dart';
import 'package:palo/helpers/app_preferences.dart';
import 'package:palo/helpers/components.dart';
import 'package:palo/pages/auth/auth_page.dart';
import 'package:palo/pages/home/home_page.dart';
import 'package:palo/pages/splash_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  bool _isLoad = false, isLoad = false;

  void _next() {
    setState(() {
      isLoad = true;
    });
    Future.delayed(
      const Duration(seconds: 1),
      () {
        setState(() {
          isLoad = false;
        });
        Future.delayed(
          const Duration(milliseconds: 175),
          () {
            go(context, const SplashPage());
          },
        );
      },
    );
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString("isFirst") != null) {
      goRepalce(context, const HomePage());
    } else {
      setState(() {
        _isLoad = true;
      });
    }
  }

  @override
  void initState() {
    // _loadUserData();
    // setState(() {
    //   _isLoad = true;
    // });
    Future.delayed(
      const Duration(seconds: 1),
      () {
        goRepalce(context, const AuthPage());
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = size(context).height;
    double width = size(context).width;
    return Scaffold(
      backgroundColor: Colors.white,
      bottomSheet: (_isLoad)
          ? DraggableScrollableSheet(
              expand: true,
              initialChildSize: 0.21,
              minChildSize: 0.21,
              maxChildSize: 0.21,
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
                          SizedBox(height: height * 0.04),
                          Text(
                            "Таны сонирхол, Таны ойр",
                            style: TextStyle(
                              color: Color(0xFF8F90A6),
                              fontSize: height * 0.022,
                            ),
                          ),
                          SizedBox(height: height * 0.04),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16.0),
                            child: Material(
                              color: kPrimaryColor,
                              child: InkWell(
                                onTap: () {
                                  if (!isLoad) {
                                    _next();
                                  }
                                },
                                child: AnimatedSize(
                                  curve: Curves.fastOutSlowIn,
                                  duration: const Duration(milliseconds: 375),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      top: height * 0.01,
                                      bottom: height * 0.01,
                                      left:
                                          isLoad ? width * 0.04 : width * 0.34,
                                      right:
                                          isLoad ? width * 0.04 : width * 0.34,
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        if (isLoad)
                                          SizedBox(
                                            height: height * 0.03,
                                            width: height * 0.03,
                                            child:
                                                const CircularProgressIndicator(
                                              strokeWidth: 1.2,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                Colors.white,
                                              ),
                                            ),
                                          ),
                                        if (!isLoad)
                                          Ctext(
                                            color: Colors.white,
                                            text: "Эхлэх",
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
      ),
    );
  }
}
