import 'package:flutter/material.dart';
import 'package:palo/constants.dart';
import 'package:palo/helpers/app_preferences.dart';
import 'package:palo/helpers/components.dart';

import '../../data.dart';

class JobList extends StatefulWidget {
  final VoidCallback onFilterChanged;
  const JobList({
    Key? key,
    required this.onFilterChanged,
  }) : super(key: key);

  @override
  State<JobList> createState() => _JobListState();
}

class _JobListState extends State<JobList> {
  final _searchTEC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double height = size(context).height;
    double width = size(context).width;
    return SizedBox(
      height: height,
      width: width,
      child: Stack(
        children: [
          SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: _top(height, width),
            ),
          ),
        ],
      ),
    );
  }

  Widget _filter(double height, double width) => Padding(
        padding: EdgeInsets.only(
          top: height * 0.01,
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            height: height * 0.08,
            child: Center(
              child: Row(
                children: [
                  SizedBox(width: width * 0.04),
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          spreadRadius: 1.0,
                          blurRadius: 5.0,
                          color: kPrimaryColor.withOpacity(0.14),
                          offset: Offset(0.0, 3.0),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Material(
                        color: isProduct != null
                            ? (isProduct! ? Colors.white : kPrimaryColor)
                            : Colors.white,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              if (isProduct != null) {
                                if (!isProduct!) {
                                  var toNull;
                                  isProduct = toNull;
                                  widget.onFilterChanged.call();
                                } else {
                                  isProduct = false;
                                  widget.onFilterChanged.call();
                                }
                              } else {
                                isProduct = false;
                                widget.onFilterChanged.call();
                              }
                            });
                          },
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: width * 0.02,
                              right: width * 0.02,
                              top: height * 0.006,
                              bottom: height * 0.006,
                            ),
                            child: Row(
                              children: [
                                Image.asset(
                                  "assets/near_job.png",
                                  height: height * 0.04,
                                  width: height * 0.04,
                                ),
                                SizedBox(width: width * 0.014),
                                Ctext(
                                  text: "Таньд ойр ажил",
                                  normal: true,
                                  color: isProduct != null
                                      ? (isProduct!
                                          ? Colors.black
                                          : Colors.white)
                                      : Colors.black,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: width * 0.02),
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          spreadRadius: 1.0,
                          blurRadius: 5.0,
                          color: kPrimaryColor.withOpacity(0.14),
                          offset: Offset(0.0, 3.0),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Material(
                        color: isProduct != null
                            ? (isProduct! ? kPrimaryColor : Colors.white)
                            : Colors.white,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              if (isProduct != null) {
                                if (isProduct!) {
                                  var toNull;
                                  isProduct = toNull;
                                  widget.onFilterChanged.call();
                                } else {
                                  isProduct = true;
                                  widget.onFilterChanged.call();
                                }
                              } else {
                                isProduct = true;
                                widget.onFilterChanged.call();
                              }
                            });
                          },
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: width * 0.02,
                              right: width * 0.02,
                              top: height * 0.006,
                              bottom: height * 0.006,
                            ),
                            child: Row(
                              children: [
                                Image.asset(
                                  "assets/near_product.png",
                                  height: height * 0.04,
                                  width: height * 0.04,
                                ),
                                SizedBox(width: width * 0.014),
                                Ctext(
                                  text: "Таньд ойр бүтээгдэхүүн",
                                  normal: true,
                                  color: isProduct != null
                                      ? (isProduct!
                                          ? Colors.white
                                          : Colors.black)
                                      : Colors.black,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: width * 0.04),
                ],
              ),
            ),
          ),
        ),
      );

  Widget _search(double height, double width) => Padding(
        padding: EdgeInsets.only(
          top: height * 0.02,
          left: width * 0.04,
          right: width * 0.04,
        ),
        child: Row(
          children: [
            IconButton(
              onPressed: () {},
              icon: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50.0),
                  border: Border.all(
                    width: 1.5,
                    color: Colors.black,
                  ),
                ),
                child: Icon(
                  Icons.more_horiz,
                  color: Colors.black.withOpacity(0.3),
                ),
              ),
            ),
            SizedBox(width: width * 0.03),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: SizedBox(
                  height: height * 0.05,
                  width: width,
                  child: TextField(
                    controller: _searchTEC,
                    onChanged: (value) {
                      setState(() {});
                    },
                    decoration: InputDecoration(
                      hintText: "Хайх",
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.search),
                      fillColor: Colors.grey[200],
                      filled: true,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  Widget _top(double height, double width) => Column(
        children: [
          _search(height, width),
          _filter(height, width),
        ],
      );
}
