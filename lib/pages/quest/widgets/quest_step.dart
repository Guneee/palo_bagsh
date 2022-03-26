import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:palo/helpers/api_url.dart';
import 'package:palo/helpers/app_preferences.dart';
import 'package:http/http.dart' as http;
import '../../../constants.dart';
import '../../../data.dart';
import '../../../helpers/components.dart';

import 'dart:convert';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:http_parser/http_parser.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';

class QuestStep extends StatefulWidget {
  final int index;
  final int index2;
  const QuestStep({
    Key? key,
    required this.index,
    required this.index2,
  }) : super(key: key);

  @override
  State<QuestStep> createState() => _QuestStepState();
}

class _QuestStepState extends State<QuestStep> {
  final GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();
  int index = 0, index2 = 0, _currentStep = 0;
  bool _isLoad = false, _commentEmpty = false;
  final ImagePicker _picker = ImagePicker();
  XFile? _photo, _video;
  final _commentTEC = TextEditingController();

  Future<void> _request() async {
    setState(() {
      _isLoad = true;
    });

    Uri apiUrl = Uri.parse(mainApiUrl + "v1/quest-verify-request");
    final imageUploadRequest = http.MultipartRequest('POST', apiUrl);
    imageUploadRequest.headers.addAll({
      "Authorization": "Bearer $token",
      "Content-Type": "multipart/form-data"
    });

    if (_photo != null) {
      final mimeTypeData =
          lookupMimeType(_photo!.path, headerBytes: [0xFF, 0xD8])?.split('/');
      // Attach the file in the request
      final file = await http.MultipartFile.fromPath(
        'ebarimt',
        _photo!.path,
        contentType: MediaType(
          mimeTypeData![0],
          mimeTypeData[1],
        ),
      );
      imageUploadRequest.files.add(file);
    }
    if (_video != null) {
      final mimeTypeData =
          lookupMimeType(_video!.path, headerBytes: [0xFF, 0xD8])?.split("/");
      final file = await http.MultipartFile.fromPath(
        'video',
        _video!.path,
        contentType: MediaType(
          mimeTypeData![0],
          mimeTypeData[1],
        ),
      );
      imageUploadRequest.files.add(file);
    }

    imageUploadRequest.fields['user_id'] = currentUserId.toString();
    imageUploadRequest.fields['quest_id'] =
        questItems[index]["quest"][index2]["id"].toString();
    imageUploadRequest.fields['url'] = appUrl;
    imageUploadRequest.fields['comment'] = _commentTEC.text;

    final streamedResponse = await imageUploadRequest.send();
    final response = await http.Response.fromStream(streamedResponse);
    print(response.body);
    if (response.statusCode == 201) {
      var body = json.decode(response.body);
      if (body["status"]) {
        showSnackBar(body["message"], globalKey);
      } else {
        showSnackBar("Амжилтгүй боллоо", globalKey);
      }
    } else {
      showSnackBar("Алдаа гарлаа, Та дараа дахин оролдоно уу!", globalKey);
    }
    if (mounted) {
      setState(() {
        _isLoad = false;
      });
    }
  }

  void _captureImage() async {
    // Capture a photo
    _photo = await _picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 1280,
      maxWidth: 720,
    );
  }

  void _recordVideo() async {
    // Capture a video
    _video = await _picker.pickVideo(
      source: ImageSource.camera,
      maxDuration: Duration(minutes: 2),
    );
  }

  @override
  void initState() {
    index = widget.index;
    index2 = widget.index2;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: kBackgroundColor,
      key: globalKey,
      appBar: AppBar(
        backgroundColor: (index % 2 == 1) ? kBtnColor : kPrimaryColor,
        centerTitle: true,
        elevation: 0.0,
        title: Ctext(
          text: questItems[index]["quest"][index2]["title"].toString(),
          textOverflow: TextOverflow.ellipsis,
          color: (index % 2 == 1) ? Colors.white : kBtnColor,
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
                        title: Ctext(
                          text: 1.toString() + "-р шат",
                          color: Colors.white,
                        ),
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
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: height * 0.01),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Заавар:\nБарааны баримтын зургыг бүтнээр авах.",
                                  textAlign: TextAlign.justify,
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(height: height * 0.02),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Cbutton(
                                  text: "Зураг авах",
                                  textColor: kBtnColor,
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
                        title: Ctext(
                          text: 2.toString() + "-р шат",
                          color: Colors.white,
                        ),
                        content: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Ctext(
                                text: "Сэтгэгдэл, шүүмжлэл",
                                color: Colors.white,
                                large: true,
                              ),
                            ),
                            TextField(
                              controller: _commentTEC,
                              keyboardType: TextInputType.multiline,
                              maxLength: 256,
                              maxLines: null,
                              style: TextStyle(
                                letterSpacing: 1.5,
                                color: Colors.white,
                              ),
                              decoration: InputDecoration(
                                errorText: _commentEmpty ? "Бөглөнө үү" : null,
                                hintText: "...",
                                hintStyle: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(height: height * 0.01),
                          ],
                        ),
                      ),
                      Step(
                        isActive: _currentStep == 2,
                        title: Ctext(
                          text: 3.toString() + "-р шат",
                          color: Colors.white,
                        ),
                        content: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Ctext(
                                text: "Ашиглаж буй бичлэг",
                                large: true,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: height * 0.01),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Заавар:\nӨөрийн биеээр ашиглаж буй бичлэгээ богино хугацаанд хийх. Хамгийн эхдээ 2-минут",
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(height: height * 0.02),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Cbutton(
                                text: "Бичлэг хийх",
                                textColor: kBtnColor,
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
                        title: Ctext(
                          text: 4.toString() + "-р шат",
                          color: Colors.white,
                        ),
                        content: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Ctext(
                                text: "Хүсэлт илгээх",
                                large: true,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: height * 0.01),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Хүсэлт илгээснээр таны оруулсан мэдээллэлүүдийг бид шалган таньд 1,000 оноо буюу '₮' төгрөгийг шилжүүлэх болно.",
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                  color: Colors.white,
                                ),
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
                                  ? Ctext(
                                      text: "ДАРААЧИЙН",
                                      color: Colors.white,
                                    )
                                  : Text(""),
                            ),
                          if (_currentStep == 3)
                            Cbutton(
                              text: "ИЛГЭЭХ",
                              textColor: kBtnColor,
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
                                  ? Ctext(
                                      text: "БУЦАХ",
                                      color: Colors.white,
                                    )
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
