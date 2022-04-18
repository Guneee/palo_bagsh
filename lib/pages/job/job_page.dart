import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:palo/helpers/api_url.dart';
import 'package:palo/helpers/app_preferences.dart';
import 'package:palo/helpers/components.dart';
import 'package:palo/pages/job/job_list.dart';
import 'package:palo/pages/job/job_map.dart';
import 'package:palo/pages/job/widgets/job_detail.dart';
import '../../constants.dart';
import '../../data.dart';
import 'package:http/http.dart' as https;
import 'dart:ui' as ui;

class JobPage extends StatefulWidget {
  const JobPage({Key? key}) : super(key: key);

  @override
  _JobPageState createState() => _JobPageState();
}

class _JobPageState extends State<JobPage> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  bool _isLoad = false;
  final _searchTEC = TextEditingController();

  _getLatLong(String location, int index) {
    double latLong = 7;
    if (index == 0) {
      latLong = double.parse(location.split(",").first);
    } else {
      latLong = double.parse(location.split(",").last);
    }
    return latLong;
  }

  _showInfo(var data) {
    setState(() {
      jobData = data;
    });
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoad = true;
    });

    final responce = await https.get(
      Uri.parse(mainApiUrl + "v1/get-jobs"),
      headers: {
        "Authorization": "Bearer $token",
      },
    );
    jobMarkers.clear();
    jobMarkers3.clear();
    jobs.clear();
    jobs2.clear();
    jobs3.clear();

    json.decode(responce.body)["nearjobs"].forEach((data) {
      jobs3.add(data);
    });

    json.decode(responce.body)["nearjobs"].forEach((data) async {
      final Uint8List markerIcon =
          await getBytesFromAsset('assets/location_pin.png', 60);

      Marker markerTemp1 = Marker(
        icon: BitmapDescriptor.fromBytes(markerIcon),
        markerId: MarkerId(data["id"].toString()),
        position: LatLng(
          _getLatLong(data["location"], 0),
          _getLatLong(data["location"], 1),
        ),
        draggable: false,
        zIndex: 2,
        flat: true,
        onTap: () {
          _showInfo(data);
        },
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
                              Text(data["phone"]),
                              Text(data["work_time"]),
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
            }),
      );

      // jobMarkers.add(markerTemp1);
      jobMarkers3.add(markerTemp1);
      if (mounted) {
        setState(() {});
      }
    });
    isJobPageFirstTime = true;
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
      key: _key,
      backgroundColor: kBackgroundColor,
      bottomSheet: (!_isLoad)
          ? isProduct != null
              ? isProduct!
                  ? DraggableScrollableSheet(
                      expand: false,
                      initialChildSize: jobs2.isNotEmpty ? 0.26 : 0.2,
                      minChildSize: jobs2.isNotEmpty ? 0.26 : 0.2,
                      maxChildSize: 0.95,
                      builder: (BuildContext context,
                          ScrollController scrollController) {
                        return SingleChildScrollView(
                          controller: scrollController,
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12.0),
                              topRight: Radius.circular(12.0),
                            ),
                            child: Container(
                              color: Colors.white,
                              child: Column(
                                children: [
                                  SizedBox(height: height * 0.006),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(""),
                                      Container(
                                        width: width * 0.06,
                                        height: 1.5,
                                        color: Colors.black,
                                      ),
                                      Text(""),
                                    ],
                                  ),
                                  SizedBox(height: height * 0.01),
                                  Ctext(
                                    text: "Бүтээгдэхүүн",
                                    bold: true,
                                    large: true,
                                  ),
                                  SizedBox(height: height * 0.01),
                                  Column(
                                    children: List.generate(
                                      jobs2.length,
                                      (index) => Padding(
                                        padding: EdgeInsets.only(
                                          bottom: height * 0.04,
                                          left: width * 0.06,
                                          right: width * 0.06,
                                        ),
                                        child: InkWell(
                                          onTap: () {
                                            go(
                                              context,
                                              JobDetail(index: index),
                                            );
                                          },
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      children: [
                                                        Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Ctext(
                                                            text: jobs2[index]
                                                                ["title"],
                                                            normal: true,
                                                            bold: true,
                                                          ),
                                                        ),
                                                        Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Ctext(
                                                            text: jobs2[index]
                                                                ["address"],
                                                            normal: true,
                                                            color: kGreyColor,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                            height:
                                                                height * 0.02),
                                                        Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Ctext(
                                                            text: jobs2[index]
                                                                ["work_time"],
                                                            small: true,
                                                            bold: true,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                            height:
                                                                height * 0.014),
                                                      ],
                                                    ),
                                                  ),
                                                  Ctext(
                                                    text: "500м",
                                                    small: true,
                                                  ),
                                                ],
                                              ),
                                              Container(
                                                width: width,
                                                height: 1.5,
                                                color: Colors.grey
                                                    .withOpacity(0.4),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: height * 0.8),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  : DraggableScrollableSheet(
                      expand: false,
                      initialChildSize: jobs3.isNotEmpty ? 0.26 : 0.2,
                      minChildSize: jobs3.isNotEmpty ? 0.26 : 0.2,
                      maxChildSize: 0.95,
                      builder: (BuildContext context,
                          ScrollController scrollController) {
                        return SingleChildScrollView(
                          controller: scrollController,
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12.0),
                              topRight: Radius.circular(12.0),
                            ),
                            child: Container(
                              color: Colors.white,
                              child: Column(
                                children: [
                                  SizedBox(height: height * 0.006),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(""),
                                      Container(
                                        width: width * 0.06,
                                        height: 1.5,
                                        color: Colors.black,
                                      ),
                                      Text(""),
                                    ],
                                  ),
                                  SizedBox(height: height * 0.01),
                                  Ctext(
                                    text: "Ажил",
                                    bold: true,
                                    large: true,
                                  ),
                                  SizedBox(height: height * 0.01),
                                  Column(
                                    children: List.generate(
                                      jobs3.length,
                                      (index) => Padding(
                                        padding: EdgeInsets.only(
                                          bottom: height * 0.04,
                                          left: width * 0.06,
                                          right: width * 0.06,
                                        ),
                                        child: InkWell(
                                          onTap: () {
                                            go(
                                              context,
                                              JobDetail(index: index),
                                            );
                                          },
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      children: [
                                                        Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Ctext(
                                                            text: jobs3[index]
                                                                ["title"],
                                                            normal: true,
                                                            bold: true,
                                                          ),
                                                        ),
                                                        Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Ctext(
                                                            text: jobs3[index]
                                                                ["address"],
                                                            normal: true,
                                                            color: kGreyColor,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                            height:
                                                                height * 0.02),
                                                        Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Ctext(
                                                            text: jobs3[index]
                                                                ["work_time"],
                                                            small: true,
                                                            bold: true,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                            height:
                                                                height * 0.014),
                                                      ],
                                                    ),
                                                  ),
                                                  Ctext(
                                                    text: "500м",
                                                    small: true,
                                                  ),
                                                ],
                                              ),
                                              Container(
                                                width: width,
                                                height: 1.5,
                                                color: Colors.grey
                                                    .withOpacity(0.4),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: height * 0.8),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    )
              : DraggableScrollableSheet(
                  expand: false,
                  initialChildSize: jobs.isNotEmpty ? 0.26 : 0.2,
                  minChildSize: jobs.isNotEmpty ? 0.26 : 0.2,
                  maxChildSize: 0.95,
                  builder: (BuildContext context,
                      ScrollController scrollController) {
                    return SingleChildScrollView(
                      controller: scrollController,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12.0),
                          topRight: Radius.circular(12.0),
                        ),
                        child: Container(
                          color: Colors.white,
                          child: Column(
                            children: [
                              SizedBox(height: height * 0.006),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(""),
                                  Container(
                                    width: width * 0.06,
                                    height: 1.5,
                                    color: Colors.black,
                                  ),
                                  Text(""),
                                ],
                              ),
                              SizedBox(height: height * 0.01),
                              Ctext(
                                text: "Сүүлд үзсэн",
                                bold: true,
                                large: true,
                              ),
                              SizedBox(height: height * 0.01),
                              Column(
                                children: List.generate(
                                  jobs.length,
                                  (index) => Padding(
                                    padding: EdgeInsets.only(
                                      bottom: height * 0.04,
                                      left: width * 0.06,
                                      right: width * 0.06,
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        go(context, JobDetail(index: index));
                                      },
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  children: [
                                                    Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Ctext(
                                                        text: jobs[index]
                                                            ["title"],
                                                        normal: true,
                                                        bold: true,
                                                      ),
                                                    ),
                                                    Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Ctext(
                                                        text: jobs[index]
                                                            ["address"],
                                                        normal: true,
                                                        color: kGreyColor,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                        height: height * 0.02),
                                                    Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Ctext(
                                                        text: jobs[index]
                                                            ["work_time"],
                                                        small: true,
                                                        bold: true,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                        height: height * 0.014),
                                                  ],
                                                ),
                                              ),
                                              Ctext(
                                                text: "500м",
                                                small: true,
                                              ),
                                            ],
                                          ),
                                          Container(
                                            width: width,
                                            height: 1.5,
                                            color: Colors.grey.withOpacity(0.4),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: height * 0.8),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                )
          : null,
      body: SizedBox(
        height: height,
        width: width,
        child: Stack(
          children: [
            SizedBox(
              height: height,
              width: width,
              child: Column(
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
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(kPrimaryColor),
                              strokeWidth: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                  if (!_isLoad)
                    Expanded(
                      child: Stack(
                        children: [
                          JobMap(),
                          JobList(
                            onFilterChanged: () {
                              setState(() {});
                            },
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
