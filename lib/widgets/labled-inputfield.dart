import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LabeledInputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final TextInputType type;
  final bool isPassword;

  const LabeledInputField({Key key, this.controller, this.hint, this.type, this.isPassword=false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        cursorColor: Colors.black,
        style: GoogleFonts.comicNeue(
          textStyle: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold
          )
        ),
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).accentColor,width: 3),borderRadius: BorderRadius.circular(10)),
          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).accentColor,width: 3),borderRadius: BorderRadius.circular(10)),
          labelText: hint,
          labelStyle: GoogleFonts.comicNeue(
              textStyle: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.normal
              )
          )
        ),
        keyboardType: type,
      ),
    );
  }
}
