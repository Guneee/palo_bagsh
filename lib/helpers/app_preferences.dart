import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:page_transition/page_transition.dart';

import '../constants.dart';

Size size(BuildContext context) {
  return MediaQuery.of(context).size;
}

goAndClear(BuildContext context, Widget page) {
  Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => page),
      (Route<dynamic> route) => false);
}

goRepalce(BuildContext context, Widget page) {
  Navigator.pushReplacement(
    context,
    PageTransition(
      duration: Duration(milliseconds: 175),
      type: PageTransitionType.rightToLeft,
      child: page,
    ),
  );
}

go(BuildContext context, Widget page) {
  Navigator.push(
    context,
    PageTransition(
      duration: Duration(milliseconds: 175),
      type: PageTransitionType.rightToLeft,
      child: page,
    ),
  );
}

Future<void> checkLocationPermission() async {
  LocationPermission permission;
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }
}

void showSnackBar(String value, GlobalKey<ScaffoldState> globalKey) {
  // ignore: deprecated_member_use
  globalKey.currentState!.showSnackBar(
    SnackBar(
      content: Text(value),
      duration: const Duration(seconds: 2),
    ),
  );
}

loading(bool status, BuildContext context) {
  if (status == true) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: const [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
              ),
              SizedBox(
                height: 12.0,
              ),
              Text("Loading"),
            ],
          ),
        );
      },
    );
  } else {
    Navigator.pop(context);
  }
}

// void showMessage(
//   String message,
//   Color backgroundColor,
//   Color textColor,
// ) {
//   Fluttertoast.showToast(
//     msg: message,
//     toastLength: Toast.LENGTH_SHORT,
//     gravity: ToastGravity.BOTTOM,
//     timeInSecForIosWeb: 1,
//     backgroundColor: backgroundColor,
//     textColor: textColor,
//     fontSize: 16.0,
//   );
// }
