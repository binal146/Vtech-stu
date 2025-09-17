import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:vteach_teacher/app/core/utils/image.dart';
import 'package:vteach_teacher/app/core/values/comman_text.dart';
import 'package:vteach_teacher/app/core/values/constants.dart';
import 'package:vteach_teacher/app/modules/my_profile/my_profile_controller.dart';
import '../../core/utils/colour.dart';
import '../../core/utils/fonts.dart';
import '../../core/values/text_styles.dart';
import '../../routes/app_pages.dart';
import '/app/core/base/base_view.dart';

class MyProfileView extends BaseView<MyProfileController> {

  MyProfileView({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return null;
  }

  @override
  Widget body(BuildContext context) {
    return Obx(() => (controller.myProfileData.value == null) ? SizedBox() : Column(
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
            Text(AppText.my_profile,
              style: appBarTitle,
              textAlign: TextAlign.center,
            )
          ],),),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    height: MediaQuery.of(context).size.width * 0.5,
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    //square box; equal height and width so that it won't look like oval
                    child: Obx(() =>  (controller.myProfileData.value == null) ? ClipRRect(
                        borderRadius: BorderRadius.circular(22),
                        child: Image.asset(Drawables.placeholder_photo,fit: BoxFit.cover,)) : (controller.myProfileData.value!.profileImage!.isEmpty) ? ClipRRect(
                        borderRadius: BorderRadius.circular(22),
                        child: Image.asset(Drawables.placeholder_photo,fit: BoxFit.cover,)) : ClipRRect(
                        borderRadius: BorderRadius.circular(22),
                        child: Image.network(controller.myProfileData.value?.profileImage! ?? '',fit: BoxFit.cover,)),)),
                Obx(() => Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      SizedBox(height: 10.h,),
                      Row(
                        children: [
                          SvgPicture.asset(Drawables.star),
                          SizedBox(width: 3.w,),
                          //Text('4.0 (245k)',style: greyPoppinsRegular12,)
                          Text('${controller.myProfileData.value?.avgRating.toString() ?? '0'} ',style: greyPoppinsRegular12,),
                          InkWell(
                            onTap: (){
                              Get.toNamed(Routes.REVIEW,parameters: {
                                'rating' : controller.myProfileData.value!.avgRating.toString(),
                                'total_review' : controller.myProfileData.value!.totalRating.toString(),
                              });
                            },
                            child: Text('(${controller.myProfileData.value?.totalRating.toString() ?? '0'})',style: TextStyle(
                                fontSize: 12.sp,
                                color: Clr.blue,
                                fontFamily: Fonts.PoppinsRegular),),
                          )
                        ],
                      ),
                      SizedBox(height: 5.h,),
                      Text(controller.myProfileData.value?.fullName ?? '',style: blackPoppinsRegular16,),
                      SizedBox(height: 5.h,),
                      Text(controller.myProfileData.value?.email ?? '',style: greyPoppinsRegular12,),
                      SizedBox(height: 5.h,),
                      Text(controller.myProfileData.value!.countryCode.toString()+" "+controller.myProfileData.value!.mobileNumber.toString() ?? '',style: blackPoppinsRegular14,),
                      SizedBox(height: 5.h,),
                      Text('Exp.: ${controller.myProfileData.value?.experience ?? ''}',style: blackPoppinsRegular12,),
                      SizedBox(height: 5.h,),
                      ListView.builder(
                        itemCount: controller.myProfileData.value!.gradeSubject!.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, parentIndex) {
                          return Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            child: InputDecorator(
                              decoration: InputDecoration(
                                labelText: controller.myProfileData.value!.gradeSubject![parentIndex].grade,
                                labelStyle: TextStyle(
                                    fontSize: 16.sp,
                                    color: Clr.blackColor
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Clr.grey_border), // Set the color you want for the enabled border
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Clr.grey_border), // Set the color you want for the focused border
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),

                              child: Wrap(
                                spacing: 8.0, // Adjust spacing between chips as needed
                                runSpacing: 8.0, // Adjust run spacing as needed
                                children:  List.generate(controller.myProfileData.value!.gradeSubject![parentIndex].subject!.length,
                                      (index) {
                                    return GestureDetector(
                                      onTap: (){
                                        // controller.selectedSubject.value = index;
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(20),
                                            color: Clr.grey_border
                                        ),
                                        margin: EdgeInsets.only(right: 10,top: 5),
                                        padding: EdgeInsets.all(8),
                                        child: Text(controller.myProfileData.value!.gradeSubject![parentIndex].subject![index].subject.toString(),style: (index == 0) ? TextStyle(
                                            fontSize: 12.sp,
                                            color: Clr.blackColor,
                                            fontFamily: Fonts.PoppinsMedium) : TextStyle(
                                            fontSize: 12.sp,
                                            color: Clr.searchHintColor,
                                            fontFamily: Fonts.PoppinsMedium)),
                                      ),
                                    );
                                  },),),
                            ),
                          );
                        },),
                      /*Container(
                        constraints: BoxConstraints(maxHeight:MediaQuery.of(context).size.height *  0.05),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: controller.myProfileData.value?.subject?.length ?? 0,
                          itemBuilder: (context, index) {
                            return Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  color: Clr.blueLight
                              ),
                              padding: EdgeInsets.all(7),
                              margin: EdgeInsets.only(right: 10,top: 5),
                              child: Center(
                                child: Text(controller.myProfileData.value!.subject![index].subject.toString(),style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Clr.blackColor,
                                    fontFamily: Fonts.PoppinsMedium)),
                              ),
                            );
                          },),
                      ),*/
                      SizedBox(height: 5.h,),
                      Text(Constants.currency + controller.myProfileData.value!.rate.toString()+'/Hr' ?? '\$0/hr',style: TextStyle(
                          fontSize: 22.sp,
                          color: Clr.yellowColor,
                          fontFamily: Fonts.PoppinsMedium),),
                      SizedBox(height: 10.h,),
                      Text(AppText.description,style: blackPoppinsRegular14,),
                      SizedBox(height: 5.h,),
                      Text(controller.myProfileData.value?.description ?? '',
                        style: greyPoppinsRegular12 ,),
                      SizedBox(height: 15.h,),
                      Text(AppText.education_background,style: blackPoppinsRegular14,),
                      SizedBox(height: 5.h,),
                      Text(controller.myProfileData.value?.education ?? '',
                        style: greyPoppinsRegular12 ,),
                      SizedBox(height: 10.h,),

                      Text(AppText.country,style: blackPoppinsRegular14,),
                      SizedBox(height: 5.h,),
                      Text(controller.myProfileData.value?.country_name ?? '',
                        style: greyPoppinsRegular12 ,),
                      SizedBox(height: 10.h,),

                      (controller.myProfileData.value!.state_name!.isNotEmpty) ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                Text(AppText.state,style: blackPoppinsRegular14,),
                SizedBox(height: 5.h,),
                Text(controller.myProfileData.value?.state_name ?? '',
                  style: greyPoppinsRegular12 ,),
                SizedBox(height: 10.h,),
              ],) : SizedBox(),

                      (controller.myProfileData.value!.city_name!.isNotEmpty) ?
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(AppText.city,style: blackPoppinsRegular14,),
                          SizedBox(height: 5.h,),
                          Text(controller.myProfileData.value?.city_name ?? '',
                            style: greyPoppinsRegular12 ,),
                          SizedBox(height: 10.h,),
                        ],
                      ) : SizedBox(),

                      Text(AppText.interests,style: blackPoppinsRegular14,),

                      SizedBox(height: 10.h,),

                      Container(
                        height: 28.h,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: controller.myProfileData.value?.interests!.length ?? 0,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: (){

                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    color: Clr.grey_bg
                                ),
                                padding: EdgeInsets.all(5),
                                margin: EdgeInsets.only(right: 10),
                                child: Center(
                                  child: Text(controller.myProfileData.value!.interests![index].interest.toString(),style:  TextStyle(
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

                      SizedBox(height: 10.h,),

                      Container(
                        height: 28.h,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: controller.myProfileData.value?.knownLanguages!.length ?? 0,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: (){

                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    color: Clr.grey_bg
                                ),
                                padding: EdgeInsets.all(5),
                                margin: EdgeInsets.only(right: 10),
                                child: Center(
                                  child: Text(controller.myProfileData.value?.knownLanguages![index].known_language.toString() ?? '',style:  TextStyle(
                                      fontSize: 12.sp,
                                      color: Clr.searchHintColor,
                                      fontFamily: Fonts.PoppinsMedium)),
                                ),
                              ),
                            );
                          },),
                      ),


                      SizedBox(height: 20.h,),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(AppText.attached_documents,style: blackPoppinsRegular14,),

                          GestureDetector(
                            onTap: () async {
                              var result = await Get.toNamed(Routes.ADD_DOCUMENT,arguments: controller.myProfileData.value!.document);
                              if(result == true){
                                controller.callGetProfileService();
                              }
                            },
                            child: Text(AppText.add_edit_documents,style: TextStyle(
                                fontSize: 12.sp,
                                fontFamily: Fonts.PoppinsRegular,
                                color: Clr.color2020f2),),
                          ),

                        ],
                      ),

                      SizedBox(height: 10.h,),

                      Container(
                        height: 300.h,
                        child: ListView.builder(
                          itemCount: controller.myProfileData.value?.document?.length ?? 0,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.only(top:10,left: 10),
                              child: Column(children: [
                                DottedBorder(
                                  color: Clr.borderColor,
                                  strokeWidth: 1,
                                  radius : Radius.circular(20),
                                  borderType : BorderType.RRect,
                                  dashPattern: [4,2],
                                  child:GestureDetector(
                                    onTap: () async {
                                     /* if(controller.myProfileData.value!.document![index].file_type == "pdf"){
                                        controller.checkPermissions(index);
                                      }*/
                                      //PDFDocument  document = await PDFDocument.fromURL(controller.myProfileData.value!.document![index].fileUrl.toString());
                                     // Get.toNamed(Routes.VIEW_PDF,arguments: document,parameters: {'pdf_title':controller.myProfileData.value!.document![index].title.toString()});
                                      if(controller.myProfileData.value!.document![index].file_type == "pdf") {
                                        Get.toNamed(Routes.VIEW_PDF, parameters: {
                                          'pdf_title': controller.myProfileData.value!.document![index].title.toString(),
                                          "file_url": controller.myProfileData.value!.document![index].fileUrl.toString()
                                        });
                                      }
                                    },
                                    child: Container(
                                      color: Colors.transparent,
                                      width: MediaQuery.of(context).size.width * 0.5,
                                      height: MediaQuery.of(context).size.width * 0.7,
                                      child: (controller.myProfileData.value!.document![index].fileUrl!.isEmpty) ? Center(
                                          child: SvgPicture.asset(Drawables.placeholder1)) : (controller.myProfileData.value!.document![index].file_type == "pdf") ? Padding(
                                        padding: EdgeInsets.all(30),
                                          child: SvgPicture.asset(Drawables.pdf_document)) : ClipRRect(
                                          borderRadius: BorderRadius.circular(20),
                                          child: Image.network(controller.myProfileData.value!.document![index].fileUrl!,fit: BoxFit.fill,)),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10.h,),
                                Text(controller.myProfileData.value!.document![index].title!,style: TextStyle(
                                    fontSize: 12.sp,
                                    fontFamily: Fonts.PoppinsMedium,
                                    color: Clr.searchHintColor),)
                              ],),
                            );
                          },),
                      ),


                      SizedBox(height: 30.h,),



                    ],),
                ),),
              ],
            ),
          ),
        ),
      ],
    ),);
  }

  @override
  Widget? bottomNavigationBar(BuildContext context) {
    return   Container(
      width: double.infinity,
      height: 45.h,
      margin: EdgeInsets.all(15),
      child: ElevatedButton(
        onPressed: () async {
         var result = await Get.toNamed(Routes.EDIT_PROFILE,arguments: controller.myProfileData);
         if(result == true){
           controller.callGetProfileService();
         }
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Clr.appColor),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),),
        ),
        child: Text(AppText.edit_profile.toUpperCase(),style:  TextStyle(fontSize: 16.sp,color: Clr.white,fontFamily: Fonts.PoppinsMedium),),
      ),
    );
  }

}
