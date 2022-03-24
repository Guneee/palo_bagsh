import 'dart:convert';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:palo/helpers/api_url.dart';
import '../../constants.dart';
import '../../data.dart';
import '../../helpers/app_preferences.dart';

class ProfileEdit extends StatefulWidget {
  const ProfileEdit({Key? key}) : super(key: key);

  @override
  _ProfileEditState createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  final GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();
  final _firstNameTEC = TextEditingController();
  final _ageTEC = TextEditingController();
  final _lastNameTEC = TextEditingController();
  bool _isLoad = false;
  List<Asset> images = <Asset>[];
  List<Asset> images1 = <Asset>[];
  List<Asset> images2 = <Asset>[];
  String _gender = "";
  List gender = ["male", "female", "other"];

  Future<void> _uploadData() async {
    setState(() {
      _isLoad = true;
    });

    Uri apiUrl = Uri.parse(mainApiUrl + "v1/change-profile");
    final imageUploadRequest = http.MultipartRequest('POST', apiUrl);
    imageUploadRequest.headers.addAll({
      "Authorization": "Bearer $token",
      "Content-Type": "multipart/form-data"
    });

    if (images.isNotEmpty) {
      ByteData byteData = await images[0].getByteData();
      Uint8List originalUnit8List = byteData.buffer.asUint8List();
      var codec = await ui.instantiateImageCodec(
        originalUnit8List,
        targetWidth: 800,
      );
      var frameInfo = await codec.getNextFrame();
      ui.Image targetUiImage = frameInfo.image;

      ByteData? targetByteData =
          await targetUiImage.toByteData(format: ui.ImageByteFormat.png);

      Uint8List data = targetByteData!.buffer.asUint8List();
      List<int> imageData = data;

      imageUploadRequest.files.add(
        http.MultipartFile.fromBytes(
          'avatar',
          imageData,
          filename: images[0].name.toString(),
          contentType: MediaType('image', 'jpeg'),
        ),
      );
    }
    if (images1.isNotEmpty) {
      ByteData byteData = await images1[0].getByteData();
      Uint8List originalUnit8List = byteData.buffer.asUint8List();
      var codec = await ui.instantiateImageCodec(
        originalUnit8List,
        targetWidth: 800,
      );
      var frameInfo = await codec.getNextFrame();
      ui.Image targetUiImage = frameInfo.image;

      ByteData? targetByteData =
          await targetUiImage.toByteData(format: ui.ImageByteFormat.png);

      Uint8List data = targetByteData!.buffer.asUint8List();
      List<int> imageData = data;

      imageUploadRequest.files.add(
        http.MultipartFile.fromBytes(
          'id_front',
          imageData,
          filename: images1[0].name.toString(),
          contentType: MediaType('image', 'jpeg'),
        ),
      );
    }
    if (images2.isNotEmpty) {
      ByteData byteData = await images2[0].getByteData();
      Uint8List originalUnit8List = byteData.buffer.asUint8List();
      var codec = await ui.instantiateImageCodec(
        originalUnit8List,
        targetWidth: 800,
      );
      var frameInfo = await codec.getNextFrame();
      ui.Image targetUiImage = frameInfo.image;

      ByteData? targetByteData =
          await targetUiImage.toByteData(format: ui.ImageByteFormat.png);

      Uint8List data = targetByteData!.buffer.asUint8List();
      List<int> imageData = data;

      imageUploadRequest.files.add(
        http.MultipartFile.fromBytes(
          'id_rear',
          imageData,
          filename: images2[0].name.toString(),
          contentType: MediaType('image', 'jpeg'),
        ),
      );
    }

    imageUploadRequest.fields['id'] = currentUserId.toString();
    imageUploadRequest.fields['url'] = appUrl;
    imageUploadRequest.fields['firstname'] = _firstNameTEC.text;
    imageUploadRequest.fields['lastname'] = _lastNameTEC.text;
    imageUploadRequest.fields['age'] = _ageTEC.text;
    imageUploadRequest.fields['gender'] = _gender;

    final streamedResponse = await imageUploadRequest.send();
    final response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode != 201) {
      showSnackBar("Алдаа гарлаа", key);
      if (kDebugMode) {
        print(response.body);
      }
    } else {
      if (kDebugMode) {
        print(response.body);
      }
      final Map<String, dynamic> responseData = json.decode(response.body);
      if (responseData["user_avatar"].toString() != "null") {
        currentUserAvatar = responseData["user_avatar"].toString();
      }
      if (responseData["id_front"].toString() != "null") {
        currentUserIdFront = responseData["id_front"].toString();
      }
      if (responseData["id_rear"].toString() != "null") {
        currentUserIdRear = responseData["id_rear"].toString();
      }
      currentUserFirstName = responseData["firstname"];
      currentUserLastName = responseData["lastname"];
      currentUserAge = responseData["age"];
      currentUserGender = responseData["gender"];
      setState(() {});
      showSnackBar("Амжилттай шинчлэгдлээ", key);
    }

    setState(() {
      _isLoad = false;
    });
  }

  Future<void> _getImage() async {
    images.clear();
    try {
      images = await MultiImagePicker.pickImages(
        maxImages: 1,
        enableCamera: true,
        selectedAssets: images,
        materialOptions: const MaterialOptions(
          actionBarTitle: "Зураг сонгох",
        ),
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    if (images.isNotEmpty) {
      if (kDebugMode) {
        print("selected");
      }
    }
    setState(() {});
  }

  Future<void> _getImage1() async {
    images1.clear();
    try {
      images1 = await MultiImagePicker.pickImages(
        maxImages: 1,
        enableCamera: true,
        selectedAssets: images1,
        materialOptions: const MaterialOptions(
          actionBarTitle: "Зураг сонгох",
        ),
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    if (images1.isNotEmpty) {
      if (kDebugMode) {
        print("selected");
      }
    }
    setState(() {
      currentUserIdFront = "not";
    });
  }

  Future<void> _getImage2() async {
    images2.clear();
    try {
      images2 = await MultiImagePicker.pickImages(
        maxImages: 1,
        enableCamera: true,
        selectedAssets: images2,
        materialOptions: const MaterialOptions(
          actionBarTitle: "Зураг сонгох",
        ),
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    if (images2.isNotEmpty) {
      if (kDebugMode) {
        print("selected");
      }
    }
    setState(() {
      currentUserIdRear = "not";
    });
  }

  @override
  void initState() {
    _firstNameTEC.text = currentUserFirstName;
    _lastNameTEC.text = currentUserLastName;
    _ageTEC.text = currentUserAge;
    if (currentUserGender != "") {
      _gender = currentUserGender;
    }
    print(currentUserAvatar);
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: key,
      backgroundColor: kBackgroundColor,
      body: SizedBox(
        height: height,
        width: width,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                _top(height, width),
                _information(height, width),
                SizedBox(
                  height: height * 0.1,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _information(double height, double width) => AnimationLimiter(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: AnimationConfiguration.toStaggeredList(
            duration: const Duration(milliseconds: 375),
            childAnimationBuilder: (widget) => SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: widget,
              ),
            ),
            children: [
              SizedBox(
                height: height * 0.14,
                width: height * 0.1,
                child: Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        top: height * 0.02,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                          height * 0.5,
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              _getImage();
                            },
                            child: SizedBox(
                              height: height * 0.1,
                              width: height * 0.1,
                              child: (currentUserAvatar.isEmpty)
                                  ? Icon(
                                      Icons.person,
                                      color: Colors.white,
                                      size: height * 0.05,
                                    )
                                  : Image.network(
                                      currentUserAvatar,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: EdgeInsets.only(top: height * 0.02),
                        child: Icon(
                          Icons.edit,
                          color: images.isNotEmpty
                              ? Colors.green
                              : kPrimaryColor.withOpacity(0.8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: height * 0.04,
              ),
              Padding(
                padding: EdgeInsets.only(
                  right: width * 0.1,
                  left: width * 0.1,
                ),
                child: SizedBox(
                  width: width,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _firstNameTEC,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelStyle: const TextStyle(color: Colors.white),
                          labelText: 'Овог',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.1),
                          contentPadding: const EdgeInsets.all(16),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      TextFormField(
                        controller: _lastNameTEC,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelStyle: const TextStyle(color: Colors.white),
                          labelText: 'Нэр',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.1),
                          contentPadding: const EdgeInsets.all(16),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      TextFormField(
                        controller: _ageTEC,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelStyle: const TextStyle(color: Colors.white),
                          labelText: 'Нас',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.1),
                          contentPadding: const EdgeInsets.all(16),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      Row(
                        children: <Widget>[
                          addRadioButton(0, 'Эр'),
                          addRadioButton(1, 'Эм'),
                          addRadioButton(2, 'Бусад'),
                        ],
                      ),
                      SizedBox(height: height * 0.02),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12.0),
                        child: Material(
                          color: Colors.white.withOpacity(0.1),
                          child: InkWell(
                            onTap: () {
                              _getImage1();
                            },
                            child: SizedBox(
                              height: height * 0.06,
                              width: height * 0.8,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Ирэгний үнэмлэхний урдтал  ",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  if (currentUserIdFront != "")
                                    const Icon(Icons.image,
                                        color: Colors.green),
                                  if (currentUserIdFront == "")
                                    const Icon(Icons.image, color: Colors.red),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: height * 0.02),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12.0),
                        child: Material(
                          color: Colors.white.withOpacity(0.1),
                          child: InkWell(
                            onTap: () {
                              _getImage2();
                            },
                            child: SizedBox(
                              height: height * 0.06,
                              width: height * 0.8,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Ирэгний үнэмлэхний ардтал  ",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  if (currentUserIdRear != "")
                                    const Icon(Icons.image,
                                        color: Colors.green),
                                  if (currentUserIdRear == "")
                                    const Icon(Icons.image, color: Colors.red),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.1,
              ),
            ],
          ),
        ),
      );

  void _onChanged(dynamic value) {
    setState(() {
      _gender = value.toString();
      print(_gender);
    });
  }

  Row addRadioButton(int btnValue, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Radio(
          activeColor: Colors.green.withOpacity(0.8),
          value: gender[btnValue],
          groupValue: _gender,
          onChanged: _onChanged,
        ),
        Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }

  Widget _top(double height, double width) => SizedBox(
        height: height * 0.08,
        child: Padding(
          padding: EdgeInsets.only(
            left: width * 0.03,
            right: width * 0.03,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  size: height * 0.03,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              Text(
                "Мэдээлэл засах",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: height * 0.022,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  if (_isLoad)
                    Padding(
                      padding: EdgeInsets.only(right: width * 0.026),
                      child: SizedBox(
                        height: height * 0.03,
                        width: height * 0.03,
                        child: const CircularProgressIndicator(
                          strokeWidth: 1.2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      ),
                    ),
                  if (!_isLoad)
                    IconButton(
                      icon: const Icon(
                        Icons.upload_outlined,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        if (_gender.isNotEmpty && _ageTEC.text.isNotEmpty) {
                          _uploadData();
                        } else {
                          showSnackBar("Бүх хэсэгийг бөглөнө үү", key);
                        }
                      },
                    ),
                ],
              ),
            ],
          ),
        ),
      );
}
