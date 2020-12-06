import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {

  final String text;
  final double size;
  final Color color;
  final TextAlign align;
  final bool isBold;
  final String font;
  final double height;
  const CustomText({Key key, this.text, this.size, this.color=Colors.white, this.align=TextAlign.center, this.isBold=true, this.font, this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: align,
      //overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: color,
        fontFamily: font,
        fontWeight: isBold?FontWeight.bold:FontWeight.normal,
        fontSize: size,
        height: height
      ),
    );
  }
}