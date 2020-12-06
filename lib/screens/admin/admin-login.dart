import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yiannis_jumping_castles/screens/admin/admin-home.dart';
import 'package:yiannis_jumping_castles/widgets/button.dart';
import 'package:yiannis_jumping_castles/widgets/custom-text.dart';
import 'package:yiannis_jumping_castles/widgets/labled-inputfield.dart';
import 'package:yiannis_jumping_castles/widgets/toast.dart';

class AdminLogin extends StatelessWidget {

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,designSize: Size(720, 1520), allowFontScaling: false);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: EdgeInsets.all(ScreenUtil().setWidth(30)),
        child: Center(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white,width: 3),
              color: Color(0xffFFCDD2)
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                      color: Theme.of(context).primaryColor
                  ),
                  child: Padding(
                    padding:  EdgeInsets.all(ScreenUtil().setWidth(30)),
                    child: CustomText(text: 'Admin Login',size: ScreenUtil().setSp(40),color: Colors.white,),
                  ),
                ),
                SizedBox(height: ScreenUtil().setHeight(30),),
                Padding(
                  padding:  EdgeInsets.all(ScreenUtil().setWidth(25)),
                  child: LabeledInputField(hint: 'Email',controller: email,),
                ),
                Padding(
                  padding:  EdgeInsets.all(ScreenUtil().setWidth(25)),
                  child: LabeledInputField(hint: 'Password',isPassword: true,controller: password,),
                ),
                Padding(
                  padding:  EdgeInsets.all(ScreenUtil().setWidth(55)),
                  child: Button(text: 'Log In',color: Colors.white,textColor: Colors.black,onclick: () async {
                    ToastBar(text: 'Please wait...',color: Colors.orange).show();
                    var sub = await FirebaseFirestore.instance.collection('admin').where('email', isEqualTo: email.text).get();
                    var users = sub.docs;
                    if(users.isNotEmpty){
                      if(users[0]['password']==password.text){
                        Navigator.of(context).pushAndRemoveUntil(
                              CupertinoPageRoute(builder: (context) => AdminHome()), (Route<dynamic> route) => false);
                      }
                      else{
                        ToastBar(text: 'Password is incorrect!',color: Colors.red).show();
                      }
                    }
                    else{
                      ToastBar(text: 'Admin not found!',color: Colors.red).show();
                    }
                  },),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
