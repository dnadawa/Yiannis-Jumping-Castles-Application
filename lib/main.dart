import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yiannis_jumping_castles/screens/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xffCF1B1B),
        accentColor: Color(0xffFF414D),
        scaffoldBackgroundColor: Color(0xffFF847C),
        textTheme: GoogleFonts.ubuntuTextTheme(
          Theme.of(context).textTheme
        )
      ),
      home: Home(),
    );
  }
}

