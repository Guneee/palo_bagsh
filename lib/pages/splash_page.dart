import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:palo/helpers/app_preferences.dart';
import 'package:palo/pages/contract_page.dart';
import 'package:palo/pages/home/home_page.dart';
import 'package:palo/pages/location_ask.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late PageController _pageController;
  int _selectedIndex = 0;
  bool _isLoad = false;

  void _skip() {
    go(context, const ContractPage());
  }

  void _next() {
    if (_selectedIndex == 3) {
      go(context, const ContractPage());
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 275),
        curve: Curves.easeIn,
      );
    }
  }

  void _back() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 275),
      curve: Curves.easeOut,
    );
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString("isFirst") != null) {
      Navigator.pushReplacement(
        context,
        PageTransition(
          duration: Duration(milliseconds: 175),
          type: PageTransitionType.rightToLeft,
          child: const HomePage(),
        ),
      );
    } else {
      setState(() {
        _isLoad = true;
      });
    }
  }

  @override
  void initState() {
    // _loadUserData();
    setState(() {
      _isLoad = true;
    });
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        height: height,
        width: width,
        child: Stack(
          children: [
            // Content pages
            if (_isLoad)
              SizedBox(
                height: height,
                width: width,
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (int index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  children: [
                    _page1(height, width),
                    _page2(height, width),
                    _page3(height, width),
                    _page4(height, width),
                  ],
                ),
              ),
            // Top
            if (_isLoad)
              SafeArea(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: height * 0.01,
                      left: width * 0.02,
                      right: width * 0.08,
                    ),
                    child: _top(height, width),
                  ),
                ),
              ),
            // Indicator
            if (_isLoad)
              Align(
                alignment: Alignment.bottomCenter,
                child: AnimatedSize(
                  duration: const Duration(milliseconds: 100),
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom:
                          _selectedIndex > 1 ? height * 0.56 : height * 0.256,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 175),
                          height: height * 0.008,
                          width: _selectedIndex == 0
                              ? height * 0.02
                              : height * 0.008,
                          decoration: BoxDecoration(
                            color: _selectedIndex == 0
                                ? kPrimaryColor
                                : kGreyColor,
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                        ),
                        SizedBox(width: width * 0.01),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 175),
                          height: height * 0.008,
                          width: _selectedIndex == 1
                              ? height * 0.02
                              : height * 0.008,
                          decoration: BoxDecoration(
                            color: _selectedIndex == 1
                                ? kPrimaryColor
                                : kGreyColor,
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                        ),
                        SizedBox(width: width * 0.01),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 175),
                          height: height * 0.008,
                          width: _selectedIndex == 2
                              ? height * 0.02
                              : height * 0.008,
                          decoration: BoxDecoration(
                            color: _selectedIndex == 2
                                ? kPrimaryColor
                                : kGreyColor,
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                        ),
                        SizedBox(width: width * 0.01),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 175),
                          height: height * 0.008,
                          width: _selectedIndex == 3
                              ? height * 0.02
                              : height * 0.008,
                          decoration: BoxDecoration(
                            color: _selectedIndex == 3
                                ? kPrimaryColor
                                : kGreyColor,
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _page1(double height, double width) => SizedBox(
        height: height,
        width: width,
        child: Stack(
          children: [
            Image.asset(
              "assets/splash2.jpeg",
              fit: BoxFit.cover,
              height: height,
              width: width,
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.only(
                  top: height * 0.2,
                ),
                child: Text(
                  "PALO",
                  style: TextStyle(
                    shadows: <Shadow>[
                      Shadow(
                        offset: Offset(0.0, 3.0),
                        blurRadius: 3.0,
                        color: Colors.black.withOpacity(0.3),
                      ),
                    ],
                    fontFamily: "TimesNewRoman",
                    color: Colors.black,
                    fontSize: height * 0.058,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: height * 0.24,
                    width: width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5.0),
                        topRight: Radius.circular(5.0),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Зөвлөгөө форум",
                          style: TextStyle(
                            color: kTextColor,
                            fontWeight: FontWeight.bold,
                            fontSize: height * 0.034,
                          ),
                        ),
                        SizedBox(height: height * 0.01),
                        Text(
                          "Хүссэн мэдээлэллээ авах боломжтой",
                          style: TextStyle(
                            color: kTextGreyColor,
                            fontSize: height * 0.022,
                          ),
                        ),
                        SizedBox(height: height * 0.04),
                        Material(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50.0),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(50.0),
                            onTap: () {
                              _next();
                            },
                            child: Container(
                              height: height * 0.052,
                              width: height * 0.052,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50.0),
                                border: Border.all(
                                  width: 2.0,
                                  color: kPrimaryColor,
                                ),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                  size: height * 0.02,
                                ),
                              ),
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
      );

  Widget _page2(double height, double width) => SizedBox(
        height: height,
        width: width,
        child: Stack(
          children: [
            Image.asset(
              "assets/splash2.jpeg",
              alignment: Alignment.centerLeft,
              fit: BoxFit.cover,
              height: height,
              width: width,
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.only(
                  top: height * 0.2,
                ),
                child: Text(
                  "PALO",
                  style: TextStyle(
                    shadows: <Shadow>[
                      Shadow(
                        offset: Offset(0.0, 3.0),
                        blurRadius: 3.0,
                        color: Colors.black.withOpacity(0.3),
                      ),
                    ],
                    fontFamily: "TimesNewRoman",
                    color: Colors.black,
                    fontSize: height * 0.058,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: height * 0.24,
                    width: width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5.0),
                        topRight: Radius.circular(5.0),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Тохирсон цаг",
                          style: TextStyle(
                            color: kTextColor,
                            fontWeight: FontWeight.bold,
                            fontSize: height * 0.034,
                          ),
                        ),
                        SizedBox(height: height * 0.01),
                        Text(
                          "Зөв цагтаа, зөв газраа та байх болно",
                          style: TextStyle(
                            color: kTextGreyColor,
                            fontSize: height * 0.022,
                          ),
                        ),
                        SizedBox(height: height * 0.04),
                        Material(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50.0),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(50.0),
                            onTap: () {
                              _next();
                            },
                            child: Container(
                              height: height * 0.052,
                              width: height * 0.052,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50.0),
                                border: Border.all(
                                  width: 2.0,
                                  color: kPrimaryColor,
                                ),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                  size: height * 0.02,
                                ),
                              ),
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
      );

  Widget _page3(double height, double width) => SizedBox(
        height: height,
        width: width,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.only(top: height * 0.18),
                child: Image.asset(
                  "assets/green_paper.png",
                  height: height * 0.2,
                  width: height * 0.2,
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.only(top: height * 0.46),
                child: Container(
                  height: height * 0.24,
                  width: width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5.0),
                      topRight: Radius.circular(5.0),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Таны сонирхол",
                        style: TextStyle(
                          color: kTextColor,
                          fontWeight: FontWeight.bold,
                          fontSize: height * 0.034,
                        ),
                      ),
                      SizedBox(height: height * 0.01),
                      Padding(
                        padding: EdgeInsets.only(
                          left: width * 0.04,
                          right: width * 0.04,
                        ),
                        child: Text(
                          "Таны сонирхол болон LIFESTYLE нь таны тодорхойлоход туслах бөгөөд та өөрт тохирсон жижиг даалгавар биелүүлэн шагнал авах боломжтой",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: kTextGreyColor,
                            fontSize: height * 0.022,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: height * 0.07),
                child: Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50.0),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(50.0),
                    onTap: () {
                      _next();
                    },
                    child: Container(
                      height: height * 0.052,
                      width: height * 0.052,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50.0),
                        border: Border.all(
                          width: 2.0,
                          color: kPrimaryColor,
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.arrow_forward_ios,
                          size: height * 0.02,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  Widget _page4(double height, double width) => SizedBox(
        height: height,
        width: width,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.only(top: height * 0.18),
                child: Image.asset(
                  "assets/green_clock.png",
                  height: height * 0.2,
                  width: height * 0.2,
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.only(top: height * 0.46),
                child: Container(
                  height: height * 0.24,
                  width: width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5.0),
                      topRight: Radius.circular(5.0),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Таны бодол",
                        style: TextStyle(
                          color: kTextColor,
                          fontWeight: FontWeight.bold,
                          fontSize: height * 0.034,
                        ),
                      ),
                      SizedBox(height: height * 0.01),
                      Padding(
                        padding: EdgeInsets.only(
                          left: width * 0.04,
                          right: width * 0.04,
                        ),
                        child: Text(
                          "Таны санаа бодол зарим үед хэрэгтэй газраа хүрж чадахгүй байдаг юм биш биздээ? Энэ апп нь таны дуу хоолой болно гэдэгт итгэж байна",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: kTextGreyColor,
                            fontSize: height * 0.022,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: height * 0.07),
                child: Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50.0),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(50.0),
                    onTap: () {
                      _next();
                    },
                    child: Container(
                      height: height * 0.052,
                      width: height * 0.052,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50.0),
                        border: Border.all(
                          width: 2.0,
                          color: kPrimaryColor,
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.arrow_forward_ios,
                          size: height * 0.02,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  Widget _top(double height, double width) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              _back();
            },
            icon: Icon(
              Icons.arrow_back,
              color: Color(0xFF28293D),
            ),
          ),
          TextButton(
            onPressed: () {
              _skip();
            },
            child: Text(
              "Алгасах",
              style: TextStyle(
                fontSize: height * 0.021,
                color: kTextGreyColor,
              ),
            ),
          ),
        ],
      );
}
