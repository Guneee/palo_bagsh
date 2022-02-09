import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:palo/helpers/api_url.dart';
import '../../constants.dart';
import '../../data.dart';
import 'package:http/http.dart' as https;

class JobPage extends StatefulWidget {
  const JobPage({Key? key}) : super(key: key);

  @override
  _JobPageState createState() => _JobPageState();
}

class _JobPageState extends State<JobPage> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  bool _isLoad = false;
  late GoogleMapController googleMapController;
  var _data;

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
      _data = data;
    });
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
    jobs.clear();
    json.decode(responce.body)["nearjobs"].forEach((data) {
      jobs.add(data);
    });
    json.decode(responce.body)["nearjobs"].forEach((data) {
      Marker markerTemp1 = Marker(
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

      jobMarkers.add(markerTemp1);
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
      bottomSheet: (!_isLoad)
          ? DraggableScrollableSheet(
              expand: false,
              initialChildSize: 0.1,
              minChildSize: 0.1,
              maxChildSize: 0.95,
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return SingleChildScrollView(
                  controller: scrollController,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(18.0),
                      topRight: Radius.circular(18.0),
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: height * 0.006),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        Text(
                          "Нийт " + jobs.length.toString() + " ажил байна",
                          style: TextStyle(
                            fontSize: height * 0.022,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: height * 0.04),
                        Column(
                          children: List.generate(
                            jobs.length,
                            (index) => Padding(
                              padding: EdgeInsets.only(
                                bottom: height * 0.04,
                                left: width * 0.06,
                                right: width * 0.06,
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
                                    height: 12.0,
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      (index + 1).toString() +
                                          ". " +
                                          jobs[index]["title"],
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      jobs[index]["content"],
                                      textAlign: TextAlign.justify,
                                    ),
                                  ),
                                  SizedBox(height: 8.0),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(jobs[index]["phone"]),
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(jobs[index]["work_time"]),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
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
                      child: _body(height, width),
                    ),
                ],
              ),
            ),
            if (_data != null)
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(bottom: height * 0.14),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 3.0,
                          spreadRadius: 1.0,
                          offset: Offset(0.0, 3.0),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    height: height * 0.15,
                    width: width * 0.9,
                    child: Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(16.0),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16.0),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(_data["title"]),
                                content: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      if (_data["image"] != null)
                                        SizedBox(
                                          height: 180.0,
                                          width: double.infinity,
                                          child: Image.network(
                                            _data["image"],
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      if (_data["image"] != null)
                                        SizedBox(
                                          height: 8.0,
                                        ),
                                      ListBody(
                                        children: <Widget>[
                                          Text(_data["phone"]),
                                          Text(_data["work_time"]),
                                          SizedBox(
                                            height: 12.0,
                                          ),
                                          Text(_data["content"]),
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
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16.0),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Image.network(
                                  _data["image"],
                                  fit: BoxFit.cover,
                                  height: height * 0.15,
                                  width: width * 0.9,
                                ),
                              ),
                              Expanded(
                                flex: 4,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    left: width * 0.04,
                                    right: width * 0.04,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          _data["title"],
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          _data["content"],
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          _data["work_time"],
                                          overflow: TextOverflow.ellipsis,
                                        ),
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
  }

  Widget _body(double height, double width) => GoogleMap(
      initialCameraPosition: CameraPosition(
        target: LatLng(
          47.9176754,
          106.9241525,
        ),
        zoom: 13.06,
      ),
      myLocationButtonEnabled: false,
      markers: Set.of((jobMarkers.isNotEmpty) ? jobMarkers : []),
      onMapCreated: (GoogleMapController controller) {
        googleMapController = controller;
      },
      onTap: (lat) {
        setState(() {
          var toNull;
          _data = toNull;
        });
      });
}
