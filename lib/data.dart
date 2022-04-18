import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'models/category_model.dart';
import 'models/home_model.dart';
import 'pages/home/home_page.dart';

bool isFirstHomeAdWord = false;

String token = "";
var user;
String currentUserFirstName = "";
String currentUserLastName = "";
String currentUserEmail = "";
String currentUserAvatar = "";
String currentUserPhone = "";
String currentUserId = "";
String currentUserMoney = "0";
String currentUserWallet = "";
String currentUserBank = "";
String currentUserAccount = "";
String currentUserAccountName = "";
String currentUserAge = "";
String currentUserGender = "";
String currentUserIdFront = "";
String currentUserIdRear = "";
String answerUrl = "";
int scoreLength = 0;
int currentBottomIndex = 0;
int currentBottomIndex2 = 0;
int currentBottomIndex3 = 0;
bool isFirstHome = false;
bool isJobPageFirstTime = false;
bool isVerify = false;

//https://docs.google.com/forms/d/e/1FAIpQLSfhYUnWqT45xrBJ2WTv5VCsJQqe2vy8maqy46IKufmOe0PkGg/viewform?usp=sf_link

List<Marker> jobMarkers = [];
List<Marker> jobMarkers2 = [];
List<Marker> jobMarkers3 = [];
List<Marker> questMarkers = [];
List jobs = [];
List jobs2 = [];
List jobs3 = [];
List<HomeModel> homeItems = [];
List<CategoryModel> categoryItems = [];
List history = [];
List surveys = [];
List banners = [];
List nearSurveys = [];
List userPullRequestItems = [];
List quests = [];
List questCategories = [];
List questItems = [];
List categories = [];
var jobData;
bool? isProduct;

//android:name="${applicationName}"
bool clearUserData() {
  currentBottomIndex = 0;
  token = "";
  currentUserFirstName = "";
  currentUserLastName = "";
  currentUserEmail = "";
  currentUserAvatar = "";
  currentUserPhone = "";
  currentUserAge = "";
  currentUserGender = "";
  currentUserIdFront = "";
  currentUserIdRear = "";
  currentUserId = "";
  currentUserMoney = "0";
  currentUserWallet = "";
  return true;
}

void goHome(BuildContext context) {
  Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const HomePage()),
      (Route<dynamic> route) => false);
}
