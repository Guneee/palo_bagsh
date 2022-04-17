import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:palo/constants.dart';
import 'package:palo/pages/home/functions/home_page_content_function.dart';
import 'package:palo/pages/home/widgets/home_category.dart';
import 'package:palo/pages/home/widgets/home_survey.dart';
import 'package:palo/pages/home/widgets/home_top.dart';
import '../../helpers/app_preferences.dart';
import '../home/functions/home_page_content_function.dart';
import '../../data.dart';
import 'widgets/home_near_survey.dart';

class HomePageContent extends StatefulWidget {
  const HomePageContent({Key? key}) : super(key: key);

  @override
  State<HomePageContent> createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent> {
  final GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();
  bool _isLoad = false;

  @override
  Widget build(BuildContext context) {
    double height = size(context).height;
    double width = size(context).width;
    return Scaffold(
      key: globalKey,
      extendBody: true,
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: SizedBox(
          height: height,
          width: width,
          child: Column(
            children: [
              if (_isLoad)
                Padding(
                  padding: EdgeInsets.only(top: height * 0.4),
                  child: SizedBox(
                    height: height * 0.05,
                    width: height * 0.05,
                    child: const CircularProgressIndicator(
                      strokeWidth: 1.5,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        kPrimaryColor,
                      ),
                    ),
                  ),
                ),
              if (!_isLoad)
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _loadData,
                    backgroundColor: Colors.white,
                    color: kPrimaryColor,
                    strokeWidth: 1.5,
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
                              const HomeTop(),
                              HomeCategory(),
                              if (nearSurveys.isNotEmpty) HomeNearSurvey(),
                              HomeSurvey(),
                              SizedBox(height: height * 0.04),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoad = true;
    });
    await refreshData();
    await getCurrentLocation();
    if (mounted) {
      setState(() {
        _isLoad = false;
      });
    }
  }

  @override
  void initState() {
    if (token != "" && !isFirstHome) {
      _loadData();
    }
    super.initState();
  }
}
