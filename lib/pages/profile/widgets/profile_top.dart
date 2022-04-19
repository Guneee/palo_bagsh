import 'package:flutter/material.dart';
import 'package:palo/data.dart';
import '../../../constants.dart';
import '../../../helpers/app_preferences.dart';
import '../../../helpers/components.dart';
import '../../profile_edit/profile_edit_page.dart';

class ProfileTop extends StatelessWidget {
  const ProfileTop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = size(context).height;
    double width = size(context).width;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            spreadRadius: 1.0,
            blurRadius: 5.0,
            color: kShadowColor,
            offset: Offset(0.0, 5.0),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(12.0),
          bottomRight: Radius.circular(12.0),
        ),
        child: Material(
          color: Colors.white,
          child: SizedBox(
            height: height * 0.2,
            width: width,
            child: Column(
              children: [
                SizedBox(height: height * 0.02),
                Ctext(
                  text: "Миний мэдээлэл",
                  color: Colors.black.withOpacity(0.8),
                  normal: true,
                ),
                SizedBox(height: height * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: width * 0.07),
                    SizedBox(
                      height: height * 0.08,
                      width: width * 0.24,
                      child: Stack(
                        children: [
                          if (currentUserAvatar == "")
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                height: height * 0.08,
                                width: height * 0.08,
                                decoration: BoxDecoration(
                                  color: Color(0xFF610BEF),
                                  borderRadius: BorderRadius.circular(50.0),
                                ),
                                child: Center(
                                  child: Ctext(
                                    text: currentUserLastName.substring(0, 2),
                                    bold: true,
                                    large: true,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          if (currentUserAvatar != "")
                            Align(
                              alignment: Alignment.centerLeft,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50.0),
                                child: Image.network(
                                  currentUserAvatar,
                                  height: height * 0.08,
                                  width: height * 0.08,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Padding(
                              padding: EdgeInsets.only(left: width * 0.12),
                              child: Container(
                                height: height * 0.02,
                                width: height * 0.02,
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  border: Border.all(
                                    width: 2.0,
                                    color: Colors.white,
                                  ),
                                  borderRadius: BorderRadius.circular(50.0),
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: InkWell(
                              onTap: () {
                                go(context, const ProfileEditPage());
                              },
                              child: Image.asset(
                                "assets/edit_icon.png",
                                height: height * 0.028,
                                width: height * 0.028,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: width * 0.04),
                    Expanded(
                      child: Center(
                        child: Ctext(
                          text: currentUserFirstName
                                  .substring(0, 1)
                                  .toUpperCase() +
                              "." +
                              currentUserLastName,
                          normal: true,
                          bold: true,
                          textOverflow: TextOverflow.ellipsis,
                          maxLine: 2,
                        ),
                      ),
                    ),
                    SizedBox(width: width * 0.06),
                    if (user["verify"] == "Татгалзсан" ||
                        user["verify"] == null)
                      Image.asset(
                        "assets/danger.png",
                        height: height * 0.08,
                        width: height * 0.08,
                        fit: BoxFit.contain,
                      ),
                    if (user["verify"] == "Баталсан")
                      Image.asset(
                        "assets/shield.png",
                        height: height * 0.08,
                        width: height * 0.08,
                        fit: BoxFit.contain,
                      ),
                    SizedBox(width: width * 0.07),
                  ],
                ),
                if (user["verify"] == "Татгалзсан" || user["verify"] == null)
                  SizedBox(height: height * 0.005),
                if (user["verify"] == "Татгалзсан" || user["verify"] == null)
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.only(right: width * 0.14),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.error,
                            color: Colors.yellow,
                          ),
                          SizedBox(width: width * 0.02),
                          Ctext(
                            text: "Бүртгэлээ баталгаажуулна уу",
                            color: Colors.yellow,
                            extraSmall: true,
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
