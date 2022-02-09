import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:palo/pages/profile/pull_list.dart';
import 'package:palo/pages/profile/pull_request.dart';
import '/helpers/app_preferences.dart';
import '/pages/profile/profile_account.dart';
import '/pages/profile/all_history.dart';
import '../../pages/auth/login_page.dart';
import '../../pages/auth/register_page.dart';
import '../../constants.dart';
import '../../data.dart';
import 'profile_edit.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  final CurrencyTextInputFormatter _formatter = CurrencyTextInputFormatter(
    locale: "mn",
    decimalDigits: 0,
    symbol: "₮",
  );
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _key,
      backgroundColor: kBtnColor,
      body: SizedBox(
        height: height,
        width: width,
        child: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              children: <Widget>[
                _top(height, width),
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
          if (token == "") _authButtons(height, width),
          if (token != "") _info(height, width),
        ],
      );

  Widget _info(double height, double width) => Column(
        children: [
          SizedBox(height: height * 0.04),
          Container(
            height: height * 0.2,
            width: width * 0.82,
            decoration: BoxDecoration(
              color: kPrimaryColor,
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: width * 0.05,
                          top: height * 0.022,
                        ),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Данс",
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.4),
                                  fontSize: height * 0.022,
                                ),
                              ),
                            ),
                            SizedBox(height: height * 0.008),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (currentUserMoney != "")
                                    Text(
                                      _formatter.format(currentUserMoney),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: height * 0.024,
                                      ),
                                    ),
                                  if (currentUserMoney == "")
                                    Text(
                                      "₮ 0",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: height * 0.024,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: width * 0.05,
                    right: width * 0.03,
                    bottom: height * 0.01,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Нийт бөглөсөн : " + history.length.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: height * 0.02,
                        ),
                      ),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                duration: Duration(milliseconds: 200),
                                type: PageTransitionType.rightToLeft,
                                child: const AllHistory(),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Text(
                                  "түүх ",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: height * 0.02,
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: height * 0.022,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: height * 0.03),
          ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: Material(
              color: kPrimaryColor,
              child: InkWell(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    PageTransition(
                      duration: Duration(milliseconds: 200),
                      type: PageTransitionType.rightToLeft,
                      child: const PullRequestPage(),
                    ),
                  );
                },
                child: SizedBox(
                  height: height * 0.08,
                  width: width * 0.82,
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: width * 0.04,
                      right: width * 0.04,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.request_page,
                              color: Colors.white,
                            ),
                            SizedBox(width: width * 0.02),
                            Text(
                              "Таталт хийх хүсэлт",
                              style: TextStyle(
                                fontSize: height * 0.02,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                          size: height * 0.024,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: height * 0.02),
          ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: Material(
              color: kPrimaryColor.withOpacity(0.6),
              child: InkWell(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    PageTransition(
                      duration: Duration(milliseconds: 200),
                      type: PageTransitionType.rightToLeft,
                      child: const PullList(),
                    ),
                  );
                },
                child: SizedBox(
                  height: height * 0.08,
                  width: width * 0.82,
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: width * 0.04,
                      right: width * 0.04,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.history_toggle_off,
                              color: Colors.white,
                            ),
                            SizedBox(width: width * 0.02),
                            Text(
                              "Таталтын түүх",
                              style: TextStyle(
                                fontSize: height * 0.02,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                          size: height * 0.024,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: height * 0.04),
          Padding(
            padding: EdgeInsets.only(
              left: width * 0.06,
              right: width * 0.06,
            ),
            child: Column(
              children: [
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageTransition(
                          duration: Duration(milliseconds: 200),
                          type: PageTransitionType.rightToLeft,
                          child: const ProfileEdit(),
                        ),
                      );
                    },
                    child: Container(
                      width: width,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.white.withOpacity(0.2),
                            width: 1.0,
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          bottom: 12.0,
                          top: 12.0,
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.person_pin_circle_outlined,
                              color: Colors.white,
                            ),
                            SizedBox(width: width * 0.02),
                            Expanded(
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Хэрэглэгч",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: height * 0.024,
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Хэрэглэгчийн нэр, зураг.. засах",
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.5),
                                        fontSize: height * 0.016,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageTransition(
                          duration: Duration(milliseconds: 200),
                          type: PageTransitionType.rightToLeft,
                          child: const ProfileAccount(),
                        ),
                      );
                    },
                    child: Container(
                      width: width,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.white.withOpacity(0.2),
                            width: 1.0,
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          bottom: 12.0,
                          top: 12.0,
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.account_balance,
                              color: Colors.white,
                            ),
                            SizedBox(width: width * 0.02),
                            Expanded(
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Данс",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: height * 0.024,
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Таталт хийх данс бүртгэх, засах",
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.5),
                                        fontSize: height * 0.016,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => AlertDialog(
                          title: Text("Гарах"),
                          content: SingleChildScrollView(
                            child: Column(
                              children: [
                                Text(
                                  "Та системээс түр гарахад итгэлтэй байна уу?",
                                ),
                              ],
                            ),
                          ),
                          actions: [
                            FlatButton(
                              onPressed: () {
                                final isFinish = clearUserData();
                                if (isFinish) {
                                  goHome(context);
                                } else {
                                  showSnackBar("Алдаа гарлаа", _key);
                                }
                              },
                              child: Text("ГАРАХ"),
                            ),
                            FlatButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("ХААХ"),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Container(
                      width: width,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.white.withOpacity(0.2),
                            width: 1.0,
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          bottom: 12.0,
                          top: 12.0,
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.exit_to_app,
                              color: Colors.white,
                            ),
                            SizedBox(width: width * 0.02),
                            Expanded(
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Гарах",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: height * 0.024,
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Системээс түр гарах",
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.5),
                                        fontSize: height * 0.016,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );

  Widget _authButtons(double height, double width) => SizedBox(
        width: width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: height * 0.24,
            ),
            Container(
              height: height * 0.08,
              width: height * 0.08,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(height * 0.02),
                color: kPrimaryColor.withOpacity(0.9),
              ),
              child: Center(
                child: Icon(
                  Icons.attach_money,
                  color: Colors.white,
                  size: height * 0.05,
                ),
              ),
            ),
            SizedBox(
              height: height * 0.02,
            ),
            Text(
              "SURVEY APP",
              style: TextStyle(
                color: Colors.black.withOpacity(0.6),
                fontSize: height * 0.02,
              ),
            ),
            SizedBox(
              height: height * 0.03,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(
                12.0,
              ),
              child: Material(
                color: kPrimaryColor,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        duration: Duration(milliseconds: 200),
                        type: PageTransitionType.rightToLeft,
                        child: const LoginPage(),
                      ),
                    );
                  },
                  child: SizedBox(
                    height: height * 0.044,
                    width: width * 0.5,
                    child: Center(
                      child: Text(
                        "НЭВТРЭХ",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: height * 0.02,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: height * 0.02,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(
                12.0,
              ),
              child: Material(
                color: kPrimaryColor,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        duration: Duration(milliseconds: 200),
                        type: PageTransitionType.rightToLeft,
                        child: const RegisterPage(),
                      ),
                    );
                  },
                  child: SizedBox(
                    height: height * 0.044,
                    width: width * 0.5,
                    child: Center(
                      child: Text(
                        "БҮРТГҮҮЛЭХ",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: height * 0.02,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  Widget _top(double height, double width) => Padding(
        padding: EdgeInsets.only(
          top: height * 0.02,
        ),
        child: SizedBox(
          height: height * 0.08,
          child: Padding(
            padding: EdgeInsets.only(
              left: width * 0.06,
              right: width * 0.06,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Профайл",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: height * 0.026,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (currentUserAvatar != "")
                  ClipRRect(
                    borderRadius: BorderRadius.circular(height * 0.5),
                    child: Image.network(
                      currentUserAvatar,
                      height: height * 0.08,
                      width: height * 0.08,
                      fit: BoxFit.cover,
                    ),
                  ),
                if (currentUserAvatar == "")
                  SizedBox(
                    height: height * 0.06,
                    child: const Center(
                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
}
