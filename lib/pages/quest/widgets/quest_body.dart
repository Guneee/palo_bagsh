import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:http/http.dart' as https;
import 'package:palo/data.dart';
import 'package:palo/helpers/api_url.dart';
import 'package:palo/pages/quest/widgets/quest_box.dart';

class QuestBody extends StatefulWidget {
  final GlobalKey<ScaffoldState> globalKey;
  const QuestBody({
    Key? key,
    required this.globalKey,
  }) : super(key: key);

  @override
  State<QuestBody> createState() => _QuestBodyState();
}

class _QuestBodyState extends State<QuestBody> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: AnimationLimiter(
        child: Column(
          children: AnimationConfiguration.toStaggeredList(
            duration: const Duration(milliseconds: 375),
            childAnimationBuilder: (widget) => SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: widget,
              ),
            ),
            children: List.generate(
              quests.length,
              (index) => QuestBox(
                index: index,
                length: quests.length,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
