import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yiannis_jumping_castles/screens/customer-details.dart';
import 'package:yiannis_jumping_castles/widgets/button.dart';
import 'package:yiannis_jumping_castles/widgets/custom-text.dart';

class Details extends StatelessWidget {
  final String image;
  final String description;
  final String title;
  final String id;
  final List dates;

  const Details({Key key, this.image, this.description, this.title, this.id, this.dates}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height/3,
                  width: double.infinity,
                  child: CachedNetworkImage(
                    imageUrl: image,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    fit: BoxFit.cover,
                  ),
                ),
                BackButton(color: Colors.white,onPressed: (){Navigator.pop(context);},),
              ],
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(ScreenUtil().setWidth(30)),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    color: Color(0xffFFCDD2),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20)
                          )
                        ),
                        child: Padding(
                          padding:  EdgeInsets.all(ScreenUtil().setWidth(25)),
                          child: CustomText(text: title,size: ScreenUtil().setSp(35),),
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          child: Padding(
                            padding:  EdgeInsets.all(ScreenUtil().setWidth(35)),
                            child: CustomText(
                              text: description,
                              color: Colors.black,
                              height: 1.4,
                              align: TextAlign.justify,
                              isBold: false,
                              size: ScreenUtil().setSp(30),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: ScreenUtil().setHeight(40),),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(60)),
              child: Button(text: 'Book Now',color: Theme.of(context).accentColor,onclick: (){
                Navigator.push(context, CupertinoPageRoute(builder: (context){
                  return CustomerDetails(title: title,id: id,unselectableDates: dates,);}));
              },),
            ),
            SizedBox(height: ScreenUtil().setHeight(40),),
          ],
        ),
      ),
    );
  }
}
