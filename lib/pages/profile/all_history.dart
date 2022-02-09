import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:page_transition/page_transition.dart';
import 'package:palo/constants.dart';

import '../../data.dart';
import 'history_detail.dart';

class AllHistory extends StatefulWidget {
  const AllHistory({Key? key}) : super(key: key);

  @override
  _AllHistoryState createState() => _AllHistoryState();
}

class _AllHistoryState extends State<AllHistory> {
  final _searchTEC = TextEditingController();

  bool _checkSearch(int index) {
    if (history[index]["title"].toString().toUpperCase().contains(
          _searchTEC.text.toString().toUpperCase(),
        )) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: kBtnColor,
      body: SizedBox(
        height: height,
        width: width,
        child: SafeArea(
          child: Column(
            children: <Widget>[
              _top(height, width),
              _search(height, width),
              SizedBox(height: height * 0.03),
              _body(height, width),
            ],
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
            fillColor: kPrimaryColor.withOpacity(0.6),
            contentPadding: const EdgeInsets.all(1),
            isDense: true,
          ),
        ),
      );

  Widget _body(double height, double width) => Expanded(
        child: AnimationLimiter(
          child: ListView.builder(
            itemCount: history.length,
            itemBuilder: (context, index) =>
                AnimationConfiguration.staggeredList(
              position: index,
              child: SlideAnimation(
                duration: const Duration(milliseconds: 375),
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
                              color: kPrimaryColor,
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                      duration: Duration(milliseconds: 200),
                                      type: PageTransitionType.rightToLeft,
                                      child: HistoryDetail(
                                        index: index,
                                      ),
                                    ),
                                  );
                                },
                                child: SizedBox(
                                  height: height * 0.1,
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
                                        Container(
                                          height: height * 0.06,
                                          width: height * 0.06,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            color: kBtnColor,
                                          ),
                                          child: const Icon(
                                            Icons.category_outlined,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  "     " +
                                                      history[index]['title'],
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: height * 0.02,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: height * 0.006),
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  "     " +
                                                      history[index]
                                                          ['category_text'],
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
                                                      history[index]['price'],
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: height * 0.02,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: height * 0.006),
                                              Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: Text(
                                                  history[index]['created_at']
                                                      .toString()
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
                        ),
                    ],
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
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
              ),
              Text(
                "Бүх түүх",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: height * 0.022,
                  fontWeight: FontWeight.bold,
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
