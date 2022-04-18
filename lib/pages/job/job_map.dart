import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:palo/helpers/app_preferences.dart';

import '../../data.dart';

class JobMap extends StatefulWidget {
  const JobMap({Key? key}) : super(key: key);

  @override
  State<JobMap> createState() => _JobMapState();
}

class _JobMapState extends State<JobMap> {
  late GoogleMapController googleMapController;

  @override
  Widget build(BuildContext context) {
    double height = size(context).height;
    double width = size(context).width;
    return Stack(
      children: [
        if (isProduct == null) _body1(height, width),
        if (isProduct == true) _body2(height, width),
        if (isProduct == false) _body3(height, width),
        if (jobData != null)
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: height * 0.2),
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
                  borderRadius: BorderRadius.circular(10.0),
                ),
                height: height * 0.15,
                width: width * 0.9,
                child: Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(10.0),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10.0),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(jobData["title"]),
                            content: SingleChildScrollView(
                              child: Column(
                                children: [
                                  if (jobData["image"] != null)
                                    SizedBox(
                                      height: 180.0,
                                      width: double.infinity,
                                      child: Image.network(
                                        jobData["image"],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  if (jobData["image"] != null)
                                    SizedBox(
                                      height: 8.0,
                                    ),
                                  ListBody(
                                    children: <Widget>[
                                      Text(jobData["phone"]),
                                      Text(jobData["work_time"]),
                                      SizedBox(
                                        height: 12.0,
                                      ),
                                      Text(jobData["content"]),
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
                      borderRadius: BorderRadius.circular(10.0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Image.network(
                              jobData["image"],
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
                                      jobData["title"],
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      jobData["content"],
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      jobData["work_time"],
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
    );
  }

  Widget _body3(double height, double width) => GoogleMap(
      buildingsEnabled: false,
      initialCameraPosition: CameraPosition(
        target: LatLng(
          47.9176754,
          106.9241525,
        ),
        zoom: 13.06,
      ),
      myLocationButtonEnabled: false,
      markers: Set.of((jobMarkers3.isNotEmpty) ? jobMarkers3 : []),
      onMapCreated: (GoogleMapController controller) {
        rootBundle.loadString('assets/map_style.json').then((String mapStyle) {
          controller.setMapStyle(mapStyle);
        });
      },
      onTap: (lat) {
        setState(() {
          var toNull;
          jobData = toNull;
        });
      });

  Widget _body2(double height, double width) => GoogleMap(
      buildingsEnabled: false,
      initialCameraPosition: CameraPosition(
        target: LatLng(
          47.9176754,
          106.9241525,
        ),
        zoom: 13.06,
      ),
      myLocationButtonEnabled: false,
      markers: Set.of((jobMarkers2.isNotEmpty) ? jobMarkers2 : []),
      onMapCreated: (GoogleMapController controller) {
        rootBundle.loadString('assets/map_style.json').then((String mapStyle) {
          controller.setMapStyle(mapStyle);
        });
      },
      onTap: (lat) {
        setState(() {
          var toNull;
          jobData = toNull;
        });
      });

  Widget _body1(double height, double width) => GoogleMap(
      buildingsEnabled: false,
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
        rootBundle.loadString('assets/map_style.json').then((String mapStyle) {
          controller.setMapStyle(mapStyle);
        });
      },
      onTap: (lat) {
        setState(() {
          var toNull;
          jobData = toNull;
        });
      });
}
