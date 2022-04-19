import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:palo/helpers/app_preferences.dart';
import 'package:palo/pages/profile/widgets/profile_top.dart';

import 'widgets/profile_account_container.dart';
import 'widgets/profile_account_settings.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();
  final CurrencyTextInputFormatter _formatter = CurrencyTextInputFormatter(
    locale: "mn",
    decimalDigits: 0,
    symbol: "₮",
  );

  @override
  Widget build(BuildContext context) {
    double height = size(context).height;
    double width = size(context).width;
    return Scaffold(
      key: globalKey,
      body: SizedBox(
        height: height,
        width: width,
        child: SafeArea(
          child: AnimationLimiter(
            child: SingleChildScrollView(
              child: Column(
                children: AnimationConfiguration.toStaggeredList(
                  duration: const Duration(milliseconds: 375),
                  childAnimationBuilder: (widget) => SlideAnimation(
                    verticalOffset: 50.0,
                    child: FadeInAnimation(
                      child: widget,
                    ),
                  ),
                  children: [
                    const ProfileTop(),
                    ProfileAccountContainer(formatter: _formatter),
                    const ProfileAccountSettings(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
