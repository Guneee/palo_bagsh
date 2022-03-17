import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:palo/constants.dart';
import 'package:palo/data.dart';
import 'package:palo/helpers/app_preferences.dart';
import 'package:palo/pages/quest/widgets/quest_detail.dart';

import '../../../helpers/components.dart';

class QuestList extends StatelessWidget {
  final int index;
  const QuestList({
    Key? key,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: (index % 2 == 1) ? kBtnColor : kPrimaryColor,
        centerTitle: true,
        elevation: 0.0,
        title: Ctext(
          text: quests[index]["title"].toString(),
          color: Colors.white,
          large: true,
        ),
        leading: IconButton(
          onPressed: () {
            back(context);
          },
          icon: Icon(
            Icons.close,
            color: Colors.white,
          ),
        ),
      ),
      body: SizedBox(
        height: height,
        width: width,
        child: SingleChildScrollView(
          child: AnimationLimiter(
            child: Column(
              children: AnimationConfiguration.toStaggeredList(
                duration: const Duration(milliseconds: 375),
                childAnimationBuilder: (widget) => SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(
                    child: widget,
                  ),
                ),
                children: List.generate(
                  1,
                  (index) => Padding(
                    padding: EdgeInsets.only(
                      left: width * 0.06,
                      right: width * 0.06,
                      top: (index == 0) ? height * 0.03 : height * 0.01,
                      bottom: (index == 1) ? height * 0.03 : height * 0.02,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            spreadRadius: 1.0,
                            blurRadius: 3.0,
                            color: Colors.black.withOpacity(0.05),
                            offset: Offset(3.0, 3.0),
                          )
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12.0),
                        child: Material(
                          color: Colors.white,
                          child: InkWell(
                            onTap: () {
                              go(
                                context,
                                QuestDetail(index: index),
                              );
                            },
                            child: SizedBox(
                              height: height * 0.1,
                              width: width,
                              child: Padding(
                                padding: EdgeInsets.only(
                                  left: width * 0.05,
                                  right: width * 0.04,
                                  top: height * 0.01,
                                  bottom: height * 0.01,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Ctext(
                                              text: "Нүүрний тос",
                                              bold: true,
                                              textOverflow:
                                                  TextOverflow.ellipsis,
                                              normal: true,
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Ctext(
                                              text:
                                                  "Манай тос бүх арьсанд зориулсан эд юм. Та хэрэглээд үзээд ямар байгааг хэлээрэй.",
                                              maxLine: 2,
                                              small: true,
                                              textOverflow:
                                                  TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: width * 0.02),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Ctext(
                                          text: "1,000",
                                          color: kBtnColor,
                                          bold: true,
                                          large: true,
                                        ),
                                        Ctext(
                                          text: "оноо",
                                          normal: true,
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
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
