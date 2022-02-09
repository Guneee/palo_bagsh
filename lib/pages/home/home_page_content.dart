import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:palo/pages/home/home_page.dart';

import '../../data.dart';
import 'package:http/http.dart' as https;
import '../../helpers/api_url.dart';
import '../../models/home_model.dart';
import '../../pages/auth/login_page.dart';
import '../../pages/auth/register_page.dart';
import '../../pages/home/survey_detail2.dart';

import '../../constants.dart';
import '../profile/profile_page.dart';
import 'category_items.dart';
import 'survey_detail.dart';
import 'video_page.dart';

class HomePageContent extends StatefulWidget {
  const HomePageContent({Key? key}) : super(key: key);

  @override
  _HomePageContentState createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  bool _isLoad = false;

  double toRadius(double x) {
    return x * pi / 180;
  }

  void _checkIsHistory() {
    for (int i = 0; i < homeItems.length; i++) {
      for (int j = 0; j < homeItems[i].surveys.length; j++) {
        var existingCall = history.firstWhere(
            (favCall) =>
                favCall["survey_id"].toString() ==
                homeItems[i].surveys[j]["id"].toString(),
            orElse: () => null);

        if (existingCall != null) {
          homeItems[i].surveys[j]["is_history"] = true;
        } else {
          homeItems[i].surveys[j]["is_history"] = false;
        }
      }
    }

    for (int i = 0; i < surveys.length; i++) {
      var existingCall = history.firstWhere(
          (favCall) =>
              favCall["survey_id"].toString() == surveys[i]["id"].toString(),
          orElse: () => null);

      if (existingCall != null) {
        surveys[i]["is_history"] = true;
      } else {
        surveys[i]["is_history"] = false;
      }
    }
    if (mounted) {
      setState(() {
        _getCurrentLocation();
      });
    }
  }

  void _searchNearby(String location) {
    double lat = double.parse(location.split(',')[0].toString());
    double lng = double.parse(location.split(',')[1].toString());

    int length = surveys.length;
    nearSurveys.clear();

    for (int i = 0; i < length; i++) {
      if (surveys[i]['location'].toString() != "null") {
        int r = 6378137; // Earth’s mean radius in meter
        double dLat = toRadius(
            double.parse(surveys[i]['location'].toString().split(',')[0]) -
                lat);
        double dLong = toRadius(
            double.parse(surveys[i]['location'].toString().split(',')[1]) -
                lng);
        double a = sin(dLat / 2) * sin(dLat / 2) +
            cos(toRadius(lat)) *
                cos(toRadius(double.parse(
                    surveys[i]['location'].toString().split(',')[0]))) *
                sin(dLong / 2) *
                sin(dLong / 2);
        double c = 2 * atan2(sqrt(a), sqrt(1 - a));
        double d = r * c;
        if (d < 5000) {
          nearSurveys.add(surveys[i]);
          if (kDebugMode) {
            print("near found");
          }
        } else {
          if (kDebugMode) {
            print("far found");
          }
        }
      }
    }

    if (mounted) {
      setState(() {});
    }
  }

  void _getCurrentLocation() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    try {
      Position userLocation = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      String _location = userLocation.latitude.toString() +
          "," +
          userLocation.longitude.toString();
      if (kDebugMode) {
        print(_location);
      }

      _searchNearby(_location);
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("Permission Denied");
      }
    }
  }

  Future<bool> _refreshData() async {
    if (mounted) {
      homeItems.clear();
      setState(() {
        _isLoad = true;
      });
      final responce = await https.post(
        Uri.parse(mainApiUrl + "v1/get-data"),
        headers: {
          "Authorization": "Bearer $token",
        },
        body: {
          'id': currentUserId.toString(),
        },
      );

      categoryItems.clear();
      List fetchItem = [];

      final items = json.encode(json.decode(responce.body)["data"]);
      fetchItem = json.decode(items);
      for (var element in fetchItem) {
        HomeModel homeModel = HomeModel(
          id: element["id"].toString(),
          title: element["title"].toString(),
          image: element["image"].toString(),
          surveys: element["survey"] ?? [],
          createdAt: element["created_at"].toString(),
        );
        homeItems.add(homeModel);
      }
      history.clear();
      json.decode(responce.body)["history"].forEach((item) {
        history.add(item);
      });
      surveys.clear();
      json.decode(responce.body)['surveys'].forEach((value) {
        surveys.add(value);
      });
      banners.clear();
      json.decode(responce.body)['banners'].forEach((value) {
        banners.add(value);
      });

      _checkIsHistory();
      if (mounted) {
        setState(() {
          _isLoad = false;
        });
      }

      isFirstHome = true;
    }
    return true;
  }

  @override
  void initState() {
    if (token != "" && !isFirstHome) _refreshData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _key,
      body: SizedBox(
        height: height,
        width: width,
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: _refreshData,
            color: kPrimaryColor,
            strokeWidth: 1.5,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (token != "") _top(height, width),
                  if (token == "") _authButtons(height, width),
                  if (token != "") _mainBody(height, width),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _authButtons(double height, double width) => SizedBox(
        width: width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: height * 0.02,
            ),
            Image.asset(
              "assets/survey.png",
              height: height * 0.4,
            ),
            Text(
              "Тавтай морил",
              style: TextStyle(
                color: kBtnColor,
                fontSize: height * 0.03,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: height * 0.01),
            Text(
              "Palo",
              style: TextStyle(
                color: Colors.black.withOpacity(0.6),
                fontSize: height * 0.02,
              ),
            ),
            SizedBox(height: height * 0.001),
            Text(
              "таны сонирхол, таны ойр",
              style: TextStyle(
                color: Colors.black.withOpacity(0.6),
                fontSize: height * 0.02,
              ),
            ),
            SizedBox(height: height * 0.1),
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 7,
                    offset: const Offset(2, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                  12.0,
                ),
                child: Material(
                  color: kPrimaryColor,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageTransition(
                          duration: Duration(milliseconds: 200),
                          type: PageTransitionType.rightToLeft,
                          child: const LoginPage(),
                        ),
                      );
                    },
                    child: SizedBox(
                      height: height * 0.06,
                      width: width * 0.8,
                      child: Center(
                        child: Text(
                          "НЭВТРЭХ",
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
            SizedBox(height: height * 0.02),
            ClipRRect(
              borderRadius: BorderRadius.circular(
                12.0,
              ),
              child: Material(
                color: kBtnColor,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        duration: Duration(milliseconds: 200),
                        type: PageTransitionType.rightToLeft,
                        child: const RegisterPage(),
                      ),
                    );
                  },
                  child: SizedBox(
                    height: height * 0.06,
                    width: width * 0.8,
                    child: Center(
                      child: Text(
                        "БҮРТГҮҮЛЭХ",
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
          ],
        ),
      );

  Widget _mainBody(double height, double width) => Column(
        children: [
          if (banners.isNotEmpty) _bannerItems(height, width),
          if (!_isLoad)
            if (nearSurveys.isNotEmpty)
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: null,
                  child: SizedBox(
                    width: width,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              left: width * 0.05,
                              top: height * 0.02,
                            ),
                            child: Text(
                              "Таньд санал болгосон",
                              style: TextStyle(
                                fontSize: height * 0.024,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          if (!_isLoad)
            if (nearSurveys.isNotEmpty)
              SizedBox(
                height: height * 0.32,
                width: width,
                child: AnimationLimiter(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: nearSurveys.length,
                    itemBuilder: (context, index2) =>
                        AnimationConfiguration.staggeredList(
                      position: index2,
                      duration: const Duration(milliseconds: 375),
                      child: SlideAnimation(
                        horizontalOffset: 50.0,
                        child: FadeInAnimation(
                          child: Row(
                            children: [
                              if (index2 == 0) SizedBox(width: width * 0.04),
                              Padding(
                                padding: EdgeInsets.only(
                                  top: height * 0.02,
                                  right: width * 0.024,
                                  bottom: height * 0.012,
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        spreadRadius: 0.1,
                                        blurRadius: 3,
                                        offset: const Offset(3, 3),
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Material(
                                      color: Colors.white,
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            PageTransition(
                                              duration:
                                                  Duration(milliseconds: 200),
                                              type: PageTransitionType
                                                  .rightToLeft,
                                              child: SurveyDetail2(
                                                index: index2,
                                              ),
                                            ),
                                          );
                                        },
                                        child: SizedBox(
                                          height: height * 0.3,
                                          width: width * 0.4,
                                          child: Column(
                                            children: [
                                              Expanded(
                                                flex: 5,
                                                child: Stack(
                                                  children: [
                                                    Image.network(
                                                      nearSurveys[index2]
                                                              ["image"]
                                                          .toString(),
                                                      fit: BoxFit.cover,
                                                    ),
                                                    if (nearSurveys[index2]
                                                            ["is_history"] ==
                                                        true)
                                                      Align(
                                                        alignment: Alignment
                                                            .bottomRight,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                4.0,
                                                              ),
                                                              color: kBtnColor,
                                                            ),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(4.0),
                                                              child: Text(
                                                                "Бөглөсөн",
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:
                                                                      height *
                                                                          0.014,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 4,
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                    top: height * 0.018,
                                                    bottom: height * 0.02,
                                                  ),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Align(
                                                        alignment:
                                                            Alignment.topLeft,
                                                        child: Text(
                                                          "    " +
                                                              nearSurveys[index2]
                                                                      ["title"]
                                                                  .toString(),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                            fontSize:
                                                                height * 0.02,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                      Column(
                                                        children: [
                                                          Align(
                                                            alignment: Alignment
                                                                .topLeft,
                                                            child: Text(
                                                              "    " +
                                                                  nearSurveys[index2]
                                                                          [
                                                                          "created_at"]
                                                                      .toString()
                                                                      .substring(
                                                                          0,
                                                                          10),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: TextStyle(
                                                                fontSize:
                                                                    height *
                                                                        0.018,
                                                                color: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        0.5),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height:
                                                                height * 0.002,
                                                          ),
                                                          Align(
                                                            alignment: Alignment
                                                                .topLeft,
                                                            child: Text(
                                                              "    Шагнал " +
                                                                  nearSurveys[index2]
                                                                          [
                                                                          "price"]
                                                                      .toString() +
                                                                  "₮",
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: TextStyle(
                                                                fontSize:
                                                                    height *
                                                                        0.018,
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
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
                ),
              ),
          _items(height, width),
          SizedBox(height: height * 0.05),
        ],
      );

  Widget _items(double height, double width) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_isLoad)
            Padding(
              padding: EdgeInsets.only(top: height * 0.4),
              child: SizedBox(
                width: width,
                child: Center(
                  child: SizedBox(
                    height: height * 0.05,
                    width: height * 0.05,
                    child: const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
                      strokeWidth: 1.5,
                    ),
                  ),
                ),
              ),
            ),
          if (!_isLoad)
            AnimationLimiter(
              child: Column(
                children: AnimationConfiguration.toStaggeredList(
                  duration: const Duration(milliseconds: 375),
                  childAnimationBuilder: (widget) => SlideAnimation(
                    horizontalOffset: 50.0,
                    child: FadeInAnimation(
                      child: widget,
                    ),
                  ),
                  children: List.generate(
                    homeItems.length,
                    (index) => Column(
                      children: [
                        if (index == 1) _banner(height, width),
                        if (homeItems[index].surveys.isNotEmpty)
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: (homeItems[index].surveys.length >= 3)
                                  ? () {
                                      Navigator.push(
                                        context,
                                        PageTransition(
                                          duration: Duration(milliseconds: 200),
                                          type: PageTransitionType.rightToLeft,
                                          child: CategoryItems(
                                            index: index,
                                          ),
                                        ),
                                      );
                                    }
                                  : null,
                              child: SizedBox(
                                width: width,
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                          left: width * 0.05,
                                          top: height * 0.02,
                                        ),
                                        child: Text(
                                          homeItems[index].title,
                                          style: TextStyle(
                                            fontSize: height * 0.024,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      if (homeItems[index].surveys.length >= 3)
                                        Padding(
                                          padding: EdgeInsets.only(
                                            right: width * 0.05,
                                            top: height * 0.02,
                                          ),
                                          child: Icon(
                                            Icons.arrow_forward_ios,
                                            size: height * 0.022,
                                            color:
                                                Colors.black.withOpacity(0.6),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        SizedBox(height: height * 0.014),
                        SizedBox(
                          height: height * 0.32,
                          width: width,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: homeItems[index].surveys.length,
                            itemBuilder: (context, index2) => Row(
                              children: [
                                if (index2 == 0) SizedBox(width: width * 0.04),
                                Padding(
                                  padding: EdgeInsets.only(
                                    right: width * 0.024,
                                    bottom: height * 0.012,
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          spreadRadius: 0.1,
                                          blurRadius: 3,
                                          offset: const Offset(3, 3),
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Material(
                                        color: Colors.white,
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              PageTransition(
                                                duration:
                                                    Duration(milliseconds: 200),
                                                type: PageTransitionType
                                                    .rightToLeft,
                                                child: SurveyDetail(
                                                  index: index,
                                                  index2: index2,
                                                ),
                                              ),
                                            );
                                          },
                                          child: SizedBox(
                                            height: height * 0.3,
                                            width: width * 0.4,
                                            child: Column(
                                              children: [
                                                Expanded(
                                                  flex: 5,
                                                  child: Stack(
                                                    children: [
                                                      Image.network(
                                                        homeItems[index]
                                                            .surveys[index2]
                                                                ["image"]
                                                            .toString(),
                                                        fit: BoxFit.cover,
                                                        height: height * 0.3,
                                                        width: width * 0.4,
                                                      ),
                                                      if (homeItems[index]
                                                                      .surveys[
                                                                  index2]
                                                              ["is_history"] ==
                                                          true)
                                                        Align(
                                                          alignment: Alignment
                                                              .bottomRight,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                  4.0,
                                                                ),
                                                                color:
                                                                    kBtnColor,
                                                              ),
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        4.0),
                                                                child: Text(
                                                                  "Бөглөсөн",
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        height *
                                                                            0.014,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 4,
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                      top: height * 0.018,
                                                      bottom: height * 0.02,
                                                    ),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Align(
                                                          alignment:
                                                              Alignment.topLeft,
                                                          child: Text(
                                                            "    " +
                                                                homeItems[index]
                                                                    .surveys[
                                                                        index2][
                                                                        "title"]
                                                                    .toString(),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                              fontSize:
                                                                  height * 0.02,
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ),
                                                        Column(
                                                          children: [
                                                            Align(
                                                              alignment:
                                                                  Alignment
                                                                      .topLeft,
                                                              child: Text(
                                                                "    " +
                                                                    homeItems[
                                                                            index]
                                                                        .surveys[
                                                                            index2]
                                                                            [
                                                                            "created_at"]
                                                                        .toString()
                                                                        .substring(
                                                                            0,
                                                                            10),
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      height *
                                                                          0.018,
                                                                  color: Colors
                                                                      .black
                                                                      .withOpacity(
                                                                          0.5),
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: height *
                                                                  0.002,
                                                            ),
                                                            Align(
                                                              alignment:
                                                                  Alignment
                                                                      .topLeft,
                                                              child: Text(
                                                                "    Шагнал " +
                                                                    homeItems[
                                                                            index]
                                                                        .surveys[
                                                                            index2]
                                                                            [
                                                                            "price"]
                                                                        .toString() +
                                                                    "₮",
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      height *
                                                                          0.018,
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
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
                        if (homeItems.length > 1)
                          if (index == 1)
                            Padding(
                              padding: EdgeInsets.only(top: height * 0.02),
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        left: width * 0.084,
                                      ),
                                      child: Text(
                                        "Ангилал",
                                        style: TextStyle(
                                          fontSize: height * 0.024,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      left: width * 0.034,
                                      top: height * 0.02,
                                    ),
                                    child: SizedBox(
                                      height: height * 0.14,
                                      width: width,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: homeItems.length,
                                        itemBuilder: (context, index3) =>
                                            Padding(
                                          padding: EdgeInsets.only(
                                            left: width * 0.042,
                                            right: width * 0.02,
                                          ),
                                          child: Column(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(0.1),
                                                      spreadRadius: 0.1,
                                                      blurRadius: 4,
                                                      offset:
                                                          const Offset(3, 3),
                                                    ),
                                                  ],
                                                ),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    4.0,
                                                  ),
                                                  child: Stack(
                                                    children: [
                                                      SizedBox(
                                                        height: height * 0.09,
                                                        width: width * 0.16,
                                                        child: Image.network(
                                                          homeItems[index3]
                                                              .image
                                                              .toString(),
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                      Material(
                                                        color:
                                                            Colors.transparent,
                                                        child: InkWell(
                                                          onTap: () {
                                                            Navigator.push(
                                                              context,
                                                              PageTransition(
                                                                duration: Duration(
                                                                    milliseconds:
                                                                        200),
                                                                type: PageTransitionType
                                                                    .rightToLeft,
                                                                child:
                                                                    CategoryItems(
                                                                  index: index3,
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                          child: SizedBox(
                                                            height:
                                                                height * 0.09,
                                                            width: width * 0.16,
                                                            child:
                                                                const Text(""),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: height * 0.014,
                                              ),
                                              Text(
                                                homeItems[index3].title,
                                                style: TextStyle(
                                                  fontSize: height * 0.018,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
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
            ),
        ],
      );

  Widget _bannerItems(double height, double width) => Column(
        children: [
          SizedBox(
            height: height * 0.24,
            width: width,
            child: AnimationLimiter(
              child: PageView.builder(
                itemCount: banners.length,
                itemBuilder: (context, index) =>
                    AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 375),
                  child: SlideAnimation(
                    horizontalOffset: 50.0,
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: height * 0.03,
                        left: width * 0.04,
                        right: width * 0.04,
                        bottom: height * 0.01,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12.0),
                        child: Stack(
                          children: [
                            Image.network(
                              banners[index]["image"],
                              height: height * 0.24,
                              width: width,
                              fit: BoxFit.cover,
                            ),
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: Container(
                                width: width,
                                color: Colors.black.withOpacity(0.6),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    banners[index]["title"].toString(),
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: height * 0.016,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  _showSheet(index);
                                },
                                child: SizedBox(
                                  height: height * 0.24,
                                  width: width,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );

  Widget _banner(double height, double width) => Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: height * 0.02,
              bottom: height * 0.01,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: kPrimaryColor,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: kPrimaryColor.withOpacity(0.2),
                    spreadRadius: 5,
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Material(
                  color: kPrimaryColor,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageTransition(
                          duration: Duration(milliseconds: 200),
                          type: PageTransitionType.rightToLeft,
                          child: const VideoPage(),
                        ),
                      );
                    },
                    child: SizedBox(
                      height: height * 0.16,
                      width: width * 0.9,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: width * 0.01,
                          ),
                          SizedBox(
                            width: width * 0.4,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Бичлэг үзээд 200₮",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: height * 0.02,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: height * 0.002,
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Өдөрт нэг удаа",
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.4),
                                      fontSize: height * 0.016,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: width * 0.06,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white.withOpacity(0.2),
                                  spreadRadius: 5,
                                  blurRadius: 15,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.card_giftcard,
                              color: Colors.white.withOpacity(0.5),
                              size: height * 0.05,
                            ),
                          ),
                          SizedBox(
                            width: width * 0.02,
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
      );

  Widget _top(double height, double width) => Padding(
        padding: EdgeInsets.only(
          top: height * 0.02,
          right: width * 0.05,
          left: width * 0.03,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Тавтай морил " + currentUserLastName + ",",
                      style: TextStyle(
                        color: kBtnColor,
                        fontWeight: FontWeight.bold,
                        fontSize: height * 0.023,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.006,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Та юу сонирхож байна вэ?",
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.4),
                        fontSize: height * 0.018,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (currentUserAvatar != "")
              ClipRRect(
                borderRadius: BorderRadius.circular(height * 0.5),
                child: Image.network(
                  currentUserAvatar,
                  height: height * 0.07,
                  width: height * 0.07,
                  fit: BoxFit.cover,
                ),
              ),
            if (currentUserAvatar == "")
              IconButton(
                onPressed: () {
                  currentBottomIndex = 2;
                  Navigator.pushReplacement(
                    context,
                    PageTransition(
                      duration: Duration(milliseconds: 200),
                      type: PageTransitionType.rightToLeft,
                      child: HomePage(),
                    ),
                  );
                },
                icon: Icon(
                  Icons.person,
                  color: Colors.black,
                  size: height * 0.04,
                ),
              ),
          ],
        ),
      );

  void _showSheet(int index) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        ),
      ),
      builder: (_) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          expand: false,
          builder: (_, controller) {
            return SingleChildScrollView(
              controller: controller,
              child: Container(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      height: 8.0,
                    ),
                    Text(
                      banners[index]["title"].toString(),
                      style: const TextStyle(
                        color: kPrimaryColor,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 10.0),
                          if (banners[index]["image"] != null)
                            Image.network(
                              banners[index]["image"],
                              width: double.infinity,
                              fit: BoxFit.fill,
                            ),
                          const SizedBox(height: 24.0),
                          if (banners[index]["content"] != null)
                            Text(
                              banners[index]["content"].toString(),
                              textAlign: TextAlign.justify,
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 18.0,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    ).then((value) {});
  }
}
