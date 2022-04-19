import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:palo/constants.dart';
import 'package:palo/data.dart';
import 'package:palo/helpers/app_preferences.dart';
import 'package:palo/helpers/components.dart';

class ProfileAccountContainer extends StatelessWidget {
  final CurrencyTextInputFormatter formatter;
  const ProfileAccountContainer({
    Key? key,
    required this.formatter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = size(context).height;
    double width = size(context).width;
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: width * 0.06,
            right: width * 0.04,
            top: height * 0.02,
            bottom: height * 0.006,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Ctext(
                text: "ДАНС",
                normal: true,
              ),
              InkWell(
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Ctext(
                        text: "Түүх арах",
                        normal: true,
                        color: kPrimaryColor,
                      ),
                      SizedBox(width: width * 0.04),
                      Icon(
                        Icons.arrow_forward,
                        color: Colors.black.withOpacity(0.7),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                spreadRadius: 1.0,
                blurRadius: 5.0,
                color: kShadowColor,
                offset: Offset(0.0, 4.0),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: Material(
              color: Colors.white,
              child: SizedBox(
                height: height * 0.22,
                width: width * 0.9,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Ctext(
                      text: "Боломжит үлдэгдэл:",
                      color: Colors.black.withOpacity(0.6),
                      small: true,
                    ),
                    SizedBox(height: height * 0.01),
                    Text(
                      formatter.format(
                        currentUserMoney != "" ? currentUserMoney : "0",
                      ),
                      style: TextStyle(
                        color: kPrimaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: height * 0.04,
                      ),
                    ),
                    SizedBox(height: height * 0.01),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4.0),
                        border: Border.all(
                          width: 1.0,
                          color: kPrimaryColor,
                        ),
                      ),
                      child: Material(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4.0),
                        child: InkWell(
                          onTap: () {},
                          borderRadius: BorderRadius.circular(4.0),
                          child: Padding(
                            padding: EdgeInsets.only(
                              right: width * 0.04,
                              left: width * 0.04,
                              top: height * 0.01,
                              bottom: height * 0.01,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  height: height * 0.026,
                                  width: height * 0.026,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 1.5,
                                      color: kPrimaryColor,
                                    ),
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.add,
                                      color: kPrimaryColor.withOpacity(0.5),
                                      size: height * 0.016,
                                    ),
                                  ),
                                ),
                                SizedBox(width: width * 0.03),
                                Ctext(
                                  text: "Таталт хийх",
                                  color: Colors.black,
                                  small: true,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
