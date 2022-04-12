import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:page_transition/page_transition.dart';
import 'package:palo/helpers/app_preferences.dart';
import 'package:palo/pages/auth/register_page2.dart';

import '../../constants.dart';
import '../../data.dart';

class OTPVerifyPage extends StatefulWidget {
  final String id;
  final String phone;
  const OTPVerifyPage({
    Key? key,
    required this.id,
    required this.phone,
  }) : super(key: key);

  @override
  _OTPVerifyPageState createState() => _OTPVerifyPageState();
}

class _OTPVerifyPageState extends State<OTPVerifyPage> {
  final GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();
  late Timer _timer;
  late FirebaseAuth _auth;
  int _timeOut = 120;
  bool _isLoad = false;
  String _code = "t";

  void _checkOtpCode() {
    setState(() {
      _isLoad = true;
    });
    _auth = FirebaseAuth.instance;

    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.id, smsCode: _code.toString().trim());
    print(credential.token);

    _auth.signInWithCredential(credential).then((result) {
      isVerify = true;
      Navigator.pushReplacement(
        context,
        PageTransition(
          duration: Duration(milliseconds: 175),
          type: PageTransitionType.rightToLeft,
          child: RegisterPage2(
            phone: widget.phone,
          ),
        ),
      );
    }).catchError((e) {
      showSnackBar("Буруу код байна", key);

      setState(() {
        _isLoad = false;
      });
      print(e);
    });
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_timeOut == 0) {
          setState(() {
            timer.cancel();
            Navigator.pop(context);
          });
        } else {
          setState(() {
            _timeOut--;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: key,
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: height,
            width: width,
            child: Column(
              children: [
                SizedBox(height: height * 0.02),
                _top(height, width),
                SizedBox(height: height * 0.02),
                _body(height, width),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _body(double height, double width) => Column(
        children: [
          Text(
            "Гар утас\nбаталгаажуулах",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: kPrimaryColor,
              fontSize: height * 0.024,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: height * 0.1),
          _codeField(height, width),
          Padding(
            padding: EdgeInsets.only(
              top: height * 0.04,
              right: width * 0.1,
              left: width * 0.1,
            ),
            child: Text(
              "Оруулсан утасны дугаарт ирсэн\n6 оронтой тоог оруулна уу",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: height * 0.018,
              ),
            ),
          ),
          SizedBox(height: height * 0.1),
          ClipRRect(
            borderRadius: BorderRadius.circular(
              18.0,
            ),
            child: Material(
              color: (_code.length == 6)
                  ? kPrimaryColor.withOpacity(0.7)
                  : kBtnColor,
              child: InkWell(
                onTap: () {
                  if (_code.length == 6) {
                    _checkOtpCode();
                  } else {
                    showSnackBar("Код оруулаагүй байна", key);
                  }
                },
                child: SizedBox(
                  height: height * 0.05,
                  width: width * 0.4,
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
                              kBtnColor,
                            ),
                          ),
                        ),
                      if (!_isLoad)
                        Text(
                          "ИЛГЭЭХ",
                          style: TextStyle(
                            color: kBtnColor,
                            fontSize: height * 0.018,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      );

  Widget _codeField(double height, double width) => Padding(
        padding: EdgeInsets.only(
          left: width * 0.08,
          right: width * 0.08,
        ),
        child: OtpTextField(
          numberOfFields: 6,
          focusedBorderColor: kBtnColor,
          borderColor: kPrimaryColor,
          showFieldAsBox: false,
          onCodeChanged: (String code) {
            setState(() {
              _code = code;
            });
          },
          onSubmit: (String verificationCode) {
            setState(() {
              _code = verificationCode;
            });
          },
        ),
      );

  Widget _top(double height, double width) => SizedBox(
        height: height * 0.06,
        child: Padding(
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
              Text(
                "",
                style: TextStyle(
                  fontSize: height * 0.024,
                ),
              ),
              if (_timeOut == 0)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(
                      12.0,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "!!!",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: height * 0.02,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              if (_timeOut != 0)
                Container(
                  decoration: BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.circular(
                      12.0,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      _timeOut.toString() + " sec",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: height * 0.02,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
}
