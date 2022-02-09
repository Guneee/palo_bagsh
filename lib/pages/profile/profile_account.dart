import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:palo/helpers/api_url.dart';
import 'package:http/http.dart' as https;
import 'package:palo/helpers/app_preferences.dart';
import '../../constants.dart';
import '../../data.dart';

class ProfileAccount extends StatefulWidget {
  const ProfileAccount({Key? key}) : super(key: key);

  @override
  _ProfileAccountState createState() => _ProfileAccountState();
}

class _ProfileAccountState extends State<ProfileAccount> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _bankTEC = TextEditingController();
  final _accountTEC = TextEditingController();
  final _accountNameTEC = TextEditingController();
  bool _isLoad = false;

  Future<void> _uploadAccount() async {
    setState(() {
      _isLoad = true;
    });
    final response = await https
        .post(Uri.parse(mainApiUrl + "v1/change-bank-information"), headers: {
      "Authorization": "Bearer $token",
    }, body: {
      'id': currentUserId.toString(),
      "bank_name": _bankTEC.text.toString(),
      "bank_account": _accountTEC.text.toString(),
      "bank_account_name": _accountNameTEC.text.toString(),
    });
    if (response.statusCode != 201) {
      showSnackBar("Алдаа гарлаа", _scaffoldKey);
    } else {
      currentUserBank = json.decode(response.body)["bank_name"].toString();
      currentUserAccount =
          json.decode(response.body)["bank_account"].toString();
      currentUserAccountName =
          json.decode(response.body)["bank_account_name"].toString();
    }

    setState(() {
      _isLoad = false;
    });
  }

  @override
  void initState() {
    if (currentUserBank != "null" &&
        currentUserAccount != "null" &&
        currentUserAccountName != "null") {
      _bankTEC.text = currentUserBank;
      _accountTEC.text = currentUserAccount;
      _accountNameTEC.text = currentUserAccountName;
    }
    if (kDebugMode) {
      print(currentUserAccountName);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: kBtnColor,
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

  Widget _information(double height, double width) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
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
                    controller: _bankTEC,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelStyle: const TextStyle(color: Colors.white),
                      labelText: 'Банкны нэр',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),
                      filled: true,
                      fillColor: kPrimaryColor,
                      contentPadding: const EdgeInsets.all(16),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  TextFormField(
                    controller: _accountNameTEC,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelStyle: const TextStyle(color: Colors.white),
                      labelText: 'Данс эзэмшигчийн нэр',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),
                      filled: true,
                      fillColor: kPrimaryColor,
                      contentPadding: const EdgeInsets.all(16),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  TextFormField(
                    controller: _accountTEC,
                    style: const TextStyle(color: Colors.white),
                    keyboardType: TextInputType.phone,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      labelStyle: const TextStyle(color: Colors.white),
                      labelText: 'Дансны дугаар',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),
                      filled: true,
                      fillColor: kPrimaryColor,
                      contentPadding: const EdgeInsets.all(16),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: height * 0.1,
          ),
        ],
      );

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
                "Таталт хүлээн авах данс",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: height * 0.021,
                  fontWeight: FontWeight.w400,
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
                            Colors.green,
                          ),
                        ),
                      ),
                    ),
                  if (!_isLoad)
                    IconButton(
                      icon: const Icon(
                        Icons.done,
                        color: Colors.green,
                      ),
                      onPressed: () {
                        _uploadAccount();
                      },
                    ),
                ],
              ),
            ],
          ),
        ),
      );
}
