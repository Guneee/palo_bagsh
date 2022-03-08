import '/constants.dart';
import 'package:flutter/material.dart';

back(BuildContext context) {
  Navigator.pop(context);
}

class Cbutton extends StatelessWidget {
  final String text;
  final bool? normal;
  final bool? small;
  final bool? large;
  final bool? extraLarge;
  final bool? extraLarge2;
  final bool? extraLarge3;
  final bool? bold;
  final bool isLoad;
  final Color? color;
  final Color? textColor;
  final VoidCallback onPress;
  const Cbutton({
    Key? key,
    required this.text,
    this.normal,
    this.small,
    this.large,
    this.extraLarge,
    this.extraLarge2,
    this.extraLarge3,
    this.bold,
    this.color,
    this.textColor,
    required this.onPress,
    required this.isLoad,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return ClipRRect(
      borderRadius: BorderRadius.circular(6.0),
      child: Material(
        color: (color != null) ? color : kPrimaryColor,
        child: InkWell(
          onTap: (onPress != null) ? onPress : () {},
          child: AnimatedSize(
            curve: Curves.fastOutSlowIn,
            duration: const Duration(milliseconds: 375),
            child: Padding(
              padding: EdgeInsets.only(
                top: height * 0.01,
                bottom: height * 0.01,
                left: width * 0.04,
                right: width * 0.04,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isLoad)
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
                  if (!isLoad)
                    Ctext(
                      text: (text != null) ? text : "Button",
                      large: (large != null) ? large : null,
                      normal: (normal != null) ? normal : null,
                      small: (small != null) ? small : null,
                      extraLarge: (extraLarge != null) ? extraLarge : null,
                      extraLarge2: (extraLarge2 != null) ? extraLarge2 : null,
                      extraLarge3: (extraLarge3 != null) ? extraLarge3 : null,
                      bold: (bold != null) ? bold : null,
                      color: (textColor != null) ? textColor : Colors.white,
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

class Ctext extends StatelessWidget {
  final String? text;
  final bool? normal;
  final bool? small;
  final bool? extraSmall;
  final bool? large;
  final bool? extraLarge;
  final bool? extraLarge2;
  final bool? extraLarge3;
  final bool? bold;
  final Color? color;
  final TextOverflow? textOverflow;
  final int? maxLine;
  const Ctext({
    Key? key,
    this.text,
    this.normal,
    this.small,
    this.large,
    this.bold,
    this.color,
    this.textOverflow,
    this.maxLine,
    this.extraLarge,
    this.extraLarge2,
    this.extraLarge3,
    this.extraSmall,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text!,
      overflow: (textOverflow != null) ? textOverflow : TextOverflow.clip,
      maxLines: (maxLine != null) ? maxLine : 1,
      style: TextStyle(
        fontSize: (normal != null)
            ? MediaQuery.of(context).size.height * 0.02
            : (large != null)
                ? MediaQuery.of(context).size.height * 0.022
                : (small != null)
                    ? MediaQuery.of(context).size.height * 0.018
                    : (extraLarge != null)
                        ? MediaQuery.of(context).size.height * 0.024
                        : (extraLarge2 != null)
                            ? MediaQuery.of(context).size.height * 0.026
                            : (extraLarge3 != null)
                                ? MediaQuery.of(context).size.height * 0.028
                                : (extraSmall != null)
                                    ? MediaQuery.of(context).size.height * 0.016
                                    : 12.0,
        fontWeight: (bold != null) ? FontWeight.bold : FontWeight.normal,
        color: (color != null) ? color : Colors.black,
      ),
    );
  }
}
