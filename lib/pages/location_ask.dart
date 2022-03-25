import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../constants.dart';
import 'home/home_page.dart';

class LocationAsk extends StatefulWidget {
  const LocationAsk({Key? key}) : super(key: key);

  @override
  _LocationAskState createState() => _LocationAskState();
}

class _LocationAskState extends State<LocationAsk> {
  Future<void> _saveUserData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("isFirst", "false");
  }

  final YoutubePlayerController _controller = YoutubePlayerController(
    initialVideoId: "gEZ4FLJyHmg",
    flags: const YoutubePlayerFlags(
      autoPlay: true,
    ),
  );

  Future<void> _checkPerm() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Navigator.pushReplacement(
          context,
          PageTransition(
            duration: Duration(milliseconds: 200),
            type: PageTransitionType.rightToLeft,
            child: const HomePage(),
          ),
        );
      } else {
        _saveUserData();
        Navigator.pushReplacement(
          context,
          PageTransition(
            duration: Duration(milliseconds: 200),
            type: PageTransitionType.rightToLeft,
            child: const HomePage(),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: height,
        width: width,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: height * 0.04),
                Text(
                  "Байршилын зөвшөөрөл",
                  style: TextStyle(
                    fontSize: height * 0.022,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: height * 0.04),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: SizedBox(
                    height: height * 0.2,
                    width: width * 0.8,
                    child: YoutubePlayer(
                      controller: _controller,
                      showVideoProgressIndicator: true,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: height * 0.04,
                    left: width * 0.06,
                    right: width * 0.06,
                  ),
                  child: Text(
                    "Энэхүү газарзүйн байршилийг мэдсэнээр бид танд тохирох жижиг ажлуудыг таны гар утас нь дээр харуулах ба та бидэнд өөрийн мэдээллийг хуваалцсанаар илүү найдвартай, илүү ашигтай ажлуудыг олох магадлалтай, дээрх бичлэг таньд тус болно",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: kPrimaryColor,
                      fontSize: height * 0.02,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: height * 0.04,
                    left: width * 0.08,
                    right: width * 0.08,
                  ),
                  child: Text(
                    "Бид таны газарзүйн байршилыг авж байх хүсэлт гаргаж байна, Та зөвшөөрөх үү?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: kPrimaryColor,
                      fontSize: height * 0.02,
                    ),
                  ),
                ),
                SizedBox(height: height * 0.02),
                Padding(
                  padding: EdgeInsets.only(
                    left: width * 0.046,
                    right: width * 0.046,
                    top: height * 0.03,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4.0),
                          child: Material(
                            color: kBtnColor,
                            child: InkWell(
                              onTap: () {
                                _checkPerm();
                              },
                              child: SizedBox(
                                height: height * 0.05,
                                child: Center(
                                  child: Text(
                                    "Зөвшөөрөх",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: height * 0.02,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: width * 0.04),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4.0),
                          child: Material(
                            color: kBtnColor.withOpacity(0.7),
                            child: InkWell(
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  PageTransition(
                                    duration: Duration(milliseconds: 200),
                                    type: PageTransitionType.rightToLeft,
                                    child: const HomePage(),
                                  ),
                                );
                              },
                              child: SizedBox(
                                height: height * 0.05,
                                child: Center(
                                  child: Text(
                                    "Татгалзах",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: height * 0.02,
                                    ),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
