import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:palo/helpers/components.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '/data.dart';
import 'package:http/http.dart' as https;
import '/helpers/api_url.dart';

import '../../constants.dart';

class SurveyForm extends StatefulWidget {
  final int index;
  final String url;
  final String money;
  final String title;
  const SurveyForm({
    Key? key,
    required this.url,
    required this.money,
    required this.index,
    required this.title,
  }) : super(key: key);

  @override
  _SurveyFormState createState() => _SurveyFormState();
}

class _SurveyFormState extends State<SurveyForm> {
  final ConfettiController _controllerTopCenter =
      ConfettiController(duration: const Duration(seconds: 10));
  int _progress = 0;
  int _timeOut = 3;
  bool _isWin = false, _isLoad = false;

  void _sendMoney() async {
    setState(() {
      _isLoad = true;
    });
    final responce =
        await https.post(Uri.parse(mainApiUrl + "v1/send-money"), headers: {
      "Authorization": "Bearer $token",
    }, body: {
      'id': currentUserId.toString(),
      'money': widget.money.toString(),
      'survey_id': surveys[widget.index]['id'].toString(),
      'title': surveys[widget.index]['title'].toString(),
      'category_id': surveys[widget.index]['category_id'].toString(),
      'category_text': surveys[widget.index]['category_text'].toString(),
      'category_image': surveys[widget.index]['category_image'].toString(),
      'image': surveys[widget.index]['image'],
      'price': surveys[widget.index]['price'],
      'content': surveys[widget.index]['content'],
      'survey_created_at': surveys[widget.index]['created_at'],
      'location': surveys[widget.index]['location'] ?? "",
    });

    if (responce.statusCode == 201) {
      currentUserMoney =
          (int.parse(currentUserMoney) + int.parse(widget.money)).toString();
      history.add(json.decode(responce.body)['history']);
    }
    if (mounted) {
      startTimer();
      _controllerTopCenter.play();
      if (kDebugMode) {
        print("win");
      }
      setState(() {
        _isWin = true;
        _isLoad = false;
      });
    }
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);

    Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_timeOut == 0) {
          setState(() {
            if (mounted) {
              timer.cancel();
              _controllerTopCenter.stop();
              Navigator.pop(context);
              Navigator.pop(context);
            }
          });
        } else {
          if (mounted) {
            setState(() {
              _timeOut--;
            });
          }
        }
      },
    );
  }

  @override
  void dispose() {
    _controllerTopCenter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: kPrimaryColor,
        leading: IconButton(
          onPressed: () {
            answerUrl = "";
            back(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Ctext(
          text: widget.title,
          large: true,
          color: Colors.white,
        ),
      ),
      body: SizedBox(
        height: height,
        width: width,
        child: SafeArea(
          child: Column(
            children: <Widget>[
              if (widget.url.isNotEmpty)
                Expanded(
                  child: _body(height, width),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _body(double height, double width) => Column(
        children: [
          if (_progress < 100)
            LinearProgressIndicator(
              value: (_progress / 100).toDouble(),
              valueColor: const AlwaysStoppedAnimation<Color>(kPrimaryColor),
              backgroundColor: Colors.grey,
            )
          else
            Container(),
          if (_isWin)
            if (!_isLoad)
              Expanded(
                child: Stack(
                  children: [
                    SizedBox(
                      height: height,
                      width: width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/win.png",
                            height: height * 0.06,
                            width: height * 0.06,
                          ),
                          SizedBox(height: height * 0.03),
                          const Ctext(
                            text: "Таньд баяр хүргэе!",
                            large: true,
                            color: kTextColor,
                            bold: true,
                          ),
                          SizedBox(height: height * 0.03),
                          Ctext(
                            text: "Та судалгаа бөгөлж " +
                                widget.money +
                                "₮" +
                                " авлаа.",
                            large: true,
                            color: kTextColor.withOpacity(0.7),
                          ),
                          Text(
                            "Автоматаар гарахад " + _timeOut.toString() + "..",
                            style: TextStyle(
                              color: Colors.black.withOpacity(0.5),
                              fontSize: height * 0.016,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: ConfettiWidget(
                        confettiController: _controllerTopCenter,
                        blastDirection: pi / 2,
                        maxBlastForce: 5, // set a lower max blast force
                        minBlastForce: 2, // set a lower min blast force
                        emissionFrequency: 0.05,
                        numberOfParticles: 50, // a lot of particles at once
                        gravity: 1,
                      ),
                    ),
                  ],
                ),
              ),
          if (_isLoad)
            Expanded(
              child: Center(
                child: SizedBox(
                  height: height * 0.05,
                  width: height * 0.05,
                  child: const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
                    strokeWidth: 1.5,
                  ),
                ),
              ),
            ),
          if (!_isWin)
            if (!_isLoad)
              Expanded(
                child: WebView(
                  initialUrl: widget.url,
                  javascriptMode: JavascriptMode.unrestricted,
                  onProgress: (progress) {
                    setState(() {
                      _progress = progress;
                    });
                  },
                  onPageStarted: (url) {
                    setState(() {});
                  },
                  onPageFinished: (url) {
                    if (url.contains("formResponse")) {
                      _sendMoney();
                    } else {
                      if (kDebugMode) {
                        print("loss");
                      }
                    }
                  },
                ),
              ),
        ],
      );
}
