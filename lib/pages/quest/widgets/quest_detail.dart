import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:palo/data.dart';
import 'package:palo/helpers/app_preferences.dart';
import 'package:palo/pages/quest/widgets/quest_step.dart';

import '../../../constants.dart';
import '../../../helpers/components.dart';

class QuestDetail extends StatefulWidget {
  final int index;
  const QuestDetail({
    Key? key,
    required this.index,
  }) : super(key: key);

  @override
  State<QuestDetail> createState() => _QuestDetailState();
}

class _QuestDetailState extends State<QuestDetail> {
  int index = 0;
  bool _isLoad = false;

  void _begin() async {
    setState(() {
      _isLoad = true;
    });

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isLoad = false;
      });

      go(context, QuestStep(index: index));
    });
  }

  @override
  void initState() {
    index = widget.index;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: (index % 2 == 1) ? kBtnColor : kPrimaryColor,
        centerTitle: true,
        elevation: 0.0,
        title: Ctext(
          text: "Нүүрний тос",
          textOverflow: TextOverflow.ellipsis,
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
                children: [
                  SizedBox(height: height * 0.03),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: Image.network(
                      currentUserAvatar,
                      height: height * 0.2,
                      width: width * 0.9,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: width * 0.06,
                        right: width * 0.06,
                        top: height * 0.02,
                      ),
                      child: Ctext(
                        text: "Нүүрний тос",
                        maxLine: 3,
                        bold: true,
                        color: kPrimaryColor,
                        extraLarge: true,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: width * 0.06,
                        right: width * 0.06,
                        top: height * 0.01,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Ctext(
                            text: "2022-10-12",
                            bold: true,
                            color: Colors.black.withOpacity(0.5),
                            normal: true,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Ctext(
                                text: "1,000",
                                extraLarge: true,
                                color: kPrimaryColor,
                                bold: true,
                              ),
                              Ctext(
                                text: "оноо",
                                normal: true,
                                color: kPrimaryColor,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: width * 0.06,
                        right: width * 0.06,
                        top: height * 0.01,
                      ),
                      child: Text(
                        "Манай тос бүх арьсанд зориулсан эд юм. Та хэрэглээд үзээд ямар байгааг хэлээрэй.",
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          color: kPrimaryColor,
                          letterSpacing: 1.0,
                          fontSize: height * 0.02,
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: width * 0.06,
                        right: width * 0.06,
                        top: height * 0.02,
                      ),
                      child: Cbutton(
                        text: "Эхлэх",
                        large: true,
                        onPress: () {
                          _begin();
                        },
                        isLoad: _isLoad,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
