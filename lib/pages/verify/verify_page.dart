import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:palo/constants.dart';
import 'package:http/http.dart' as https;
import 'package:palo/helpers/api_url.dart';
import 'package:palo/helpers/app_preferences.dart';
import '../../data.dart';
import '../../helpers/components.dart';

class VerifyPage extends StatefulWidget {
  const VerifyPage({Key? key}) : super(key: key);

  @override
  State<VerifyPage> createState() => _VerifyPageState();
}

class _VerifyPageState extends State<VerifyPage> {
  final GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();
  bool _isLoad = false;

  Future<void> _request() async {
    setState(() {
      _isLoad = true;
    });

    final response = await https.post(
      Uri.parse(mainApiUrl + "v1/verify-request"),
      body: {
        'user_id': user["id"].toString(),
      },
    );

    if (response.statusCode == 201) {
      var body = json.decode(response.body);
      if (body["status"]) {
        showSnackBar("Амжилттай хүсэлт илгээгдлээ", globalKey);
      } else {
        showSnackBar("Хэрэглэгч олдсонгүй", globalKey);
      }
    } else if (response.statusCode == 202) {
      var body = json.decode(response.body);
      showSnackBar(body["message"], globalKey);
    } else {
      print("Verify page request error =" + response.body.toString());
      showSnackBar(
        "Сервер алдаа гарлаа, Та манайхтай холбоо барина уу",
        globalKey,
      );
    }

    if (mounted) {
      setState(() {
        _isLoad = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: globalKey,
      backgroundColor: kBtnColor,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: kBtnColor,
        centerTitle: true,
        title: Ctext(
          text: "Баталгаажуулалт",
          color: Colors.white,
          large: true,
          bold: true,
        ),
        leading: Padding(
          padding: EdgeInsets.only(left: width * 0.03),
          child: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: width * 0.03),
            child: IconButton(
              onPressed: null,
              icon: Icon(
                Icons.verified,
                color:
                    (user["verify"] == "Баталсан") ? Colors.green : Colors.red,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SizedBox(
          width: width,
          height: height,
          child: SingleChildScrollView(
            child: AnimationLimiter(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: AnimationConfiguration.toStaggeredList(
                  duration: const Duration(milliseconds: 375),
                  childAnimationBuilder: (widget) => SlideAnimation(
                    verticalOffset: 50.0,
                    child: FadeInAnimation(
                      child: widget,
                    ),
                  ),
                  children: [
                    SizedBox(height: height * 0.02),
                    Material(
                      color: Colors.white.withOpacity(0.14),
                      child: InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text("Баталгаажуулалт"),
                              actions: [
                                IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: Icon(Icons.close),
                                ),
                              ],
                              content: SingleChildScrollView(
                                child: SizedBox(
                                  width: width,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "Алхам 1",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: height * 0.02),
                                      Column(
                                        children: [
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                                "- Profile хуудасны 'Хэрэглэгч' цэс рүү орох"),
                                          ),
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                                "- Оршин суугаа хаягаа бүрэн зөв оруулах"),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: height * 0.02),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "Алхам 2",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: height * 0.02),
                                      Column(
                                        children: [
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                                "- Profile хуудасны 'Хэрэглэгч' цэс рүү орох"),
                                          ),
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              "- Ирэгний үнэмлэхний ардтал",
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              "- Ирэгний үнэмлэхний урдтал",
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              "- Ирэгний үнэмлэхтэй хамт авхуулсан зурагаа оруулах",
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: height * 0.02),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "Алхам 3",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: height * 0.02),
                                      Column(
                                        children: [
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                                "- Profile хуудасны 'Данс' цэс рүү орох"),
                                          ),
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              "- Банкны нэр",
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              "- Данс эзэмшигчийн нэр",
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              "- Дансны дугаар",
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: height * 0.02),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "Алхам 4",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: height * 0.02),
                                      Column(
                                        children: [
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                                "- Profile хуудасны 'Баталгаажуулалт' цэс рүү орох"),
                                          ),
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              "- Хүсэлт илгээх",
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        child: Container(
                          height: height * 0.12,
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.only(
                                left: width * 0.06,
                                right: width * 0.06,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (user["verify"] != "Баталсан")
                                    Text(
                                      "🤨",
                                      style: TextStyle(fontSize: height * 0.08),
                                    ),
                                  if (user["verify"] == "Баталсан")
                                    Text(
                                      "😊",
                                      style: TextStyle(fontSize: height * 0.08),
                                    ),
                                  SizedBox(width: width * 0.05),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      if (user["verify"] == "Баталсан")
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Ctext(
                                            text: "Баталсан",
                                            color: Colors.white,
                                            bold: true,
                                            large: true,
                                          ),
                                        ),
                                      if (user["verify"] != "Баталсан")
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Ctext(
                                            text: "Баталгаажаагүй",
                                            color: Colors.white,
                                            bold: true,
                                            large: true,
                                          ),
                                        ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Ctext(
                                          text: "Энд дарж заавар харах",
                                          maxLine: 2,
                                          color: Colors.white,
                                          normal: true,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.04),
                    Container(
                      height: height * 0.14,
                      width: width * 0.9,
                      decoration: BoxDecoration(
                        color: kPrimaryColor,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.location_pin,
                              color: Colors.white,
                            ),
                            SizedBox(width: width * 0.02),
                            Ctext(
                              text: "Оршин суугаа хаяг",
                              color: Colors.white,
                              large: true,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.02),
                    Container(
                      height: height * 0.14,
                      width: width * 0.9,
                      decoration: BoxDecoration(
                        color: kPrimaryColor.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.person_search,
                              color: Colors.white,
                            ),
                            SizedBox(width: width * 0.02),
                            Ctext(
                              text: "Үнэмлэхний зураг",
                              color: Colors.white,
                              large: true,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.02),
                    Container(
                      height: height * 0.14,
                      width: width * 0.9,
                      decoration: BoxDecoration(
                        color: kPrimaryColor.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.account_balance,
                              color: Colors.white,
                            ),
                            SizedBox(width: width * 0.02),
                            Ctext(
                              text: "Дансны мэдээлэл",
                              color: Colors.white,
                              large: true,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.03),
                    if (user["verify"] != "Баталсан")
                      Cbutton(
                        text: "Хүсэлт илгээх",
                        normal: true,
                        onPress: () {
                          _request();
                        },
                        isLoad: _isLoad,
                      ),
                    SizedBox(height: height * 0.06),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
