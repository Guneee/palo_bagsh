import 'package:flutter/material.dart';
import 'package:palo/pages/quest/widgets/quest_body.dart';

class QuestPage extends StatefulWidget {
  const QuestPage({Key? key}) : super(key: key);

  @override
  State<QuestPage> createState() => _QuestPageState();
}

class _QuestPageState extends State<QuestPage> {
  final GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SizedBox(
        height: height,
        width: width,
        child: SafeArea(
          child: QuestBody(
            globalKey: globalKey,
          ),
        ),
      ),
    );
  }
}
