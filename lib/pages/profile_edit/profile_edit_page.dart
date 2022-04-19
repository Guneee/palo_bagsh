import 'package:flutter/material.dart';
import 'package:palo/constants.dart';
import 'package:palo/helpers/app_preferences.dart';

import 'widgets/profile_edit_top.dart';

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({Key? key}) : super(key: key);

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  @override
  Widget build(BuildContext context) {
    double height = size(context).height;
    double width = size(context).width;
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SizedBox(
        height: height,
        width: width,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const ProfileEditTop(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
