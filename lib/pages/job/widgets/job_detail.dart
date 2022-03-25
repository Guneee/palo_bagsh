import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:palo/constants.dart';
import 'package:palo/helpers/components.dart';

import '../../../data.dart';
import '../../../helpers/app_preferences.dart';

class JobDetail extends StatefulWidget {
  final int index;
  const JobDetail({
    Key? key,
    required this.index,
  }) : super(key: key);

  @override
  State<JobDetail> createState() => _JobDetailState();
}

class _JobDetailState extends State<JobDetail> {
  final GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();
  int index = 0;

  @override
  void initState() {
    setState(() {
      index = widget.index;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = size(context).height;
    double width = size(context).width;
    return Scaffold(
      key: globalKey,
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: kBtnColor,
        title: Ctext(
          text: "Дэлгэрэнгүй",
          color: Colors.white,
          large: true,
        ),
        leading: IconButton(
          onPressed: () {
            back(context);
          },
          icon: Icon(
            Icons.close,
            color: Colors.white,
          ),
        ),
      ),
      body: SizedBox(
        height: height,
        width: width,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                top: height * 0.03,
                left: width * 0.06,
                right: width * 0.06,
                bottom: height * 0.06,
              ),
              child: Column(
                children: [
                  if (jobs[index]["image"] != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Image.network(
                        jobs[index]["image"],
                        height: height * 0.3,
                        width: width,
                        fit: BoxFit.cover,
                      ),
                    ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      jobs[index]["title"],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: height * 0.022,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      jobs[index]["content"],
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        letterSpacing: 1.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.02),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      jobs[index]["phone"],
                      style: TextStyle(
                        color: kPrimaryColor,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.01),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      jobs[index]["work_time"],
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
