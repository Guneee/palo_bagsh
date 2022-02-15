import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
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

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString("isFirst") != null) {
      Navigator.pushReplacement(
        context,
        PageTransition(
          duration: Duration(milliseconds: 200),
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
    _loadUserData();
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
        child: SafeArea(
          child: Column(
            children: [
              if (_isLoad)
                Expanded(
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
                    ],
                  ),
                ),
              if (_isLoad)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _buildPageIndicator(),
                ),
              if (_isLoad) SizedBox(height: height * 0.15),
              if (_isLoad)
                ClipRRect(
                  borderRadius: BorderRadius.circular(
                    18.0,
                  ),
                  child: Material(
                    color: kPrimaryColor,
                    child: InkWell(
                      onTap: () {
                        if (_selectedIndex == 0) {
                          setState(() {
                            _selectedIndex = 1;
                            _pageController.animateToPage(1,
                                duration: const Duration(milliseconds: 600),
                                curve: Curves.ease);
                          });
                        } else if (_selectedIndex == 1) {
                          setState(() {
                            _pageController.animateToPage(2,
                                duration: const Duration(milliseconds: 600),
                                curve: Curves.ease);
                            _selectedIndex = 2;
                          });
                        } else if (_selectedIndex == 2) {
                          Navigator.pushReplacement(
                            context,
                            PageTransition(
                              duration: Duration(milliseconds: 200),
                              type: PageTransitionType.rightToLeft,
                              child: const LocationAsk(),
                            ),
                          );
                        }
                      },
                      child: SizedBox(
                        height: height * 0.05,
                        width: width * 0.4,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (_selectedIndex == 2)
                              Text(
                                "Болсон",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: height * 0.02,
                                ),
                              ),
                            if (_selectedIndex != 2)
                              Text(
                                "Цааш",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: height * 0.02,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              if (_isLoad) SizedBox(height: height * 0.06),
            ],
          ),
        ),
      ),
    );
  }

  Widget _page1(double height, double width) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Хуудас 1",
            style: TextStyle(
              fontSize: height * 0.024,
              fontWeight: FontWeight.bold,
            ),
          ),
          Image.asset(
            "assets/splash1.png",
            height: height * 0.4,
          ),
          SizedBox(height: height * 0.01),
          Padding(
            padding: EdgeInsets.only(
              left: width * 0.04,
              right: width * 0.04,
            ),
            child: Text(
              "Бидний энэхүү бүтээсэн апп нь таны амьдралын хэв маягаас хамааруулан танд тохирох жижиг ажлуудыг санал болох болно",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: kPrimaryColor,
                fontSize: height * 0.022,
              ),
            ),
          ),
        ],
      );
  Widget _page2(double height, double width) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Хуудас 2",
            style: TextStyle(
              fontSize: height * 0.024,
              fontWeight: FontWeight.bold,
            ),
          ),
          Image.asset(
            "assets/splash2.png",
            height: height * 0.4,
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
                color: kPrimaryColor,
                fontSize: height * 0.022,
              ),
            ),
          ),
        ],
      );
  Widget _page3(double height, double width) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Хуудас 3",
            style: TextStyle(
              fontSize: height * 0.024,
              fontWeight: FontWeight.bold,
            ),
          ),
          Image.asset(
            "assets/splash3.png",
            height: height * 0.4,
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
                color: kPrimaryColor,
                fontSize: height * 0.022,
              ),
            ),
          ),
        ],
      );

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < 3; i++) {
      list.add(i == _selectedIndex ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return SizedBox(
      height: 10,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.symmetric(horizontal: 4.0),
        height: isActive ? 10 : 8.0,
        width: isActive ? 12 : 8.0,
        decoration: BoxDecoration(
          boxShadow: [
            isActive
                ? BoxShadow(
                    color: kPrimaryColor.withOpacity(0.72),
                    blurRadius: 4.0,
                    spreadRadius: 1.0,
                    offset: const Offset(
                      0.0,
                      0.0,
                    ),
                  )
                : const BoxShadow(
                    color: Colors.transparent,
                  )
          ],
          shape: BoxShape.circle,
          color: isActive ? kPrimaryColor : const Color(0XFFEAEAEA),
        ),
      ),
    );
  }
}
