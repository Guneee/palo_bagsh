import 'package:flutter/material.dart';
import 'package:palo/helpers/components.dart';

import '../../../helpers/app_preferences.dart';

class ProfileEditTop extends StatelessWidget {
  const ProfileEditTop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = size(context).height;
    double width = size(context).width;
    return Container(
      child: IconButton(
        onPressed: () {
          back(context);
        },
        icon: Icon(
          Icons.arrow_back,
          color: Colors.black.withOpacity(0.7),
        ),
      ),
    );
  }
}
