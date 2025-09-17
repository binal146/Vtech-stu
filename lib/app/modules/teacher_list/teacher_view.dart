import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:vteach_teacher/app/core/utils/image.dart';
import 'package:vteach_teacher/app/core/values/comman_text.dart';
import 'package:vteach_teacher/app/modules/teacher_list/teacher_controller.dart';
import '../../core/utils/colour.dart';
import '../../core/utils/fonts.dart';
import '../../core/values/text_styles.dart';
import '../../core/widget/custom_app_bar.dart';
import '../../routes/app_pages.dart';
import '/app/core/base/base_view.dart';

class TeacherView extends BaseView<TeacherController> {


  TeacherView({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return null;
  }

  @override
  Widget body(BuildContext context) {
    return Column(
      children: [
        Container(height: 45.h,
          padding: EdgeInsets.symmetric(horizontal: 10),
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(Get.arguments.toString().toUpperCase(),
                  style: appBarTitle,
                  textAlign: TextAlign.center,
                ),
                Text("Grade 1",
                  style: subTitle,
                  textAlign: TextAlign.center,
                )
              ],
            )
          ],),),
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Column(children: [
          
              SizedBox(height: 20.h,),
          
              Container(
                height: 40.h,
                child: TextField(
                  onTapOutside: (event) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  cursorColor: Clr.addCart,
                  style: TextStyle(color: Colors.black),
                  controller: controller.searchContoller,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.zero,
                      prefixIcon: Icon(Icons.search,color: Clr.black,),
                      prefixIconColor: MaterialStateColor.resolveWith((states) =>
                      states.contains(MaterialState.focused)
                          ? Colors.grey
                          : Colors.grey),
                      suffixIconColor: MaterialStateColor.resolveWith((states) =>
                      states.contains(MaterialState.focused)
                          ? Colors.black
                          : Colors.black),
                      focusColor: Clr.appColor,
                      hintStyle: TextStyle(
                          fontSize: 14.sp, fontFamily: Fonts.PoppinsRegular, color:Clr.searchHintColor),
                      hintText: AppText.search,
                      fillColor: Clr.grey_bg,
                      filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide.none,
                    ),
          
                  ),
                  onChanged: (value){
          
                  },
          
                ),
              ),
          
              SizedBox(height: 10.h,),
          
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: 10,
                  itemBuilder: (context, index) {
                  return InkWell(
                    onTap: (){
                      Get.toNamed(Routes.TEACHER_DETAIL);
                    },
                    child: Container(
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: Row(children: [
          
                        /*SizedBox(
                            height: 100.sp,
                            width: 100.sp,
                            //square box; equal height and width so that it won't look like oval
                            child: Card(
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                //child: Image.asset(productList.elementAt(index).productImages!.elementAt(0).image.toString(), fit: BoxFit.cover),
                                child: Image.asset(Drawables.dummy1,fit: BoxFit.cover,))),*/
          
                        SizedBox(
                            height: 100.sp,
                            width: 100.sp,
                            //square box; equal height and width so that it won't look like oval
                            child: Image.asset(Drawables.dummy3,fit: BoxFit.cover,)),
          
                        SizedBox(width: 5.w,),
          
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
          
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          SvgPicture.asset(Drawables.star),
                                          SizedBox(width: 3.w,),
                                          Text('4.0 (245k)',style: greyPoppinsRegular12,)
                                        ],
                                      ),
                                      SizedBox(height: 5.h,),
                                      Text('John Smith',style: blackPoppinsRegular16,)
                                    ],
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Clr.appColor,
                                        borderRadius: BorderRadius.circular(24)
                                    ),
                                    padding: EdgeInsets.all(5),
                                    child: Text(' \$24/hr',style: TextStyle(
                                        fontSize: 14.sp,
                                        color: Clr.white,
                                        fontFamily: Fonts.PoppinsRegular),),)
                                ],),
                              SizedBox(height: 5.h,),
                              Text('Exp: 12 years',style: blackPoppinsRegular12,),
                              SizedBox(height: 5.h,),
                              Text('Lorem ipsum dolor sit amet,consectetur adipiscing elit...',style: greyPoppinsRegular12 ,)
                            ],
                          ),
                        )
          
                      ],),
                    ),
                  );
                },),
              ),
          
          
          
            ],),
          ),
        ),
      ],
    );
  }

}
