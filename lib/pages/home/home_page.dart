import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:palo/helpers/app_preferences.dart';
import 'package:palo/pages/job/job_page.dart';
import 'package:palo/pages/select_words.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/data.dart';
import '../../constants.dart';
import '/pages/profile/profile_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'home_page_content.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  late PageController _pageController;
  FirebaseMessaging messaging = FirebaseMessaging.instance;

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
          duration: Duration(milliseconds: 175),
          type: PageTransitionType.rightToLeft,
          child: SelectWords(),
        ),
      );
    }
  }

  void _firebaseNotification() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
  }

  @override
  void initState() {
    super.initState();
    if (token != "") {
      _firebaseNotification();
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
    double height = size(context).height;
    double width = size(context).width;
    return Scaffold(
      key: _key,
      extendBody: true,
      backgroundColor: kBackgroundColor,
      bottomNavigationBar:
          (token != "") ? _bottomNavigationBar(height, width) : null,
      body: SizedBox(
        height: height,
        width: width,
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
    );
  }

  Widget _bottomNavigationBar(double height, double width) =>
      BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        fixedColor: kPrimaryColor,
        backgroundColor: Colors.white,
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
                ? Image.asset(
                    "assets/home_selected.png",
                    height: height * 0.05,
                  )
                : Image.asset(
                    "assets/home_unselected.png",
                    height: height * 0.05,
                  ),
          ),
          BottomNavigationBarItem(
            label: 'Газрын зураг',
            icon: (currentBottomIndex == 1)
                ? Image.asset(
                    "assets/map_selected.png",
                    height: height * 0.05,
                  )
                : Image.asset(
                    "assets/map_unselected.png",
                    height: height * 0.05,
                  ),
          ),
          BottomNavigationBarItem(
            label: "Ажил",
            icon: (currentBottomIndex == 2)
                ? Image.asset(
                    "assets/profile_selected.png",
                    height: height * 0.05,
                  )
                : Image.asset(
                    "assets/profile_unselected.png",
                    height: height * 0.05,
                  ),
          ),
        ],
      );
}
