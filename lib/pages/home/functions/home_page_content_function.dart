import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as https;

import '../../../data.dart';
import '../../../helpers/api_url.dart';
import '../../../models/home_model.dart';

double toRadius(double x) {
  return x * pi / 180;
}

void checkIsHistory() {
  for (int i = 0; i < homeItems.length; i++) {
    for (int j = 0; j < homeItems[i].surveys.length; j++) {
      var existingCall = history.firstWhere(
          (favCall) =>
              favCall["survey_id"].toString() ==
              homeItems[i].surveys[j]["id"].toString(),
          orElse: () => null);

      if (existingCall != null) {
        homeItems[i].surveys[j]["is_history"] = true;
      } else {
        homeItems[i].surveys[j]["is_history"] = false;
      }
    }
  }

  for (int i = 0; i < surveys.length; i++) {
    var existingCall = history.firstWhere(
        (favCall) =>
            favCall["survey_id"].toString() == surveys[i]["id"].toString(),
        orElse: () => null);

    if (existingCall != null) {
      surveys[i]["is_history"] = true;
    } else {
      surveys[i]["is_history"] = false;
    }
  }
}

Future<void> getCurrentLocation() async {
  LocationPermission permission;
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }
  try {
    Position userLocation = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    String location = userLocation.latitude.toString() +
        "," +
        userLocation.longitude.toString();
    if (kDebugMode) {
      print(location);
    }

    double lat = double.parse(location.split(',')[0].toString());
    double lng = double.parse(location.split(',')[1].toString());

    int length = surveys.length;
    nearSurveys.clear();

    for (int i = 0; i < length; i++) {
      if (surveys[i]['location'].toString() != "null") {
        int r = 6378137; // Earth’s mean radius in meter
        double dLat = toRadius(
            double.parse(surveys[i]['location'].toString().split(',')[0]) -
                lat);
        double dLong = toRadius(
            double.parse(surveys[i]['location'].toString().split(',')[1]) -
                lng);
        double a = sin(dLat / 2) * sin(dLat / 2) +
            cos(toRadius(lat)) *
                cos(toRadius(double.parse(
                    surveys[i]['location'].toString().split(',')[0]))) *
                sin(dLong / 2) *
                sin(dLong / 2);
        double c = 2 * atan2(sqrt(a), sqrt(1 - a));
        double d = r * c;
        if (d < 50000000000) {
          nearSurveys.add(surveys[i]);
          if (kDebugMode) {
            print("near found");
          }
        } else {
          if (kDebugMode) {
            print("far found");
          }
        }
      }
    }
  } on PlatformException catch (e) {
    if (e.code == 'PERMISSION_DENIED') {
      debugPrint("Permission Denied");
    }
  }
}

Future<void> refreshData() async {
  final responce = await https.post(
    Uri.parse(mainApiUrl + "v1/get-data"),
    headers: {
      "Authorization": "Bearer $token",
    },
    body: {
      'id': currentUserId.toString(),
    },
  );

  categoryItems.clear();
  List fetchItem = [];

  final items = json.encode(json.decode(responce.body)["data"]);
  fetchItem = json.decode(items);
  for (var element in fetchItem) {
    HomeModel homeModel = HomeModel(
      id: element["id"].toString(),
      title: element["title"].toString(),
      image: element["image"].toString(),
      surveys: element["survey"] ?? [],
      createdAt: element["created_at"].toString(),
    );
    homeItems.add(homeModel);
  }
  var body = json.decode(responce.body);
  history.clear();
  json.decode(responce.body)["history"].forEach((item) {
    history.add(item);
  });
  surveys.clear();
  json.decode(responce.body)['surveys'].forEach((value) {
    surveys.add(value);
  });
  banners.clear();
  json.decode(responce.body)['banners'].forEach((value) {
    banners.add(value);
  });
  quests.clear();
  body["quests"].forEach((value) {
    quests.add(value);
  });
  questCategories.clear();
  body["quest_categories"].forEach((value) {
    questCategories.add(value);
  });
  questItems.clear();
  body["quest_items"].forEach((value) {
    questItems.add(value);
  });
  categories.clear();
  body["categories"].forEach((value) {
    categories.add(value);
  });
  // print(categories.toString());

  checkIsHistory();

  isFirstHome = true;
}
