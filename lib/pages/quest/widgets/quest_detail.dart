import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:palo/data.dart';
import 'package:palo/helpers/app_preferences.dart';
import 'package:palo/pages/quest/widgets/quest_step.dart';

import '../../../constants.dart';
import '../../../helpers/components.dart';

class QuestDetail extends StatefulWidget {
  final int index;
  final int index2;
  const QuestDetail({
    Key? key,
    required this.index,
    required this.index2,
  }) : super(key: key);

  @override
  State<QuestDetail> createState() => _QuestDetailState();
}

class _QuestDetailState extends State<QuestDetail> {
  int index = 0, index2 = 0;
  bool _isLoad = false;

  void _begin() async {
    setState(() {
      _isLoad = true;
    });

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isLoad = false;
      });

      go(
        context,
        QuestStep(
          index: index,
          index2: index2,
        ),
      );
    });
  }

  @override
  void initState() {
    index = widget.index;
    index2 = widget.index2;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: (index % 2 == 1) ? kBtnColor : kPrimaryColor,
        centerTitle: true,
        elevation: 0.0,
        title: Ctext(
          text: questItems[index]["title"].toString(),
          textOverflow: TextOverflow.ellipsis,
          color: (index % 2 == 1) ? Colors.white : kBtnColor,
          large: true,
        ),
        leading: IconButton(
          onPressed: () {
            back(context);
          },
          icon: Icon(
            Icons.close,
            color: (index % 2 == 1) ? Colors.white : kBtnColor,
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
                  if (questItems[index]["quest"][index2]["image"] != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Image.network(
                        questItems[index]["quest"][index2]["image"].toString(),
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
                        text: questItems[index]["quest"][index2]["title"]
                            .toString(),
                        maxLine: 3,
                        bold: true,
                        color: Colors.white,
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
                            text: questItems[index]["quest"][index2]
                                    ["created_at"]
                                .toString()
                                .substring(0, 10),
                            bold: true,
                            color: Colors.white.withOpacity(0.5),
                            normal: true,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Ctext(
                                text: questItems[index]["quest"][index2]
                                        ["amount"]
                                    .toString(),
                                extraLarge: true,
                                color: Colors.white,
                                bold: true,
                              ),
                              Ctext(
                                text: "оноо",
                                normal: true,
                                color: Colors.white,
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
                        questItems[index]["quest"][index2]["content"]
                            .toString(),
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          color: Colors.white,
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
                        color: kBtnColor,
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
