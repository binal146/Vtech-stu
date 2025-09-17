import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:vteach_teacher/app/core/utils/image.dart';
import 'package:vteach_teacher/app/core/values/comman_text.dart';
import 'package:vteach_teacher/app/modules/teacher_detail/teacher_detail_controller.dart';
import 'package:vteach_teacher/app/modules/teacher_list/teacher_controller.dart';
import '../../core/utils/colour.dart';
import '../../core/utils/fonts.dart';
import '../../core/values/text_styles.dart';
import '../../core/widget/custom_app_bar.dart';
import '../../routes/app_pages.dart';
import '/app/core/base/base_view.dart';

class TeacherDetailView extends BaseView<TeacherDetailController> {


  TeacherDetailView({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return null;
  }

  @override
  Widget body(BuildContext context) {
    return Column(
      children: [
        Container(height: 40.h,
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Row(children: [
            InkWell(
              onTap: (){
                Get.back();
              },
              child: Container(
                padding: EdgeInsets.all(5),
                margin: EdgeInsets.only(left: 5),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Clr.backButtonBg
                ),
                child: Icon(Icons.arrow_back_ios_new_outlined),
              ),
            ),
            SizedBox(width: 10.w,),
            Text(AppText.profile,
              style: appBarTitle,
              textAlign: TextAlign.center,
            )
          ],),),
        Expanded(
          child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
          
                SizedBox(height: 10.h,),
          
               /* SizedBox(
                    height: MediaQuery.of(context).size.width * 0.5,
                    width: double.infinity,
                    //square box; equal height and width so that it won't look like oval
                    child: Card(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        //child: Image.asset(productList.elementAt(index).productImages!.elementAt(0).image.toString(), fit: BoxFit.cover),
                        child: SvgPicture.asset(Drawables.app_icon))),*/
          
                  SizedBox(
                      height: MediaQuery.of(context).size.width * 0.5,
                      width: double.infinity,
                      //square box; equal height and width so that it won't look like oval
                      child: Image.asset(Drawables.dummy4,fit: BoxFit.cover,)),
          
                  SizedBox(height: 10.h,),
          
                Row(
                  children: [
                    SvgPicture.asset(Drawables.star),
                    SizedBox(width: 3.w,),
                    Text('4.0 (245k)',style: greyPoppinsRegular12,)
                  ],
                ),
                SizedBox(height: 5.h,),
                Text('John Smith',style: blackPoppinsRegular16,),
                SizedBox(height: 5.h,),
                Text('Exp: 12 years',style: blackPoppinsRegular12,),
                SizedBox(height: 5.h,),
                Container(
                  height: 30.h,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: subjects.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: (){
          
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                            color: Clr.green200
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          margin: EdgeInsets.only(right: 10),
                          child: Center(
                            child: Text(subjects[index],style:  TextStyle(
                                fontSize: 12.sp,
                                color: Clr.blackColor,
                                fontFamily: Fonts.PoppinsMedium)),
                          ),
                        ),
                      );
                    },),
                ),
                SizedBox(height: 5.h,),
                Text('\$24/hr',style: TextStyle(
                    fontSize: 22.sp,
                    color: Clr.yellowColor,
                    fontFamily: Fonts.PoppinsMedium),),
                SizedBox(height: 10.h,),
                Text(AppText.description,style: blackPoppinsRegular14,),
                Text('Lorem ipsum dolor sit amet,consectetur adipiscing elit Lorem ipsum dolor sit amet,consectetur adipiscing elit Lorem ipsum dolor sit amet,consectetur adipiscing elit Lorem ipsum dolor sit amet,consectetur adipiscing elit...',
                  style: greyPoppinsRegular12 ,),
                SizedBox(height: 10.h,),
                Text(AppText.education_background,style: blackPoppinsRegular14,),
                Text('Lorem ipsum dolor sit amet,consectetur adipiscing elit Lorem ipsum dolor sit amet,consectetur adipiscing elit Lorem ipsum dolor sit amet,consectetur adipiscing elit Lorem ipsum dolor sit amet,consectetur adipiscing elit...',
                  style: greyPoppinsRegular12 ,),
          
                SizedBox(height: 10.h,),
          
                Text(AppText.interests,style: blackPoppinsRegular14,),
          
                SizedBox(height: 5.h,),
          
                Container(
                  height: 30.h,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: interests.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: (){
          
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Clr.grey_bg
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          margin: EdgeInsets.only(right: 10),
                          child: Center(
                            child: Text(interests[index],style:  TextStyle(
                                fontSize: 12.sp,
                                color: Clr.searchHintColor,
                                fontFamily: Fonts.PoppinsRegular)),
                          ),
                        ),
                      );
                    },),
                ),
          
                SizedBox(height: 10.h,),
          
                Text(AppText.known_languages,style: blackPoppinsRegular14,),
          
                SizedBox(height: 5.h,),
          
                Container(
                  height: 30.h,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: languages.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: (){
          
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Clr.grey_bg
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          margin: EdgeInsets.only(right: 10),
                          child: Center(
                            child: Text(languages[index],style:  TextStyle(
                                fontSize: 12.sp,
                                color: Clr.searchHintColor,
                                fontFamily: Fonts.PoppinsMedium)),
                          ),
                        ),
                      );
                    },),
                ),
          
                SizedBox(height: 10.h,),
          
                SizedBox(
                  width: double.infinity,
                  height: 45.h,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.toNamed(Routes.AVAILABILITY,arguments: "0");
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Clr.appColor),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),),
                    ),
                    child: Text(AppText.make_aapointment,style:  TextStyle(fontSize: 16.sp,color: Clr.white,fontFamily: Fonts.PoppinsMedium),),
                  ),
                ),
          
                SizedBox(height: 10.h,),
          
          
              ],),
            ),
          ),
        ),
      ],
    );
  }

  static const List<String> subjects = [
    'Biology',
    'Hindi',
    'Science',
  ];
  static const List<String> interests = [
    'Reading',
    'Shopping',
    'Get-together',
  ];

  static const List<String> languages = [
    'English',
    'Hindi',
    'Telugu',
  ];
}
