import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:palo/helpers/app_preferences.dart';
import 'package:palo/pages/job/job_page.dart';
import 'package:palo/pages/profile/profile_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../pages/home/survey_form.dart';

import '../../constants.dart';
import '../../data.dart';

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
          index2: index2,
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
      backgroundColor: currentBottomIndex == 1 ? kBtnColor : null,
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
        fixedColor: currentBottomIndex == 0 ? kPrimaryColor : Colors.white,
        backgroundColor: currentBottomIndex == 2 ? kPrimaryColor : Colors.white,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: currentBottomIndex,
        onTap: (int index) {
          if (token != "") {
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 200),
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
                    color: (currentBottomIndex == 2)
                        ? Colors.white.withOpacity(0.4)
                        : Colors.black.withOpacity(0.5),
                  ),
          ),
          BottomNavigationBarItem(
            label: "Ажил",
            icon: (currentBottomIndex == 1)
                ? const Text(
                    "Ажил",
                    style: TextStyle(
                      color: kPrimaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : Icon(
                    Icons.location_history_outlined,
                    color: (currentBottomIndex == 2)
                        ? Colors.white.withOpacity(0.4)
                        : Colors.black.withOpacity(0.5),
                  ),
          ),
          BottomNavigationBarItem(
            label: 'Хэрэглэгчийн хуудас',
            icon: (currentBottomIndex == 2)
                ? const Text(
                    "Профайл",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : Icon(
                    Icons.person_outlined,
                    color: Colors.black.withOpacity(0.5),
                  ),
          ),
        ],
      );
}

class SurveyDetailTemp extends StatefulWidget {
  final int index;
  final int index2;
  const SurveyDetailTemp({
    Key? key,
    required this.index,
    required this.index2,
  }) : super(key: key);

  @override
  _SurveyDetailTempState createState() => _SurveyDetailTempState();
}

class _SurveyDetailTempState extends State<SurveyDetailTemp> {
  final GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();
  late int index, index2;

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
          title: Text("Санамж"),
          content: SingleChildScrollView(
            child: Column(
              children: [
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
            FlatButton(
              onPressed: () {
                _saveIsFirst();
              },
              child: Text("БОЛСОН"),
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
      index2 = widget.index2;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: key,
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
              homeItems[index].surveys[index2]['image'],
              fit: BoxFit.cover,
              height: height * 0.38,
              width: width,
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: height * 0.43),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: width * 0.08,
                      right: width * 0.08,
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        homeItems[index].surveys[index2]['title'],
                        style: TextStyle(
                          fontSize: height * 0.028,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.01),
                  Padding(
                    padding: EdgeInsets.only(
                      left: width * 0.08,
                      right: width * 0.08,
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Text(
                            "Судалгаа оруулсан,",
                            style: TextStyle(
                              fontSize: height * 0.02,
                              color: Colors.black.withOpacity(0.5),
                            ),
                          ),
                          Text(
                            " Админ",
                            style: TextStyle(
                              fontSize: height * 0.02,
                              color: kPrimaryColor.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.004),
                  Padding(
                    padding: EdgeInsets.only(
                      left: width * 0.08,
                      right: width * 0.08,
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Text(
                            "Оруулсан хугацаа,",
                            style: TextStyle(
                              fontSize: height * 0.02,
                              color: Colors.black.withOpacity(0.5),
                            ),
                          ),
                          Text(
                            " " +
                                homeItems[index]
                                    .surveys[index2]["created_at"]
                                    .toString()
                                    .substring(0, 10),
                            style: TextStyle(
                              fontSize: height * 0.02,
                              color: kPrimaryColor.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.03,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: width * 0.08),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                          8.0,
                        ),
                        child: Material(
                          color: kBtnColor,
                          child: InkWell(
                            onTap: () {
                              var existingCall = history.firstWhere(
                                  (favCall) =>
                                      favCall["survey_id"].toString() ==
                                      homeItems[index]
                                          .surveys[index2]["id"]
                                          .toString(),
                                  orElse: () => null);

                              if (existingCall == null) {
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    duration: Duration(milliseconds: 200),
                                    type: PageTransitionType.rightToLeft,
                                    child: SurveyForm(
                                      index2: index2,
                                      index: index,
                                      url: homeItems[index]
                                          .surveys[index2]["form_link"]
                                          .toString(),
                                      money: homeItems[index]
                                          .surveys[index2]["price"]
                                          .toString(),
                                      title: homeItems[index]
                                          .surveys[index2]["title"]
                                          .toString(),
                                    ),
                                  ),
                                );
                              } else {
                                showSnackBar(
                                    "Та аль хэдийн бөглөсөн байна", key);
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "Судалгаа бөглөх",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: height * 0.02,
                                    ),
                                  ),
                                  SizedBox(width: width * 0.02),
                                  const Icon(
                                    Icons.note_add,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.04,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: width * 0.08,
                      right: width * 0.08,
                      bottom: height * 0.04,
                    ),
                    child: Text(
                      homeItems[index].surveys[index2]['content'],
                      textAlign: TextAlign.justify,
                    ),
                  ),
                ],
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
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 0.1,
                      blurRadius: 4,
                      offset: const Offset(3, 3),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Material(
                    color: Colors.grey.shade200.withOpacity(0.5),
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: SizedBox(
                        height: height * 0.06,
                        width: height * 0.06,
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
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
