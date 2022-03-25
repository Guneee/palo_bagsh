import 'package:flutter/material.dart';
import 'package:palo/constants.dart';
import 'package:palo/data.dart';
import 'package:palo/helpers/app_preferences.dart';
import 'package:palo/helpers/components.dart';
import 'package:palo/pages/quest/widgets/quest_list.dart';

class QuestBox extends StatelessWidget {
  final int index;
  final int length;
  const QuestBox({
    Key? key,
    required this.index,
    required this.length,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    if ((index % 2) == 0) {
      return Padding(
        padding: EdgeInsets.only(
          top: (index == 0) ? height * 0.04 : 0.0,
          right: width * 0.04,
          left: width * 0.04,
          bottom: (index == length - 1) ? height * 0.04 : 0.0,
        ),
        child: SizedBox(
          width: width,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.only(top: height * 0.01),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Material(
                      color: Colors.white.withOpacity(0.2),
                      child: InkWell(
                        onTap: () {
                          go(context, QuestList(index: index));
                        },
                        child: SizedBox(
                          height: height * 0.056,
                          width: width * 0.68,
                          child: Center(
                            child: Ctext(
                              text: questItems[index]["title"].toString(),
                              color: Colors.white,
                              normal: true,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              if (index != 0)
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.only(right: width * 0.08),
                    child: Container(
                      decoration: BoxDecoration(
                        color: kBtnColor,
                      ),
                      height: height * 0.1,
                      width: 1.5,
                    ),
                  ),
                ),
              if (index != length - 2)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: width * 0.08),
                    child: Container(
                      decoration: BoxDecoration(
                        color: kPrimaryColor,
                      ),
                      height: height * 0.1,
                      width: 1.5,
                    ),
                  ),
                ),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  decoration: BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  height: height * 0.08,
                  width: height * 0.08,
                  child: Center(
                    child: Text(
                      (index + 1).toString(),
                      style: TextStyle(
                        fontSize: height * 0.026,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.only(
          right: width * 0.04,
          left: width * 0.04,
          bottom: (index == length - 1) ? height * 0.04 : 0.0,
        ),
        child: SizedBox(
          width: width,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.only(top: height * 0.01),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Material(
                      color: Colors.white.withOpacity(0.2),
                      child: InkWell(
                        onTap: () {
                          go(context, QuestList(index: index));
                        },
                        child: SizedBox(
                          height: height * 0.056,
                          width: width * 0.68,
                          child: Center(
                            child: Ctext(
                              text: questItems[index]["title"].toString(),
                              color: Colors.white,
                              normal: true,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              if (index != length - 1)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: width * 0.08),
                    child: Container(
                      decoration: BoxDecoration(
                        color: kPrimaryColor,
                      ),
                      height: height * 0.1,
                      width: 1.5,
                    ),
                  ),
                ),
              if (index != length - 1)
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.only(right: width * 0.08),
                    child: Container(
                      decoration: BoxDecoration(
                        color: kBtnColor,
                      ),
                      height: height * 0.1,
                      width: 1.5,
                    ),
                  ),
                ),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  decoration: BoxDecoration(
                    color: kBtnColor,
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  height: height * 0.08,
                  width: height * 0.08,
                  child: Center(
                    child: Text(
                      (index + 1).toString(),
                      style: TextStyle(
                        fontSize: height * 0.026,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
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
}
