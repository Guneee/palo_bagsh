import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as https;
import 'package:page_transition/page_transition.dart';
import 'package:palo/constants.dart';
import 'package:palo/data.dart';
import 'package:palo/helpers/api_url.dart';
import 'package:palo/helpers/app_preferences.dart';

import 'package:palo/pages/home/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectWords extends StatefulWidget {
  const SelectWords({Key? key}) : super(key: key);

  @override
  _SelectWordsState createState() => _SelectWordsState();
}

class _SelectWordsState extends State<SelectWords> {
  final GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();
  bool _isLoad = true, _postLoad = false;
  List _words = [];
  List _selectedWords = [];

  Future<void> _saveIsFirst() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("isFirstWord", "false");
    Navigator.pushReplacement(
      context,
      PageTransition(
        duration: Duration(milliseconds: 175),
        type: PageTransitionType.rightToLeft,
        child: const HomePage(),
      ),
    );
  }

  Future<void> _postData() async {
    if (_selectedWords.isEmpty) {
      showSnackBar("Та дор хаяж 1-ийг Хамгийн эхдээ 3-ыг сонгох хэрэгтэй", key);
    } else {
      setState(() {
        _postLoad = true;
      });
      String title1 = "", title2 = "", title3 = "";
      for (int i = 0; i < _selectedWords.length; i++) {
        if (i == 0) {
          title1 = _selectedWords[i]["title"].toString();
        } else if (i == 1) {
          title2 = _selectedWords[i]["title"].toString();
        } else {
          title3 = _selectedWords[i]["title"].toString();
        }
      }
      final response = await https.post(
        Uri.parse(mainApiUrl + "v1/post-words"),
        body: {
          'id': currentUserId,
          "title": title1,
          "title2": title2,
          "title3": title3,
        },
      );
      print(response.body.toString());
      if (response.statusCode == 201) {
        print("done");
        _saveIsFirst();
      } else {
        print("failed");
        Navigator.pushReplacement(
          context,
          PageTransition(
            duration: Duration(milliseconds: 175),
            type: PageTransitionType.rightToLeft,
            child: const HomePage(),
          ),
        );
      }
    }
  }

  Future<void> _loadData() async {
    final response = await https.get(Uri.parse(mainApiUrl + "v1/get-words"));

    if (response.statusCode == 201) {
      var body = json.decode(response.body);
      body["words"].forEach((value) {
        _words.add(value);
      });
      for (int i = 0; i < _words.length; i++) {
        _words[i]["is_select"] = false;
      }
    } else {
      Navigator.pushReplacement(
        context,
        PageTransition(
          duration: Duration(milliseconds: 175),
          type: PageTransitionType.rightToLeft,
          child: const HomePage(),
        ),
      );
    }
    if (mounted) {
      setState(() {
        _isLoad = false;
      });
    }
  }

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: key,
      backgroundColor: kBackgroundColor,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (!_postLoad && !_isLoad) {
            _postData();
          }
        },
        child: (!_postLoad)
            ? Icon(
                Icons.done,
                color: Colors.white,
              )
            : CircularProgressIndicator(
                strokeWidth: 1.5,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.white,
                ),
              ),
      ),
      body: Container(
        height: height,
        width: width,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: height * 0.04),
                if (_isLoad)
                  SizedBox(
                    height: height * 0.03,
                    width: height * 0.03,
                    child: const CircularProgressIndicator(
                      strokeWidth: 1.5,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        kPrimaryColor,
                      ),
                    ),
                  ),
                if (!_isLoad)
                  Text(
                    "Та эдгээрээс сонгох шаардлагатай",
                    style: TextStyle(
                        fontSize: height * 0.02,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                Padding(
                  padding: EdgeInsets.only(
                    left: width * 0.04,
                    right: width * 0.04,
                  ),
                  child: Text(
                    "Хамгийн багадаа 1, Хамгийн эхдээ 3-ыг сонгох боломжтой",
                    style: TextStyle(
                        fontSize: height * 0.014, color: Colors.white),
                  ),
                ),
                if (!_isLoad)
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: height * 0.1,
                      left: width * 0.04,
                      right: width * 0.04,
                      top: height * 0.02,
                    ),
                    child: _body(height, width),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _body(double height, double width) => Column(
        children: List.generate(
          _words.length,
          (index) => Padding(
            padding: EdgeInsets.only(left: width * 0.04),
            child: Row(
              children: [
                Transform.scale(
                  scale: 1.3,
                  child: Checkbox(
                    value: _words[index]["is_select"],
                    onChanged: (value) {
                      if (_selectedWords.length < 3) {
                        if (value!) {
                          _selectedWords.add(_words[index]);
                        }
                        if (!value) {
                          _selectedWords.removeWhere(
                              (item) => item["id"] == _words[index]["id"]);
                        }
                        setState(() {
                          print(_selectedWords.length);
                          _words[index]["is_select"] = value;
                        });
                      } else {
                        showSnackBar("Та 3-ыг сонгосон байна", key);
                      }
                    },
                  ),
                ),
                Text(
                  _words[index]["title"],
                  style:
                      TextStyle(fontSize: height * 0.02, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      );
}
