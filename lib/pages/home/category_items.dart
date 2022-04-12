import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../../data.dart';
import 'survey_detail.dart';

class CategoryItems extends StatefulWidget {
  final int index;
  const CategoryItems({
    Key? key,
    required this.index,
  }) : super(key: key);

  @override
  _CategoryItemsState createState() => _CategoryItemsState();
}

class _CategoryItemsState extends State<CategoryItems> {
  final _searchTEC = TextEditingController();

  bool _checkSearch(int index2) {
    if (homeItems[widget.index]
        .surveys[index2]["title"]
        .toString()
        .toUpperCase()
        .contains(
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
      body: SizedBox(
        height: height,
        width: width,
        child: SafeArea(
          child: Column(
            children: [
              _top(height, width),
              SizedBox(height: height * 0.01),
              _search(height, width),
              SizedBox(height: height * 0.04),
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
          style: TextStyle(fontSize: height * 0.02),
          onChanged: (value) {
            setState(() {});
          },
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.search,
              size: height * 0.024,
            ),
            hintText: 'Хайх..',
            hintStyle: TextStyle(fontSize: height * 0.02),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32.0),
              borderSide: const BorderSide(
                width: 0,
                style: BorderStyle.none,
              ),
            ),
            filled: true,
            contentPadding: const EdgeInsets.all(1),
            isDense: true,
          ),
        ),
      );

  Widget _body(double height, double width) => Expanded(
        child: ListView.builder(
          itemCount: homeItems[widget.index].surveys.length,
          itemBuilder: (context, index2) => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (homeItems[widget.index].surveys.length > index2 + index2)
                if (_checkSearch(index2 + index2))
                  Padding(
                    padding: EdgeInsets.only(
                      right: width * 0.034,
                      bottom: height * 0.034,
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
                                  duration: Duration(milliseconds: 175),
                                  type: PageTransitionType.rightToLeft,
                                  child: SurveyDetail(
                                    index: widget.index,
                                    index2: index2 + index2,
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
                                    child: Image.network(
                                      homeItems[widget.index]
                                          .surveys[index2 + index2]["image"]
                                          .toString(),
                                      fit: BoxFit.cover,
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
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Align(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              "    " +
                                                  homeItems[widget.index]
                                                      .surveys[index2 + index2]
                                                          ["title"]
                                                      .toString(),
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: height * 0.02,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Column(
                                            children: [
                                              Align(
                                                alignment: Alignment.topLeft,
                                                child: Text(
                                                  "    " "Шагнал " +
                                                      homeItems[widget.index]
                                                          .surveys[index2 +
                                                              index2]["price"]
                                                          .toString() +
                                                      "₮",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontSize: height * 0.018,
                                                    color: Colors.black
                                                        .withOpacity(0.5),
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
              if (homeItems[widget.index].surveys.length > index2 + index2 + 1)
                if (_checkSearch(index2 + index2 + 1))
                  Padding(
                    padding: EdgeInsets.only(
                      left: width * 0.034,
                      bottom: height * 0.034,
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
                                  duration: Duration(milliseconds: 175),
                                  type: PageTransitionType.rightToLeft,
                                  child: SurveyDetail(
                                      index: widget.index,
                                      index2: index2 + index2 + 1),
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
                                    child: Image.network(
                                      homeItems[widget.index]
                                          .surveys[index2 + index2 + 1]["image"]
                                          .toString(),
                                      fit: BoxFit.cover,
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
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Align(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              "    " +
                                                  homeItems[widget.index]
                                                      .surveys[index2 +
                                                          index2 +
                                                          1]["title"]
                                                      .toString(),
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: height * 0.02,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Column(
                                            children: [
                                              Align(
                                                alignment: Alignment.topLeft,
                                                child: Text(
                                                  "    " "Шагнал " +
                                                      homeItems[widget.index]
                                                          .surveys[index2 +
                                                              index2]["price"]
                                                          .toString() +
                                                      "₮",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontSize: height * 0.018,
                                                    color: Colors.black
                                                        .withOpacity(0.5),
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
      );

  Widget _top(double height, double width) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios),
          ),
          Text(
            homeItems[widget.index].title,
            style: TextStyle(
              fontSize: height * 0.022,
              fontWeight: FontWeight.bold,
            ),
          ),
          const IconButton(
            onPressed: null,
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.transparent,
            ),
          ),
        ],
      );
}
