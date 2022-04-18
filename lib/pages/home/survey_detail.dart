import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:palo/helpers/app_preferences.dart';
import 'package:palo/pages/job/job_page.dart';
import 'package:palo/pages/profile/profile_page_old.dart';
import 'package:palo/pages/quest/quest_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../helpers/components.dart';
import '../../pages/home/survey_form.dart';

import '../../constants.dart';
import '../../data.dart';
import '../profile/profile_page.dart';

class SurveyDetail extends StatefulWidget {
  final int index;
  final int index2;
  const SurveyDetail({
    Key? key,
    required this.index,
    required this.index2,
  }) : super(key: key);

  @override
  _SurveyDetailState createState() => _SurveyDetailState();
}

class _SurveyDetailState extends State<SurveyDetail> {
  late int index, index2;

  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  late PageController _pageController;
  bool _isLoad = false;

  List<Widget> tabPages = [];

  void _onPageChanged(int page) {
    if (token != "") {
      setState(() {
        currentBottomIndex = page;
      });
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    if (token != "") {
      _pageController =
          PageController(initialPage: currentBottomIndex, keepPage: true);
    } else {
      _pageController = PageController(initialPage: 0, keepPage: true);
    }
    setState(() {
      index = widget.index;
      index2 = widget.index2;
      tabPages = [
        SurveyDetailTemp(
          index: index,
        ),
        const JobPage(),
        const ProfilePage(),
      ];
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _key,
      backgroundColor: kBackgroundColor,
      bottomNavigationBar: (token != "") ? _bottomNavigationBar() : null,
      body: SizedBox(
        height: height,
        width: width,
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Expanded(
                child: PageView(
                  physics: const NeverScrollableScrollPhysics(),
                  children: tabPages,
                  onPageChanged: _onPageChanged,
                  controller: _pageController,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bottomNavigationBar() => BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        fixedColor: kPrimaryColor,
        backgroundColor: kBtnColor,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: currentBottomIndex,
        onTap: (int index) {
          if (token != "") {
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 175),
              curve: Curves.easeInOut,
            );
          } else {
            showSnackBar("Та эхлээд нэвтрэх хэрэгтэй", _key);
          }
        },
        items: [
          BottomNavigationBarItem(
            label: "Нүүр",
            icon: (currentBottomIndex == 0)
                ? const Text(
                    "Нүүр",
                    style: TextStyle(
                      color: kPrimaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : Icon(
                    Icons.home_outlined,
                    color: Colors.white,
                  ),
          ),
          BottomNavigationBarItem(
            label: "Эрэл",
            icon: (currentBottomIndex == 1)
                ? const Text(
                    "Эрэл",
                    style: TextStyle(
                      color: kPrimaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : Icon(
                    Icons.question_answer_outlined,
                    color: Colors.white,
                  ),
          ),
          BottomNavigationBarItem(
            label: "Ажил",
            icon: (currentBottomIndex == 2)
                ? const Text(
                    "Ажил",
                    style: TextStyle(
                      color: kPrimaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : Icon(
                    Icons.location_history_outlined,
                    color: Colors.white,
                  ),
          ),
          BottomNavigationBarItem(
            label: 'Хэрэглэгчийн хуудас',
            icon: (currentBottomIndex == 3)
                ? const Text(
                    "Профайл",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : Icon(
                    Icons.person_outlined,
                    color: Colors.white,
                  ),
          ),
        ],
      );
}

class SurveyDetailTemp extends StatefulWidget {
  final int index;
  const SurveyDetailTemp({
    Key? key,
    required this.index,
  }) : super(key: key);

  @override
  _SurveyDetailTempState createState() => _SurveyDetailTempState();
}

class _SurveyDetailTempState extends State<SurveyDetailTemp> {
  final GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();
  late int index;
  bool _isLoad = false;

  void _next() {
    setState(() {
      _isLoad = true;
    });

    Future.delayed(
      const Duration(seconds: 1),
      () {
        if (mounted) {
          setState(() {
            _isLoad = false;
          });
          Future.delayed(
            const Duration(milliseconds: 275),
            () {
              var existingCall = history.firstWhere(
                  (favCall) =>
                      favCall["survey_id"].toString() ==
                      surveys[index]["id"].toString(),
                  orElse: () => null);

              if (existingCall == null) {
                go(
                  context,
                  SurveyForm(
                    index: index,
                    url: surveys[index]["form_link"].toString(),
                    money: surveys[index]["price"].toString(),
                    title: surveys[index]["title"].toString(),
                  ),
                );
              } else {
                showSnackBar("Та аль хэдийн бөглөсөн байна", key);
              }
            },
          );
        }
      },
    );
  }

  Future<void> _saveIsFirst() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("isFirstSurvey", "false");
    Navigator.pop(context);
  }

  Future<void> _checkIsFirst() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString("isFirstSurvey") == null) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text("Санамж"),
          content: SingleChildScrollView(
            child: Column(
              children: const [
                Text(
                  "Судалгаа бөглөх алхамууд",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  "Алхам 1: Судалгааны мэдээлэлтэй танилцаж, Хэрвээ бөглөх бол Судалгаа бөглөх товч дээр дарах.",
                  style: TextStyle(fontSize: 13.0),
                ),
                SizedBox(height: 4.0),
                Text(
                  "Алхам 2: Судалгаан дахь заавал бөглөх хэсэгийг бөглөж submit /илгээх/ товч дээр дарах.",
                  style: TextStyle(fontSize: 13.0),
                ),
                SizedBox(height: 4.0),
                Text(
                  "Алхам 3: Судалгаа дээрх шагнал таны аппликейшн дахь дансанд орсон байх болно.",
                  style: TextStyle(fontSize: 13.0),
                ),
                SizedBox(height: 8.0),
                Text("Таньд амжилт хүсье"),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                _saveIsFirst();
              },
              child: const Text("БОЛСОН"),
            ),
          ],
        ),
      );
    }
  }

  @override
  void initState() {
    _checkIsFirst();
    setState(() {
      index = widget.index;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: key,
      backgroundColor: Colors.white,
      body: SizedBox(
        height: height,
        width: width,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              _body(height, width),
            ],
          ),
        ),
      ),
    );
  }

  Widget _body(double height, double width) => Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Image.network(
              surveys[index]['image'],
              fit: BoxFit.cover,
              height: height * 0.38,
              width: width,
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: height * 0.38,
              width: width,
              color: Colors.black.withOpacity(0.3),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: height * 0.36),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Material(
                  color: Colors.white,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          top: height * 0.04,
                          left: width * 0.06,
                          right: width * 0.06,
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: width * 0.56,
                              child: Ctext(
                                text: "Үүсгэсэн огноо:",
                                large: true,
                                color: Colors.black.withOpacity(0.5),
                              ),
                            ),
                            Expanded(
                              child: Ctext(
                                text: " " +
                                    surveys[index]["created_at"]
                                        .toString()
                                        .substring(0, 10),
                                normal: true,
                                color: kTextColor.withOpacity(0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: height * 0.02,
                          left: width * 0.06,
                          right: width * 0.06,
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: width * 0.56,
                              child: Ctext(
                                text: "Судалгаа дуусах огноо:",
                                large: true,
                                color: Colors.black.withOpacity(0.5),
                              ),
                            ),
                            Expanded(
                              child: Ctext(
                                text: " " +
                                    surveys[index]["created_at"]
                                        .toString()
                                        .substring(0, 10),
                                normal: true,
                                color: kTextColor.withOpacity(0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: height * 0.024,
                          left: width * 0.06,
                          right: width * 0.06,
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Ctext(
                            text: surveys[index]["title"],
                            large: true,
                            bold: true,
                            color: kTextColor,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: height * 0.02,
                          left: width * 0.06,
                          right: width * 0.06,
                          bottom: height * 0.04,
                        ),
                        child: Text(
                          surveys[index]['content'],
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            fontSize: height * 0.02,
                            letterSpacing: 1.0,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: height * 0.04,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12.0),
                          child: Material(
                            color: kPrimaryColor,
                            child: InkWell(
                              onTap: () {
                                if (!_isLoad) {
                                  _next();
                                }
                              },
                              child: AnimatedSize(
                                curve: Curves.fastOutSlowIn,
                                duration: const Duration(milliseconds: 375),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    top: height * 0.014,
                                    bottom: height * 0.014,
                                    left: _isLoad ? width * 0.04 : width * 0.25,
                                    right:
                                        _isLoad ? width * 0.04 : width * 0.25,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      if (_isLoad)
                                        SizedBox(
                                          height: height * 0.03,
                                          width: height * 0.03,
                                          child:
                                              const CircularProgressIndicator(
                                            strokeWidth: 1.2,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                              Colors.white,
                                            ),
                                          ),
                                        ),
                                      if (!_isLoad)
                                        Ctext(
                                          color: Colors.white,
                                          text: "Судалгаа бөглөх",
                                          large: true,
                                          bold: true,
                                        ),
                                    ],
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
              ),
            ),
          ),
          SafeArea(
            child: _top(height, width),
          ),
        ],
      );

  Widget _top(double height, double width) => SizedBox(
        height: height * 0.09,
        child: Padding(
          padding: EdgeInsets.only(
            left: width * 0.03,
            right: width * 0.03,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  back(context);
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
              ),
              Text(
                "",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: height * 0.02,
                  fontWeight: FontWeight.w500,
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.done_outline,
                  color: Colors.transparent,
                ),
                onPressed: () {},
              ),
            ],
          ),
        ),
      );
}
