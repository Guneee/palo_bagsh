import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:page_transition/page_transition.dart';
import 'package:palo/helpers/api_url.dart';
import 'package:http/http.dart' as https;
import 'package:palo/pages/home/home_page.dart';
import '../../constants.dart';
import '../../data.dart';

class PullList extends StatefulWidget {
  const PullList({Key? key}) : super(key: key);

  @override
  _PullListState createState() => _PullListState();
}

class _PullListState extends State<PullList> {
  final _searchTEC = TextEditingController();

  Future<bool> _refreshData() async {
    final responce = await https.post(
      Uri.parse(mainApiUrl + "v1/get-history"),
      headers: {
        "Authorization": "Bearer $token",
      },
      body: {
        'id': currentUserId.toString(),
      },
    );

    if (mounted) {
      if (responce.statusCode == 201) {
        setState(() {
          userPullRequestItems.clear();
          json.decode(responce.body)["history"].forEach((item) {
            userPullRequestItems.add(item);
          });
          currentUserMoney = json.decode(responce.body)["money"].toString();
        });
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  bool _checkSearch(int index) {
    if (_searchTEC.text.isNotEmpty) {
      if (userPullRequestItems[index]["amount"]
          .toString()
          .toUpperCase()
          .contains(
            _searchTEC.text.toString().toUpperCase(),
          )) {
        return true;
      } else {
        return false;
      }
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () {
        Navigator.pushReplacement(
          context,
          PageTransition(
            duration: Duration(milliseconds: 175),
            type: PageTransitionType.rightToLeft,
            child: const HomePage(),
          ),
        );

        return Future<bool>.value(true);
      },
      child: Scaffold(
        backgroundColor: kBackgroundColor,
        body: SizedBox(
          height: height,
          width: width,
          child: SafeArea(
            child: Column(
              children: [
                _top(height, width),
                _search(height, width),
                SizedBox(height: height * 0.03),
                _body(height, width),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _search(double height, double width) => SizedBox(
        width: width * 0.9,
        child: TextField(
          controller: _searchTEC,
          textAlign: TextAlign.left,
          keyboardType: TextInputType.text,
          style: TextStyle(
            fontSize: height * 0.02,
            color: Colors.white,
          ),
          onChanged: (value) {
            setState(() {});
          },
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.search,
              size: height * 0.024,
              color: Colors.white.withOpacity(0.6),
            ),
            hintText: 'Хайх..',
            hintStyle: TextStyle(
              fontSize: height * 0.02,
              color: Colors.white.withOpacity(0.6),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32.0),
              borderSide: const BorderSide(
                width: 0,
                style: BorderStyle.none,
              ),
            ),
            filled: true,
            fillColor: Colors.white.withOpacity(0.1),
            contentPadding: const EdgeInsets.all(1),
            isDense: true,
          ),
        ),
      );

  Widget _body(double height, double width) => Expanded(
        child: RefreshIndicator(
          onRefresh: _refreshData,
          color: kPrimaryColor,
          strokeWidth: 1.5,
          child: AnimationLimiter(
            child: ListView.builder(
              itemCount: userPullRequestItems.length,
              itemBuilder: (context, index) =>
                  AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 375),
                child: SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(
                    child: Column(
                      children: [
                        if (_checkSearch(index))
                          Padding(
                            padding: EdgeInsets.only(
                              bottom: height * 0.02,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16.0),
                              child: Material(
                                color: Colors.white.withOpacity(0.1),
                                child: SizedBox(
                                  height: height * 0.08,
                                  width: width * 0.8,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      left: width * 0.06,
                                      right: width * 0.06,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        if (userPullRequestItems[index]
                                                ['status'] ==
                                            "ТАТГАЛЗСАН")
                                          Expanded(
                                            flex: 3,
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                userPullRequestItems[index]
                                                    ['status'],
                                                style: TextStyle(
                                                  color: Colors.red
                                                      .withOpacity(0.8),
                                                  fontSize: height * 0.018,
                                                ),
                                              ),
                                            ),
                                          ),
                                        if (userPullRequestItems[index]
                                                ['status'] ==
                                            "БАТЛАГДСАН")
                                          Expanded(
                                            flex: 3,
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                userPullRequestItems[index]
                                                    ['status'],
                                                style: TextStyle(
                                                  color: Colors.green
                                                      .withOpacity(0.8),
                                                  fontSize: height * 0.018,
                                                ),
                                              ),
                                            ),
                                          ),
                                        if (userPullRequestItems[index]
                                                ['status'] ==
                                            "ХҮЛЭЭГДЭЖ БАЙНА")
                                          Expanded(
                                            flex: 3,
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                userPullRequestItems[index]
                                                    ['status'],
                                                style: TextStyle(
                                                  color: Colors.white
                                                      .withOpacity(0.8),
                                                  fontSize: height * 0.018,
                                                ),
                                              ),
                                            ),
                                          ),
                                        Expanded(
                                          flex: 2,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: Text(
                                                  "₮ " +
                                                      userPullRequestItems[
                                                          index]['amount'],
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: height * 0.02,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: Text(
                                                  userPullRequestItems[index]
                                                          ['created_at']
                                                      .toString()
                                                      .replaceAll("T", "")
                                                      .substring(0, 10),
                                                  style: TextStyle(
                                                    color: Colors.white
                                                        .withOpacity(0.3),
                                                    fontSize: height * 0.018,
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
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

  Widget _top(double height, double width) => SizedBox(
        height: height * 0.08,
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
                  Navigator.pushReplacement(
                    context,
                    PageTransition(
                      duration: Duration(milliseconds: 175),
                      type: PageTransitionType.rightToLeft,
                      child: const HomePage(),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
              ),
              Text(
                "Таталтын түүх",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: height * 0.022,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const IconButton(
                icon: Icon(
                  Icons.done_outline,
                  color: Colors.transparent,
                ),
                onPressed: null,
              ),
            ],
          ),
        ),
      );
}
