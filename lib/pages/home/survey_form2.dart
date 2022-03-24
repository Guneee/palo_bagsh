import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '/data.dart';
import 'package:http/http.dart' as https;
import '/helpers/api_url.dart';

import '../../constants.dart';

class SurveyForm2 extends StatefulWidget {
  final int index;
  final String url;
  final String money;
  final String title;
  const SurveyForm2({
    Key? key,
    required this.url,
    required this.money,
    required this.index,
    required this.title,
  }) : super(key: key);

  @override
  _SurveyForm2State createState() => _SurveyForm2State();
}

class _SurveyForm2State extends State<SurveyForm2> {
  int _progress = 0;
  int _timeOut = 3;

  final ConfettiController _controllerTopCenter =
      ConfettiController(duration: const Duration(seconds: 10));
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
      'survey_id': nearSurveys[widget.index]['id'].toString(),
      'title': nearSurveys[widget.index]['title'].toString(),
      'category_id': nearSurveys[widget.index]['category_id'].toString(),
      'category_text': nearSurveys[widget.index]['category_text'].toString(),
      'category_image': nearSurveys[widget.index]['category_image'].toString(),
      'image': nearSurveys[widget.index]['image'],
      'price': nearSurveys[widget.index]['price'],
      'content': nearSurveys[widget.index]['content'],
      'survey_created_at': nearSurveys[widget.index]['created_at'],
      'location': nearSurveys[widget.index]['location'] ?? "",
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
            timer.cancel();
            _controllerTopCenter.stop();
            Navigator.pop(context);
            Navigator.pop(context);
          });
        } else {
          setState(() {
            _timeOut--;
          });
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
      body: SizedBox(
        height: height,
        width: width,
        child: SafeArea(
          child: Column(
            children: <Widget>[
              _top(height, width),
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
                          Text(
                            "Таньд баярлалаа",
                            style: TextStyle(
                              color: kPrimaryColor,
                              fontSize: height * 0.022,
                            ),
                          ),
                          SizedBox(height: height * 0.004),
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

  Widget _top(double height, double width) => SizedBox(
        height: height * 0.07,
        child: Padding(
          padding: EdgeInsets.only(
            left: width * 0.03,
            right: width * 0.03,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
              ),
              Text(
                widget.title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: height * 0.02,
                  fontWeight: FontWeight.w500,
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.done_outline,
                  color: Colors.transparent,
                ),
                onPressed: () {},
              ),
            ],
          ),
        ),
      );
}
