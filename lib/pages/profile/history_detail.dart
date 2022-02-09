import 'package:flutter/material.dart';
import '/data.dart';

import '../../constants.dart';

class HistoryDetail extends StatefulWidget {
  final int index;
  const HistoryDetail({Key? key, required this.index}) : super(key: key);

  @override
  _HistoryDetailState createState() => _HistoryDetailState();
}

class _HistoryDetailState extends State<HistoryDetail> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
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
              history[widget.index]['image'],
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
                        history[widget.index]['title'],
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
                            "Survey оруулсан,",
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
                            "Бөглөсөн хугацаа: ",
                            style: TextStyle(
                              fontSize: height * 0.02,
                              color: Colors.black.withOpacity(0.5),
                            ),
                          ),
                          Text(
                            history[widget.index]['created_at']
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
                            "Survey үүсгэсэн хугацаа: ",
                            style: TextStyle(
                              fontSize: height * 0.02,
                              color: Colors.black.withOpacity(0.5),
                            ),
                          ),
                          Text(
                            history[widget.index]['survey_created_at']
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
                            "Үнэлгээ: ",
                            style: TextStyle(
                              fontSize: height * 0.02,
                              color: Colors.black.withOpacity(0.5),
                            ),
                          ),
                          Text(
                            history[widget.index]['price'] + "₮",
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
                  // Padding(
                  //   padding: EdgeInsets.only(left: width * 0.08),
                  //   child: Align(
                  //     alignment: Alignment.centerLeft,
                  //     child: ClipRRect(
                  //       borderRadius: BorderRadius.circular(
                  //         8.0,
                  //       ),
                  //       child: Material(
                  //         color: kBtn1Color,
                  //         child: InkWell(
                  //           onTap: () {},
                  //           child: Container(
                  //             child: Padding(
                  //               padding: const EdgeInsets.all(10.0),
                  //               child: Row(
                  //                 mainAxisSize: MainAxisSize.min,
                  //                 children: [
                  //                   Text(
                  //                     "Нийтлэгчийг дагах",
                  //                     style: TextStyle(
                  //                       color: Colors.white,
                  //                       fontSize: height * 0.02,
                  //                     ),
                  //                   ),
                  //                   SizedBox(width: width * 0.02),
                  //                   Icon(
                  //                     Icons.person_add,
                  //                     color: Colors.white,
                  //                   ),
                  //                 ],
                  //               ),
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
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
                      history[widget.index]['content'],
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
