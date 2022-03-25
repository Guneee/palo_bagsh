import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:palo/constants.dart';
import 'package:palo/data.dart';
import 'package:palo/helpers/app_preferences.dart';
import 'package:palo/pages/quest/widgets/quest_detail.dart';

import '../../../helpers/components.dart';

class QuestList extends StatefulWidget {
  final int index;
  const QuestList({
    Key? key,
    required this.index,
  }) : super(key: key);

  @override
  State<QuestList> createState() => _QuestListState();
}

class _QuestListState extends State<QuestList> {
  late GoogleMapController googleMapController;
  bool _isMap = false, _isLoad = false;

  _getLatLong(String location, int index) {
    double latLong = 7;
    if (index == 0) {
      latLong = double.parse(location.split(",").first);
    } else {
      latLong = double.parse(location.split(",").last);
    }
    return latLong;
  }

  _loadMarker() async {
    if (questItems[widget.index]["quest"] != null) {
      if (questItems[widget.index]["quest"].isNotEmpty) {
        questMarkers.clear();
        questItems[widget.index]["quest"].forEach((data) {
          Marker markerTemp1 = Marker(
              markerId: MarkerId(data["id"].toString()),
              position: LatLng(
                _getLatLong(data["location"], 0),
                _getLatLong(data["location"], 1),
              ),
              draggable: false,
              zIndex: 2,
              flat: true,
              infoWindow: InfoWindow(
                  title: data["title"],
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(data["title"]),
                          content: SingleChildScrollView(
                            child: Column(
                              children: [
                                if (data["image"] != null)
                                  SizedBox(
                                    height: 180.0,
                                    width: double.infinity,
                                    child: Image.network(
                                      data["image"],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                if (data["image"] != null)
                                  SizedBox(
                                    height: 8.0,
                                  ),
                                ListBody(
                                  children: <Widget>[
                                    if (data["phone"] != null)
                                      Text(data["phone"]),
                                    Text(data["created_at"]
                                        .toString()
                                        .substring(0, 10)),
                                    SizedBox(
                                      height: 12.0,
                                    ),
                                    Text(data["content"]),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: Text('ХААХ'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }));
          questMarkers.add(markerTemp1);
        });

        if (mounted) {
          setState(() {});
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: (widget.index % 2 == 1) ? kBtnColor : kPrimaryColor,
        centerTitle: true,
        elevation: 0.0,
        title: Ctext(
          text: questItems[widget.index]["title"].toString(),
          color: (widget.index % 2 == 1) ? Colors.white : kBtnColor,
          large: true,
        ),
        leading: IconButton(
          onPressed: () {
            back(context);
          },
          icon: Icon(
            Icons.close,
            color: (widget.index % 2 == 1) ? Colors.white : kBtnColor,
          ),
        ),
        actions: [
          Row(
            children: [
              Ctext(
                text: _isMap ? "map" : "list",
                extraSmall: true,
                color: (widget.index % 2 == 1) ? Colors.white : kBtnColor,
              ),
              Switch(
                value: _isMap,
                onChanged: (value) {
                  _loadMarker();
                  setState(() {
                    _isMap = value;
                  });
                },
              ),
            ],
          ),
        ],
      ),
      body: SizedBox(
        height: height,
        width: width,
        child: Column(
          children: [
            if (_isMap)
              Expanded(
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                      47.9176754,
                      106.9241525,
                    ),
                    zoom: 13.06,
                  ),
                  myLocationButtonEnabled: false,
                  markers: Set.of(
                    (questMarkers.isNotEmpty) ? questMarkers : [],
                  ),
                  onMapCreated: (GoogleMapController controller) {
                    googleMapController = controller;
                    _loadMarker();
                  },
                ),
              ),
            if (!_isMap)
              SingleChildScrollView(
                child: AnimationLimiter(
                  child: Column(
                    children: AnimationConfiguration.toStaggeredList(
                      duration: const Duration(milliseconds: 375),
                      childAnimationBuilder: (widget) => SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(
                          child: widget,
                        ),
                      ),
                      children: List.generate(
                        (questItems[widget.index]["quest"] != null)
                            ? questItems[widget.index]["quest"].length
                            : 0,
                        (index2) => Padding(
                          padding: EdgeInsets.only(
                            left: width * 0.06,
                            right: width * 0.06,
                            top: (index2 == 0) ? height * 0.03 : height * 0.01,
                            bottom:
                                (index2 == 1) ? height * 0.03 : height * 0.02,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  spreadRadius: 1.0,
                                  blurRadius: 3.0,
                                  color: Colors.white.withOpacity(0.05),
                                  offset: Offset(3.0, 3.0),
                                )
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Material(
                                color: Colors.white.withOpacity(0.1),
                                child: InkWell(
                                  onTap: () {
                                    go(
                                      context,
                                      QuestDetail(
                                        index: widget.index,
                                        index2: index2,
                                      ),
                                    );
                                  },
                                  child: SizedBox(
                                    height: height * 0.1,
                                    width: width,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        left: width * 0.05,
                                        right: width * 0.04,
                                        top: height * 0.01,
                                        bottom: height * 0.01,
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Ctext(
                                                    text: questItems[widget
                                                                .index]["quest"]
                                                            [index2]["title"]
                                                        .toString(),
                                                    bold: true,
                                                    textOverflow:
                                                        TextOverflow.ellipsis,
                                                    normal: true,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Ctext(
                                                    text: questItems[widget
                                                                .index]["quest"]
                                                            [index2]["content"]
                                                        .toString(),
                                                    maxLine: 2,
                                                    small: true,
                                                    textOverflow:
                                                        TextOverflow.ellipsis,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(width: width * 0.02),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Ctext(
                                                text: questItems[widget.index]
                                                            ["quest"][index2]
                                                        ["amount"]
                                                    .toString(),
                                                color: Colors.white,
                                                bold: true,
                                                large: true,
                                              ),
                                              Ctext(
                                                text: "оноо",
                                                normal: true,
                                                color: Colors.white,
                                              ),
                                            ],
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
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
