import 'package:flutter/material.dart';

class SurveyModel with ChangeNotifier {
  String id;
  String title;
  String image;
  String content;
  String price;
  String scoreLength;
  String formLink;
  String createdAt;

  SurveyModel({
    required this.id,
    required this.title,
    required this.image,
    required this.content,
    required this.price,
    required this.scoreLength,
    required this.formLink,
    required this.createdAt,
  });
}
