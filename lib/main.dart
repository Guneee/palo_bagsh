import 'dart:async';
import 'dart:io';
import 'package:background_fetch/background_fetch.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_isolate/flutter_isolate.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as https;
import 'constants.dart';
import 'data.dart';
import 'helpers/api_url.dart';
import 'pages/splash_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  if (Platform.isAndroid) {
    if (kDebugMode) {
      print("starting android");
    }
    detectLocation();
    BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
    BackgroundFetch.scheduleTask(TaskConfig(
      taskId: "com.transistorsoft.flutter_background_fetch",
      delay: 1 * 1 * 5000,
      periodic: true,
      forceAlarmManager: false,
      stopOnTerminate: false,
      enableHeadless: true,
    ));
  } else if (Platform.isIOS) {
    if (kDebugMode) {
      print("starting ios");
    }
    detectLocation();

    // BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
    // BackgroundFetch.configure(BackgroundFetchConfig(minimumFetchInterval: 15),
    //     (String taskId) async {
    //   print("[BackgroundFetch] taskId: $taskId");
    // }, (String taskId) async {
    //   print("[BackgroundFetch] TIMEOUT taskId: $taskId");
    // });

    // BackgroundFetch.scheduleTask(TaskConfig(
    //   taskId: "com.transistorsoft.flutter_background_fetch",
    //   delay: 1 * 1 * 5000,
    //   periodic: true,
    //   forceAlarmManager: false,
    //   stopOnTerminate: false,
    //   enableHeadless: true,
    // ));
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Palo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        primarySwatch: Colors.blueGrey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const SplashPage(),
    );
  }
}

void backgroundFetchHeadlessTask(HeadlessTask task) async {
  var taskId = task.taskId;

  if (kDebugMode) {
    print("[BackgroundFetch] Headless event received: $taskId");
  }

  if (taskId == "com.transistorsoft.flutter_background_fetch") {
    detectLocationCheck();
  }
}

void detectLocationCheck() async {
  LocationPermission permission;
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
  } else {
    Position userLocation = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    String _location = userLocation.latitude.toString() +
        "," +
        userLocation.longitude.toString();
    String _speed = userLocation.speed.toString();
    final prefs = await SharedPreferences.getInstance();

    String? _phone = prefs.getString("username");
    String? _email = prefs.getString("email");
    String? _id = prefs.getString("id");
    String? _firstname = prefs.getString("firstname");
    String? _lastname = prefs.getString("lastname");
    if (_phone != null && _phone != "") {
      sendLocationData(
        _id!,
        _firstname!,
        _lastname!,
        _location,
        _email!,
        _speed,
        _phone,
      );
    }
  }
}

void sendLocationData(String _id, String _firstname, String _lastname,
    String _location, String _email, String _speed, String _phone) async {
  DateTime now = DateTime.now();
  final responce =
      await https.post(Uri.parse(mainApiUrl + "v1/push-location"), headers: {
    "Authorization": "Bearer $token",
    // "Content-Type": "application/json"
  }, body: {
    'id': _id,
    'firstname': _firstname,
    'lastname': _lastname,
    'email': _email,
    'location': _location,
    'speed': _speed,
    'phone': _phone,
    'date': now.toString(),
  });
  if (kDebugMode) {
    print(responce.body);
  }
}

void isolate2(String _userData) async {
  if (kDebugMode) {
    print("isolate started..");
  }
  Position userLocation = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
  String _location = userLocation.latitude.toString() +
      "," +
      userLocation.longitude.toString();
  String _speed = userLocation.speed.toString();

  String _phone = _userData.split(",").elementAt(0);
  String _email = _userData.split(",").elementAt(1);
  String _id = _userData.split(",").elementAt(2);
  String _firstname = _userData.split(",").elementAt(3);
  String _lastname = _userData.split(",").elementAt(4);

  if (_phone != "") {
    sendLocationData(
        _id, _firstname, _lastname, _location, _email, _speed, _phone);
  }
  if (kDebugMode) {
    print(_location + ", " + _speed);
  }

  if (kDebugMode) {
    print("isolate done!");
  }
}

void detectLocation() async {
  LocationPermission permission;
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
  } else {
    final prefs = await SharedPreferences.getInstance();

    String? _username = prefs.getString("username");
    String? _email = prefs.getString("email");
    String? _id = prefs.getString("id");
    String? _firstname = prefs.getString("firstname");
    String? _lastname = prefs.getString("lastname");
    if (kDebugMode) {
      print(_username);
    }
    if (_username != null && _username != "") {
      if (kDebugMode) {
        print("User location tracking..");
      }
      try {
        await FlutterIsolate.spawn(
            isolate2,
            _username +
                "," +
                _email! +
                "," +
                _id! +
                "," +
                _firstname! +
                "," +
                _lastname!);
      } on PlatformException catch (e) {
        if (e.code == 'PERMISSION_DENIED') {
          debugPrint("Permission Denied");
        }
      }
      Timer.periodic(const Duration(minutes: 5), (timer) async {
        try {
          await FlutterIsolate.spawn(
              isolate2,
              _username +
                  "," +
                  _email! +
                  "," +
                  _id! +
                  "," +
                  _firstname! +
                  "," +
                  _lastname!);
        } on PlatformException catch (e) {
          if (e.code == 'PERMISSION_DENIED') {
            debugPrint("Permission Denied");
          }
        }
      });
    }
  }
}
