import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:palo/helpers/app_preferences.dart';
import 'package:palo/pages/job/job_page.dart';
import 'package:palo/pages/select_words.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/data.dart';
import '../../constants.dart';
import '/pages/profile/profile_page.dart';

import 'home_page_content.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  late PageController _pageController;

  List<Widget> tabPages = [
    const HomePageContent(),
    const JobPage(),
    const ProfilePage(),
  ];

  void _onPageChanged(int page) {
    if (token != "") {
      setState(() {
        currentBottomIndex = page;
      });
    }
  }

  Future<void> _checkIsFirst() async {
    isFirstHomeAdWord = true;
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString("isFirstWord") == null) {
      Navigator.pushReplacement(
        context,
        PageTransition(
          duration: Duration(milliseconds: 200),
          type: PageTransitionType.rightToLeft,
          child: SelectWords(),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();

    if (token != "") {
      if (!isFirstHomeAdWord) {
        _checkIsFirst();
      }

      _pageController =
          PageController(initialPage: currentBottomIndex, keepPage: true);
    } else {
      _pageController = PageController(initialPage: 0, keepPage: true);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _key,
      backgroundColor: currentBottomIndex == 2 ? kBtnColor : null,
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
