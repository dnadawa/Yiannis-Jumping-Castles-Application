import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:yiannis_jumping_castles/screens/admin/admin-login.dart';
import 'package:yiannis_jumping_castles/screens/details.dart';
import 'package:yiannis_jumping_castles/widgets/custom-text.dart';
import 'package:yiannis_jumping_castles/widgets/marquee.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List<DocumentSnapshot> data;
  StreamSubscription<QuerySnapshot> subscription;

  getData() async {
    await Firebase.initializeApp();
    subscription = FirebaseFirestore.instance.collection('data').snapshots().listen((datasnapshot){
      setState(() {
        data = datasnapshot.docs;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,designSize: Size(720, 1520), allowFontScaling: false);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: CustomText(text: 'Home',),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: ScreenUtil().setHeight(20)),
            child: GestureDetector(
              onTap: (){
                Navigator.push(context, CupertinoPageRoute(builder: (context){
                  return AdminLogin();}));
              },
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 15,
                child: Center(
                  child: Container(
                      width: ScreenUtil().setWidth(35),
                      height: ScreenUtil().setHeight(35),
                      child: Image.asset('images/admin.png')),
                ),
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(ScreenUtil().setHeight(25)),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: data!=null?GridView.builder(
            itemCount: data.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,mainAxisSpacing: 5,crossAxisSpacing: 5),
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.all(ScreenUtil().setWidth(20)),
            itemBuilder: (context , i){
              String name = data[i]['name'];
              String image = data[i]['image'];
              String description = data[i]['description'];
              String id = data[i].id;
              List booked = data[i]['booked'];
              return GestureDetector(
                onTap: (){
                  Navigator.push(context, CupertinoPageRoute(builder: (context){
                    return Details(title: name,description: description,image: image,dates: booked,id: id,);}));
                },
                child: Card(
                  color: Color(0xffFFCDD2),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding:  EdgeInsets.all(ScreenUtil().setWidth(20)),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: CachedNetworkImage(
                                imageUrl: image,
                                placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                                errorWidget: (context, url, error) => Icon(Icons.error),
                                fit: BoxFit.cover,
                              ),),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Color(0xffeeeeee),
                            borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
                            border: Border.all(color: Theme.of(context).accentColor,width: 3)
                        ),
                        child: Padding(
                          padding:  EdgeInsets.all(ScreenUtil().setWidth(10)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Flexible(child: MarqueeWidget(child: CustomText(text: name,color: Colors.black,))),
                              SizedBox(width: ScreenUtil().setWidth(10),),
                              Icon(Icons.play_circle_filled,color: Theme.of(context).accentColor,size: 25,)
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                ),
              );
            },
          ):Center(child: CircularProgressIndicator(),),
        ),
      ),
    );
  }
}
