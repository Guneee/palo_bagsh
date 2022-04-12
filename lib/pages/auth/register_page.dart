// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:palo/data.dart';
import 'package:palo/helpers/app_preferences.dart';
import 'package:palo/pages/auth/login_page.dart';

import '../../constants.dart';
import '../../helpers/components.dart';
import 'otp_verify_page.dart';
import 'register_page2.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();
  final _userPhoneTEC = TextEditingController();
  final _userPasswordTEC = TextEditingController();
  late FirebaseAuth _auth;
  bool _isLoad = false;

  Future<void> _registerFirebaseUser(BuildContext context) async {
    setState(() {
      _isLoad = true;
    });
    _auth = FirebaseAuth.instance;

    _auth.verifyPhoneNumber(
      phoneNumber: "+976" + _userPhoneTEC.text.toString(),
      timeout: const Duration(seconds: 120),
      verificationCompleted: _verifyCompleted,
      verificationFailed: _verifyFailed,
      codeSent: _codeSent,
      codeAutoRetrievalTimeout: _timeOut,
    );
  }

  void _verifyCompleted(AuthCredential authCredential) {
    try {
      _auth.signInWithCredential(authCredential);
      Navigator.pushReplacement(
        context,
        PageTransition(
          duration: Duration(milliseconds: 175),
          type: PageTransitionType.rightToLeft,
          child: RegisterPage2(phone: _userPhoneTEC.text),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  void _verifyFailed(error) {
    if (error.toString().contains(
        "We have blocked all requests from this device due to unusual activity. Try again later")) {
      showSnackBar(
          "Таны оролдлого хэтэрсэн байна, Дараа дахин оролдоно уу!", key);
    } else if (error.toString().contains(
        "[firebase_auth/missing-client-identifier] This request is missing a valid app identifier, meaning that neither SafetyNet checks nor reCAPTCHA checks succeeded. Please try again, or check the logcat for more details.")) {
      showSnackBar(
          "reCAPTCHA алдаа гарлаа, Та манайхтай холбоо барина уу!", key);
      Navigator.push(
        context,
        PageTransition(
          duration: Duration(milliseconds: 175),
          type: PageTransitionType.rightToLeft,
          child: RegisterPage2(phone: _userPhoneTEC.text),
        ),
      );
    } else if (error.toString().contains("[firebase_auth/unknown] null")) {
      showSnackBar("Server түр салсан байна. Та дараа дахин оролдоно уу", key);
      Navigator.push(
        context,
        PageTransition(
          duration: Duration(milliseconds: 175),
          type: PageTransitionType.rightToLeft,
          child: RegisterPage2(phone: _userPhoneTEC.text),
        ),
      );
    } else {
      showSnackBar("Алдаа гарлаа, Та манайхтай холбоо барина уу!", key);
      Navigator.push(
        context,
        PageTransition(
          duration: Duration(milliseconds: 175),
          type: PageTransitionType.rightToLeft,
          child: RegisterPage2(phone: _userPhoneTEC.text),
        ),
      );
    }

    print("verify failed error = " + error.toString());
    setState(() {
      _isLoad = false;
    });
  }

  void _codeSent(verificationId, forceResendingToken) {
    print("code sent");
    String id = verificationId;

    setState(() {
      _isLoad = false;
    });
    Navigator.push(
      context,
      PageTransition(
        duration: Duration(milliseconds: 175),
        type: PageTransitionType.rightToLeft,
        child: OTPVerifyPage(
          id: id,
          phone: _userPhoneTEC.text,
        ),
      ),
    );
  }

  void _timeOut(verificationId) {
    print("time out");
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: key,
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
                          _registerFirebaseUser(context);
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
                                  text: "Үргэлжлүүлэх",
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
                SizedBox(height: height * 0.18),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Ctext(
                      text: "Нэвтрэх",
                      small: true,
                    ),
                    SizedBox(height: height * 0.01),
                    Material(
                      color: kPrimaryColor,
                      borderRadius: BorderRadius.circular(50.0),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(50.0),
                        onTap: () {
                          goRepalce(context, const LoginPage());
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
