import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/rounded_picker.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:yiannis_jumping_castles/widgets/button.dart';
import 'package:yiannis_jumping_castles/widgets/custom-text.dart';
import 'package:yiannis_jumping_castles/widgets/labled-inputfield.dart';
import 'package:yiannis_jumping_castles/widgets/toast.dart';

import 'home.dart';

class CustomerDetails extends StatefulWidget {
  final String id;
  final String title;
  final List unselectableDates;

  const CustomerDetails({Key key, this.id, this.title, this.unselectableDates}) : super(key: key);


  @override
  _CustomerDetailsState createState() => _CustomerDetailsState();
}

class _CustomerDetailsState extends State<CustomerDetails> {
  TextEditingController name = TextEditingController();
  TextEditingController ad1 = TextEditingController();
  TextEditingController ad2 = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController zip = TextEditingController();
  TextEditingController phone = TextEditingController();
  String date = 'Select a date';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(ScreenUtil().setHeight(30)),
          child: Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.all(ScreenUtil().setHeight(35)),
                child: Column(
                  children: [
                    CustomText(text: 'Enter your details',color: Colors.black,size: ScreenUtil().setSp(40),),
                    SizedBox(height: ScreenUtil().setHeight(40),),
                    Container(
                      width: ScreenUtil().setWidth(350),
                      height: ScreenUtil().setWidth(350),
                      child: Image.asset('images/details.jpg'),
                    ),
                    SizedBox(height: ScreenUtil().setHeight(40),),
                    LabeledInputField(hint: 'Name',controller: name,),
                    SizedBox(height: ScreenUtil().setHeight(30),),
                    LabeledInputField(hint: 'Address Line 1',controller: ad1,type: TextInputType.streetAddress,),
                    SizedBox(height: ScreenUtil().setHeight(30),),
                    LabeledInputField(hint: 'Address Line 2',controller: ad2,type: TextInputType.streetAddress,),
                    SizedBox(height: ScreenUtil().setHeight(30),),
                    LabeledInputField(hint: 'City',controller: city,),
                    SizedBox(height: ScreenUtil().setHeight(30),),
                    LabeledInputField(hint: 'State',controller: state,),
                    SizedBox(height: ScreenUtil().setHeight(30),),
                    LabeledInputField(hint: 'Postal Code',controller: zip,),
                    SizedBox(height: ScreenUtil().setHeight(30),),
                    LabeledInputField(hint: 'Phone Number',controller: phone,type: TextInputType.phone,),
                    SizedBox(height: ScreenUtil().setHeight(30),),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(width: 3,color: Theme.of(context).accentColor)
                      ),
                      child: ListTile(
                        title: Text(date,style: GoogleFonts.comicNeue(textStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),textAlign: TextAlign.center,),
                        trailing: Container(
                          height: ScreenUtil().setHeight(55),
                          width: ScreenUtil().setHeight(55),
                          child: Image.asset('images/calender.png'),
                        ),
                        onTap: () async {
                          String sanitizeDateTime(DateTime dateTime) => "${dateTime.year}-${dateTime.month}-${dateTime.day}";
                          DateTime selectedDate = await showRoundedDatePicker(
                            context: context,
                              height: MediaQuery.of(context).size.height/2.7,
                              selectableDayPredicate: (DateTime val){
                                String sanitized = sanitizeDateTime(val);
                                return !widget.unselectableDates.contains(sanitized);
                              },
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now().subtract(Duration(days: 1)),
                              lastDate: DateTime(2999,12,31),
                              borderRadius: 20,
                              theme: ThemeData(
                                primaryColor: Color(0xffCF1B1B),
                                accentColor: Color(0xffFF414D),
                              ),
                          );
                          setState(() {
                            date = DateFormat('yyyy-MM-dd').format(selectedDate);
                          });
                        },
                      ),
                    ),
                    SizedBox(height: ScreenUtil().setHeight(90),),
                    Padding(
                      padding:  EdgeInsets.symmetric(horizontal: ScreenUtil().setHeight(30)),
                      child: Button(text: 'Submit',color: Theme.of(context).accentColor,onclick: () async {
                        if(name.text!=''&&ad1.text!=''&&ad2.text!=''&&city.text!=''&&state.text!=''&&zip.text!=''&&phone.text!=''&&date!='Select a date'){
                          ToastBar(text: 'Please wait...',color: Colors.orange).show();
                          try{
                            List x = widget.unselectableDates;
                            x.add(date);
                            await FirebaseFirestore.instance.collection('data').doc(widget.id).update({
                              'booked': x
                            });

                            String username = 'yiannisjumping@gmail.com';
                            String password = 'Admin@castle';
                            final smtpServer = gmail(username, password);
                            final message = Message()
                              ..from = Address(username, 'Yiannis Jumping Castles')
                              ..recipients.add('Emanuel@northcoastbuildingservices.com.au')
                              ..subject = 'New Booking for ${widget.title}'
                              ..text = 'Item: ${widget.title}\n'
                                  'Date: $date\n'
                                  'Name: ${name.text}\n'
                                  'Address Line 1: ${ad1.text}\n'
                                  'Address Line 2: ${ad2.text}\n'
                                  'City: ${city.text}\n'
                                  'State: ${state.text}\n'
                                  'Postal Code: ${zip.text}\n'
                                  'Phone Number: ${phone.text}\n';
                            try {
                              final sendReport = await send(message, smtpServer);
                              print('Message sent: ' + sendReport.toString());
                              ToastBar(text: 'Message Sent!',color: Colors.green).show();
                            } on MailerException catch (e) {
                              print('Message not sent.');
                              for (var p in e.problems) {
                                print('Problem: ${p.code}: ${p.msg}');
                              }
                            }

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
                                        CustomText(text: 'We have received your request!', color: Colors.black,size: ScreenUtil().setSp(45),),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                            Timer(Duration(seconds: 4), (){
                              Navigator.of(context).pushAndRemoveUntil(
                                  CupertinoPageRoute(builder: (context) => Home()), (Route<dynamic> route) => false);
                            });


                          }
                          catch(e){
                            ToastBar(text: 'Something went wrong!',color: Colors.red).show();
                          }
                        }
                        else{
                            ToastBar(text: 'Please fill all fields',color: Colors.red).show();
                        }
                      },),
                    ),
                    SizedBox(height: ScreenUtil().setHeight(30),),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
