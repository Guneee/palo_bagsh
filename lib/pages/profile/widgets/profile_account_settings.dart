import 'package:flutter/material.dart';
import 'package:palo/helpers/app_preferences.dart';

import '../../../constants.dart';
import '../../../data.dart';
import '../../../helpers/components.dart';

class ProfileAccountSettings extends StatefulWidget {
  const ProfileAccountSettings({Key? key}) : super(key: key);

  @override
  State<ProfileAccountSettings> createState() => _ProfileAccountSettingsState();
}

class _ProfileAccountSettingsState extends State<ProfileAccountSettings> {
  @override
  Widget build(BuildContext context) {
    double height = size(context).height;
    double width = size(context).width;
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: width * 0.06,
            right: width * 0.06,
            top: height * 0.03,
            bottom: height * 0.02,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Ctext(
                text: "Миний цэс",
                normal: true,
                color: Colors.black.withOpacity(0.7),
              ),
              Image.asset(
                "assets/profile_menu_icon.png",
                height: height * 0.03,
                width: height * 0.03,
                fit: BoxFit.cover,
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            left: width * 0.058,
            right: width * 0.058,
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  spreadRadius: 1.0,
                  blurRadius: 5.0,
                  color: kShadowColor.withOpacity(0.1),
                  offset: Offset(0.0, 3.0),
                ),
              ],
            ),
            child: Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
              child: InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            left: width * 0.02,
                            right: width * 0.02,
                            top: height * 0.014,
                            bottom: height * 0.014,
                          ),
                          child: Image.asset(
                            "assets/profile_star_icon.png",
                            height: height * 0.03,
                            width: height * 0.03,
                          ),
                        ),
                        Container(
                          height: height * 0.03,
                          width: 1.5,
                          color: kGreyColor,
                        ),
                        SizedBox(
                          width: width * 0.01,
                        ),
                        Ctext(
                          text: "Ажилтнаар бүртгүүлэх",
                          large: true,
                          bold: true,
                          color: kTextGreyColor,
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: width * 0.02),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.black.withOpacity(0.5),
                        size: height * 0.03,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            top: height * 0.02,
            left: width * 0.058,
            right: width * 0.058,
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  spreadRadius: 1.0,
                  blurRadius: 5.0,
                  color: kShadowColor.withOpacity(0.1),
                  offset: Offset(0.0, 3.0),
                ),
              ],
            ),
            child: Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
              child: InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            left: width * 0.02,
                            right: width * 0.02,
                            top: height * 0.014,
                            bottom: height * 0.014,
                          ),
                          child: Image.asset(
                            "assets/profile_setting_icon.png",
                            height: height * 0.03,
                            width: height * 0.03,
                          ),
                        ),
                        Container(
                          height: height * 0.03,
                          width: 1.5,
                          color: kGreyColor,
                        ),
                        SizedBox(
                          width: width * 0.01,
                        ),
                        Ctext(
                          text: "Тохиргоо",
                          large: true,
                          bold: true,
                          color: kTextGreyColor,
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: width * 0.02),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.black.withOpacity(0.5),
                        size: height * 0.03,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            top: height * 0.02,
            left: width * 0.058,
            right: width * 0.058,
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  spreadRadius: 1.0,
                  blurRadius: 5.0,
                  color: kShadowColor.withOpacity(0.1),
                  offset: Offset(0.0, 3.0),
                ),
              ],
            ),
            child: Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
              child: InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            left: width * 0.02,
                            right: width * 0.02,
                            top: height * 0.014,
                            bottom: height * 0.014,
                          ),
                          child: Image.asset(
                            "assets/profile_faq_icon.png",
                            height: height * 0.03,
                            width: height * 0.03,
                          ),
                        ),
                        Container(
                          height: height * 0.03,
                          width: 1.5,
                          color: kGreyColor,
                        ),
                        SizedBox(
                          width: width * 0.01,
                        ),
                        Ctext(
                          text: "Түгээмэл асуулт хариулт",
                          large: true,
                          bold: true,
                          color: kTextGreyColor,
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: width * 0.02),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.black.withOpacity(0.5),
                        size: height * 0.03,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            top: height * 0.02,
            left: width * 0.058,
            right: width * 0.058,
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  spreadRadius: 1.0,
                  blurRadius: 5.0,
                  color: kShadowColor.withOpacity(0.1),
                  offset: Offset(0.0, 3.0),
                ),
              ],
            ),
            child: Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
              child: InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            left: width * 0.02,
                            right: width * 0.02,
                            top: height * 0.014,
                            bottom: height * 0.014,
                          ),
                          child: Image.asset(
                            "assets/profile_help_icon.png",
                            height: height * 0.03,
                            width: height * 0.03,
                          ),
                        ),
                        Container(
                          height: height * 0.03,
                          width: 1.5,
                          color: kGreyColor,
                        ),
                        SizedBox(
                          width: width * 0.01,
                        ),
                        Ctext(
                          text: "Тусламж",
                          large: true,
                          bold: true,
                          color: kTextGreyColor,
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: width * 0.02),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.black.withOpacity(0.5),
                        size: height * 0.03,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            top: height * 0.02,
            left: width * 0.058,
            right: width * 0.058,
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  spreadRadius: 1.0,
                  blurRadius: 5.0,
                  color: kShadowColor.withOpacity(0.1),
                  offset: Offset(0.0, 3.0),
                ),
              ],
            ),
            child: Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
              child: InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            left: width * 0.02,
                            right: width * 0.02,
                            top: height * 0.014,
                            bottom: height * 0.014,
                          ),
                          child: Image.asset(
                            "assets/profile_aboutus_icon.png",
                            height: height * 0.03,
                            width: height * 0.03,
                          ),
                        ),
                        Container(
                          height: height * 0.03,
                          width: 1.5,
                          color: kGreyColor,
                        ),
                        SizedBox(
                          width: width * 0.01,
                        ),
                        Ctext(
                          text: "Бидний тухай",
                          large: true,
                          bold: true,
                          color: kTextGreyColor,
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: width * 0.02),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.black.withOpacity(0.5),
                        size: height * 0.03,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            top: height * 0.02,
            left: width * 0.058,
            right: width * 0.058,
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  spreadRadius: 1.0,
                  blurRadius: 5.0,
                  color: kShadowColor.withOpacity(0.1),
                  offset: Offset(0.0, 3.0),
                ),
              ],
            ),
            child: Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
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
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("ҮГҮЙ"),
                        ),
                        TextButton(
                          onPressed: () {
                            final isFinish = clearUserData();
                            if (isFinish) {
                              goHome(context);
                            }
                          },
                          child: Text("ТИЙМ"),
                        ),
                      ],
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            left: width * 0.02,
                            right: width * 0.02,
                            top: height * 0.014,
                            bottom: height * 0.014,
                          ),
                          child: Icon(
                            Icons.exit_to_app,
                            color: kPrimaryColor,
                            size: height * 0.03,
                          ),
                        ),
                        Container(
                          height: height * 0.03,
                          width: 1.5,
                          color: kGreyColor,
                        ),
                        SizedBox(
                          width: width * 0.01,
                        ),
                        Ctext(
                          text: "Системээс гарах",
                          large: true,
                          bold: true,
                          color: kTextGreyColor,
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: width * 0.02),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.black.withOpacity(0.5),
                        size: height * 0.03,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: height * 0.06),
      ],
    );
  }
}
