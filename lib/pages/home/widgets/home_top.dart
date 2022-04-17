import 'package:flutter/material.dart';
import 'package:palo/constants.dart';
import 'package:palo/helpers/app_preferences.dart';
import 'package:palo/pages/home/video_page.dart';

import '../../../helpers/components.dart';

class HomeTop extends StatelessWidget {
  const HomeTop({Key? key}) : super(key: key);

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
            height: height * 0.19,
            width: width,
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: width * 0.04,
                      top: height * 0.01,
                    ),
                    child: IconButton(
                      onPressed: () {},
                      icon: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50.0),
                          border: Border.all(
                            width: 1.5,
                            color: Colors.black,
                          ),
                        ),
                        child: Icon(
                          Icons.more_horiz,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.08,
                  width: width,
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: EdgeInsets.only(top: height * 0.02),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12.0),
                            child: Material(
                              color: Colors.white,
                              child: InkWell(
                                onTap: () {
                                  go(context, const VideoPage());
                                },
                                child: Container(
                                  width: width * 0.88,
                                  height: height * 0.06,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12.0),
                                    border: Border.all(
                                      width: 1.5,
                                      color: kPrimaryColor,
                                    ),
                                  ),
                                  child: Center(
                                    child: Ctext(
                                      text: "Видео үзэх",
                                      bold: true,
                                      normal: true,
                                      color: kPrimaryColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: EdgeInsets.only(
                            right: width * 0.06,
                            bottom: height * 0.04,
                          ),
                          child: Image.asset(
                            "assets/video_icon.png",
                            height: height * 0.06,
                            width: height * 0.06,
                            fit: BoxFit.contain,
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
    );
  }
}
