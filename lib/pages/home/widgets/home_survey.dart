import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../data.dart';
import '../../../helpers/app_preferences.dart';
import '../../../helpers/components.dart';
import '../survey_detail.dart';

class HomeSurvey extends StatelessWidget {
  const HomeSurvey({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = size(context).height;
    double width = size(context).width;
    return Padding(
      padding: EdgeInsets.only(top: height * 0.02),
      child: Container(
        height: height * 0.56,
        width: width,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: width * 0.056,
                right: width * 0.06,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Ctext(
                    text: "СУДАЛГАА",
                    large: true,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Ctext(
                        text: "+" + surveys.length.toString(),
                        large: true,
                        color: kPrimaryColor,
                      ),
                      SizedBox(width: width * 0.036),
                      Icon(
                        Icons.arrow_forward,
                        color: Colors.black.withOpacity(0.6),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: surveys.length,
                itemBuilder: (context, index) => Padding(
                  padding: EdgeInsets.only(
                    left: index == 0 ? width * 0.055 : width * 0.02,
                    right: width * 0.02,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [
                        BoxShadow(
                          spreadRadius: 1.0,
                          blurRadius: 3.0,
                          color: kShadowColor.withOpacity(0.06),
                          offset: Offset(0.0, 5.0),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: height * 0.015,
                        bottom: height * 0.015,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12.0),
                        child: Material(
                          color: Colors.white,
                          child: InkWell(
                            onTap: () {
                              go(context, SurveyDetailTemp(index: index));
                            },
                            child: SizedBox(
                              width: width * 0.88,
                              child: Column(
                                children: [
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12.0),
                                      child: Image.network(
                                        surveys[index]["image"],
                                        width: width * 0.88,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                  left: width * 0.03,
                                                  top: height * 0.005,
                                                ),
                                                child: Ctext(
                                                  text: surveys[index]["title"],
                                                  large: true,
                                                  bold: true,
                                                  maxLine: 2,
                                                  textOverflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                  left: width * 0.03,
                                                  top: height * 0.005,
                                                ),
                                                child: Ctext(
                                                  text: surveys[index]
                                                      ["content"],
                                                  normal: true,
                                                  maxLine: 2,
                                                  textOverflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                            right: width * 0.02,
                                            left: width * 0.02,
                                          ),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: Ctext(
                                                      text: "-20:40:20",
                                                      extraSmall: true,
                                                      textOverflow:
                                                          TextOverflow.ellipsis,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  Text(
                                                    "2022.4.20 (дуусна)",
                                                    style: TextStyle(
                                                      color: kGreyColor,
                                                      fontSize: height * 0.015,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 4.0),
                                              Stack(
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      12.0,
                                                    ),
                                                    child: Container(
                                                      width: double.infinity,
                                                      height: 6.0,
                                                      color: kGreyColor
                                                          .withOpacity(0.4),
                                                    ),
                                                  ),
                                                  // 100% = 0.86
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      12.0,
                                                    ),
                                                    child: Container(
                                                      width: width * 0.43,
                                                      height: 6.0,
                                                      color: kPrimaryColor,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                            right: width * 0.03,
                                            left: width * 0.03,
                                            bottom: height * 0.016,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Ctext(
                                                  text: surveys[index]
                                                          ["price"] +
                                                      "₮",
                                                  large: true,
                                                  bold: true,
                                                  textOverflow:
                                                      TextOverflow.ellipsis,
                                                  color: kPrimaryColor,
                                                ),
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50.0),
                                                  border: Border.all(
                                                    width: 1.0,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(4.0),
                                                  child: Icon(
                                                    Icons.arrow_forward_ios,
                                                    size: height * 0.018,
                                                  ),
                                                ),
                                              ),
                                            ],
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
                    ),
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
