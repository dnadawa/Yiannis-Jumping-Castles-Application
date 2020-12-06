import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:yiannis_jumping_castles/screens/admin/admin-login.dart';
import 'package:yiannis_jumping_castles/screens/details.dart';
import 'package:yiannis_jumping_castles/widgets/button.dart';
import 'package:yiannis_jumping_castles/widgets/custom-text.dart';
import 'package:yiannis_jumping_castles/widgets/labled-inputfield.dart';
import 'package:yiannis_jumping_castles/widgets/marquee.dart';
import 'package:yiannis_jumping_castles/widgets/toast.dart';

class AdminHome extends StatefulWidget {
  @override
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {

  File image;
  IconData icon = Icons.cloud_upload;
  TextEditingController name = TextEditingController();
  TextEditingController description = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,designSize: Size(720, 1520), allowFontScaling: false);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: CustomText(text: 'Home',),
      ),
      body: Padding(
        padding: EdgeInsets.all(ScreenUtil().setHeight(25)),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding:  EdgeInsets.all(ScreenUtil().setWidth(35)),
              child: Column(
                children: [
                  CustomText(text: 'Upload image',color: Colors.black,size: ScreenUtil().setSp(35),),
                  SizedBox(height: ScreenUtil().setHeight(30),),
                  GestureDetector(
                      onTap: () async {
                        image = await ImagePicker.pickImage(source: ImageSource.gallery,imageQuality: 50);
                        setState(() {
                          icon = Icons.check;
                        });
                      },
                      child: CircleAvatar(backgroundColor: Colors.black,child: Icon(icon,color: Colors.white,),radius: 40,)
                  ),
                  SizedBox(height: ScreenUtil().setHeight(60),),
                  LabeledInputField(hint: 'Item Name',controller: name,),
                  SizedBox(height: ScreenUtil().setHeight(30),),
                  TextFormField(
                    controller: description,
                    maxLines: null,
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
                        labelText: 'Type your item instructions',
                        labelStyle: GoogleFonts.comicNeue(
                            textStyle: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.normal
                            )
                        )
                    ),
                  ),
                  SizedBox(height: ScreenUtil().setHeight(50),),
                  Padding(
                    padding:  EdgeInsets.all(ScreenUtil().setWidth(35)),
                    child: Button(
                      text: 'Submit',
                      color: Theme.of(context).accentColor,
                      onclick: () async {
                        ToastBar(text: 'Please wait...',color: Colors.orange).show();
                        try{
                          String imageName = basename(image.path);
                          Reference ref = FirebaseStorage.instance.ref().child("$imageName");
                          await ref.putFile(image);
                          String downloadURL = await ref.getDownloadURL();
                          print(downloadURL);

                          await FirebaseFirestore.instance.collection('data').add({
                            'description': description.text,
                            'image': downloadURL,
                            'name': name.text,
                            'booked': []
                          });

                          setState(() {
                            name.clear();
                            description.clear();
                            image = null;
                            icon = Icons.cloud_upload;
                          });

                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                backgroundColor: Colors.white,
                                content: Container(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Image.asset('images/check.gif'),
                                      CustomText(text: 'The item successfully added!', color: Colors.black,size: ScreenUtil().setSp(45),),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                          Timer(Duration(seconds: 4), (){
                            Navigator.pop(context);
                          });
                        }
                        catch(e){
                          ToastBar(text: 'Something went wrong!',color: Colors.red).show();
                        }
                      },
                    ),
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
