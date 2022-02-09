import 'package:flutter/material.dart';

class CategoryModel with ChangeNotifier {
  String id;
  String name;
  String image;

  CategoryModel({
    required this.id,
    required this.name,
    required this.image,
  });
}
