import 'package:flutter/material.dart';

class HomeModel with ChangeNotifier {
  String id;
  String title;
  String image;
  List surveys;
  String createdAt;

  HomeModel({
    required this.id,
    required this.title,
    required this.image,
    required this.surveys,
    required this.createdAt,
  });
}
