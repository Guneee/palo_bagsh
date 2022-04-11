import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:palo/constants.dart';
import 'package:palo/data.dart';
import 'package:palo/helpers/api_url.dart';
import 'package:palo/helpers/app_preferences.dart';
import 'package:palo/helpers/components.dart';
import 'package:http/http.dart' as https;
import 'package:palo/pages/home/home_page.dart';

class ContractPage extends StatefulWidget {
  const ContractPage({Key? key}) : super(key: key);

  @override
  State<ContractPage> createState() => _ContractPageState();
}

class _ContractPageState extends State<ContractPage> {
  final GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();
  bool _firstIsLoad = false, _isLoad = false, _isAccept = false;
  var body;

  void _next() {
    if (_isAccept) {
      setState(() {
        _isLoad = true;
      });
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          _isLoad = false;
        });
        Future.delayed(
          const Duration(milliseconds: 100),
          () {
            goAndClear(context, const HomePage());
          },
        );
      });
    } else {
      showSnackBar("Та гэрээг зөвшөөрнө үү", globalKey);
    }
  }

  Future<void> _loadContractData() async {
    setState(() {
      _firstIsLoad = true;
    });

    final response = await https.get(Uri.parse(mainApiUrl + "v1/get-contract"));
    if (response.statusCode == 201) {
      var body = json.decode(response.body);
    } else {
      showSnackBar("Сервер түр салсан байна", globalKey);
    }

    if (mounted) {
      setState(() {
        _firstIsLoad = false;
      });
    }
  }

  @override
  void initState() {
    _loadContractData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = size(context).height;
    double width = size(context).width;
    return Scaffold(
      key: globalKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.white,
        title: Ctext(
          text: "Гэрээний нөхцөл",
          large: true,
          bold: true,
          color: Colors.black,
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            back(context);
          },
        ),
      ),
      body: SafeArea(
        child: SizedBox(
          height: height,
          width: width,
          child: SingleChildScrollView(
            child: Column(
              children: [
                if (_firstIsLoad)
                  Padding(
                    padding: EdgeInsets.only(top: height * 0.04),
                    child: SizedBox(
                      height: height * 0.04,
                      width: height * 0.04,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2.0,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          kPrimaryColor,
                        ),
                      ),
                    ),
                  ),
                if (!_firstIsLoad) _body(height, width),
                SizedBox(height: height * 0.06)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _body(double height, double width) => Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: height * 0.02,
              left: width * 0.04,
              right: width * 0.04,
              bottom: height * 0.02,
            ),
            child: Html(
              data: body ?? """Та манайхтай холбоо барина уу""",
            ),
          ),
          Row(
            children: [
              SizedBox(width: width * 0.02),
              Checkbox(
                value: _isAccept,
                activeColor: kPrimaryColor,
                onChanged: (value) {
                  setState(() {
                    _isAccept = value!;
                  });
                },
              ),
              Text(
                "Гэрээний нөхцөлийг хүлээн зөвшөөрч байна.",
                style: TextStyle(fontSize: height * 0.018),
              ),
            ],
          ),
          SizedBox(height: height * 0.01),
          ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: Material(
              color: kPrimaryColor,
              child: InkWell(
                onTap: () {
                  if (!_isLoad) {
                    _next();
                  }
                },
                child: AnimatedSize(
                  curve: Curves.fastOutSlowIn,
                  duration: const Duration(milliseconds: 375),
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: height * 0.014,
                      bottom: height * 0.014,
                      left: _isLoad ? width * 0.04 : width * 0.25,
                      right: _isLoad ? width * 0.04 : width * 0.25,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (_isLoad)
                          SizedBox(
                            height: height * 0.03,
                            width: height * 0.03,
                            child: const CircularProgressIndicator(
                              strokeWidth: 1.2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          ),
                        if (!_isLoad)
                          Ctext(
                            color: Colors.white,
                            text: "Үргэлжлүүлэх",
                            large: true,
                            bold: true,
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
}
