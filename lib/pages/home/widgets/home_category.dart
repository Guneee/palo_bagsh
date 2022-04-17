import 'package:flutter/material.dart';
import 'package:palo/constants.dart';
import 'package:palo/data.dart';
import 'package:palo/pages/home/category_items.dart';

import '../../../helpers/app_preferences.dart';
import '../../../helpers/components.dart';

class HomeCategory extends StatelessWidget {
  const HomeCategory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = size(context).height;
    double width = size(context).width;
    return Padding(
      padding: EdgeInsets.only(top: height * 0.025),
      child: Container(
        height: height * 0.065,
        width: width,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          itemBuilder: (context, index) => Padding(
            padding: EdgeInsets.only(
              left: index == 0 ? width * 0.06 : width * 0.02,
              right: width * 0.02,
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(
                  width: 0.5,
                  color: Colors.grey.withOpacity(0.2),
                ),
                boxShadow: [
                  BoxShadow(
                    spreadRadius: 2.0,
                    blurRadius: 5.0,
                    color: kShadowColor.withOpacity(0.08),
                    offset: Offset(0.0, 3.0),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Material(
                  color: Colors.white,
                  child: InkWell(
                    onTap: () {
                      go(
                        context,
                        CategoryItems(index: index),
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: width * 0.04,
                        right: width * 0.04,
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(50.0),
                              child: Image.network(
                                categories[index]["image"],
                                height: height * 0.045,
                                width: height * 0.045,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: width * 0.02),
                            Ctext(
                              text: categories[index]["title"],
                              large: true,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
