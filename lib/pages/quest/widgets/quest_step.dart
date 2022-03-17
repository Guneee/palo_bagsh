import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:palo/helpers/app_preferences.dart';

import '../../../constants.dart';
import '../../../data.dart';
import '../../../helpers/components.dart';

class QuestStep extends StatefulWidget {
  final int index;
  const QuestStep({
    Key? key,
    required this.index,
  }) : super(key: key);

  @override
  State<QuestStep> createState() => _QuestStepState();
}

class _QuestStepState extends State<QuestStep> {
  final GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();
  int index = 0, _currentStep = 0;
  bool _isLoad = false, _commentEmpty = false;
  final ImagePicker _picker = ImagePicker();

  final _commentTEC = TextEditingController();

  Future<void> _request() async {
    setState(() {
      _isLoad = true;
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        showSnackBar("Амжиллтай илгээгдлээ", globalKey);
        setState(() {
          _isLoad = false;
        });
      }
    });
  }

  void _captureImage() async {
    // Capture a photo
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
  }

  void _recordVideo() async {
    // Capture a video
    final XFile? video = await _picker.pickVideo(source: ImageSource.camera);
  }

  @override
  void initState() {
    index = widget.index;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: globalKey,
      appBar: AppBar(
        backgroundColor: (index % 2 == 1) ? kBtnColor : kPrimaryColor,
        centerTitle: true,
        elevation: 0.0,
        title: Ctext(
          text: "Нүүрний тос",
          textOverflow: TextOverflow.ellipsis,
          color: Colors.white,
          large: true,
        ),
        leading: IconButton(
          onPressed: () {
            back(context);
          },
          icon: Icon(
            Icons.close,
            color: Colors.white,
          ),
        ),
      ),
      body: SizedBox(
        height: height,
        width: width,
        child: SingleChildScrollView(
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
                children: [
                  SizedBox(height: height * 0.01),
                  Stepper(
                    steps: [
                      Step(
                        isActive: _currentStep == 0,
                        title: Ctext(text: 1.toString() + "-р шат"),
                        content: Padding(
                          padding: EdgeInsets.only(
                            left: width * 0.02,
                            right: width * 0.04,
                          ),
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Ctext(
                                  text: "Е-Баримт зураг",
                                  large: true,
                                ),
                              ),
                              SizedBox(height: height * 0.01),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Заавар:\nБарааны баримтын зургыг бүтнээр авах.",
                                  textAlign: TextAlign.justify,
                                ),
                              ),
                              SizedBox(height: height * 0.02),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Cbutton(
                                  text: "Зураг авах",
                                  normal: true,
                                  onPress: () {
                                    _captureImage();
                                  },
                                  isLoad: false,
                                ),
                              ),
                              SizedBox(height: height * 0.01),
                            ],
                          ),
                        ),
                      ),
                      Step(
                        isActive: _currentStep == 1,
                        title: Ctext(text: 2.toString() + "-р шат"),
                        content: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Ctext(
                                text: "Сэтгэгдэл, шүүмжлэл",
                                large: true,
                              ),
                            ),
                            TextField(
                              controller: _commentTEC,
                              keyboardType: TextInputType.multiline,
                              maxLength: 256,
                              maxLines: null,
                              style: TextStyle(letterSpacing: 1.5),
                              decoration: InputDecoration(
                                errorText: _commentEmpty ? "Бөглөнө үү" : null,
                                hintText: "...",
                              ),
                            ),
                            SizedBox(height: height * 0.01),
                          ],
                        ),
                      ),
                      Step(
                        isActive: _currentStep == 2,
                        title: Ctext(text: 3.toString() + "-р шат"),
                        content: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Ctext(
                                text: "Ашиглаж буй бичлэг",
                                large: true,
                              ),
                            ),
                            SizedBox(height: height * 0.01),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Заавар:\nӨөрийн биеээр ашиглаж буй бичлэгээ богино хугацаанд хийх.",
                                textAlign: TextAlign.justify,
                              ),
                            ),
                            SizedBox(height: height * 0.02),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Cbutton(
                                text: "Бичлэг хийх",
                                normal: true,
                                onPress: () {
                                  _recordVideo();
                                },
                                isLoad: false,
                              ),
                            ),
                            SizedBox(height: height * 0.01),
                          ],
                        ),
                      ),
                      Step(
                        isActive: _currentStep == 3,
                        title: Ctext(text: 4.toString() + "-р шат"),
                        content: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Ctext(
                                text: "Хүсэлт илгээх",
                                large: true,
                              ),
                            ),
                            SizedBox(height: height * 0.01),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Хүсэлт илгээснээр таны оруулсан мэдээллэлүүдийг бид шалган таньд 1,000 оноо буюу '₮' төгрөгийг шилжүүлэх болно.",
                                textAlign: TextAlign.justify,
                              ),
                            ),
                            SizedBox(height: height * 0.01),
                          ],
                        ),
                      ),
                    ],
                    controlsBuilder: (context, index) {
                      return Row(
                        children: <Widget>[
                          if (_currentStep != 3)
                            TextButton(
                              onPressed: () {
                                if (_currentStep != 3) {
                                  if (_currentStep == 0) {
                                    setState(() {
                                      _currentStep += 1;
                                    });
                                  } else if (_currentStep == 1) {
                                    if (_commentTEC.text.isNotEmpty) {
                                      setState(() {
                                        _commentEmpty = false;
                                        _currentStep += 1;
                                      });
                                    } else {
                                      setState(() {
                                        _commentEmpty = true;
                                      });
                                      showSnackBar(
                                        "Сэтгэгдэл оруулна уу",
                                        globalKey,
                                      );
                                    }
                                  } else {
                                    setState(() {
                                      _currentStep += 1;
                                    });
                                  }
                                } else {
                                  print("done");
                                }
                              },
                              child: (_currentStep != 3)
                                  ? Ctext(text: "ДАРААЧИЙН")
                                  : Text(""),
                            ),
                          if (_currentStep == 3)
                            Cbutton(
                              text: "ИЛГЭЭХ",
                              onPress: () {
                                if (!_isLoad) {
                                  _request();
                                }
                              },
                              isLoad: _isLoad,
                            ),
                          if (_currentStep != 0)
                            TextButton(
                              onPressed: () {
                                if (_currentStep != 0) {
                                  setState(() {
                                    _currentStep -= 1;
                                  });
                                }
                              },
                              child: (_currentStep != 0)
                                  ? Ctext(text: "БУЦАХ")
                                  : Text(""),
                            ),
                        ],
                      );
                    },
                    currentStep: _currentStep,
                    onStepTapped: (index) {
                      setState(() {
                        _currentStep = index;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
