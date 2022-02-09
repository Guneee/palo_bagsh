import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../constants.dart';

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

void showSnackBar(String value, GlobalKey<ScaffoldState> key) {
  // ignore: deprecated_member_use
  key.currentState!.showSnackBar(
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
