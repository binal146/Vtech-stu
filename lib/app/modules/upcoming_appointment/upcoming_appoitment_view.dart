import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:vteach_teacher/app/core/utils/image.dart';
import 'package:vteach_teacher/app/modules/upcoming_appointment/upcoming_appointment_controller.dart';
import '../../core/utils/fonts.dart';
import '../../core/values/comman_text.dart';
import '../../core/values/text_styles.dart';
import '../../core/widget/custom_app_bar.dart';
import '../../routes/app_pages.dart';
import '/app/core/base/base_view.dart';

class UpcomingAppointmentView extends BaseView<UpcomingAppointmentController> {

  late Map<String, dynamic> data;

  List colors = [ const Color(0xFFfdf4e2),const Color(0xFFFEEBF7),const Color(0xFFE6FFFB),const Color(0xFFFEE7E3),];
  List colors2 = [ const Color(0xFFFBE8C6),const Color(0xFFFBD8EC),const Color(0xFFC8F6ED),const Color(0xFFFBD9D5),];

  UpcomingAppointmentView({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return CustomAppBar(
      appBarTitleText: AppText.appoinments,
      isBackButtonEnabled:false,
      isCenterTitle: false,
    );
  }

  @override
  Widget body(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Column(children: [


        Expanded(
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: 10,
            itemBuilder: (context, index) {
            return InkWell(
              onTap: (){
                //Get.toNamed(Routes.APPOINTMENT_DETAIL);
              },
              child: Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(vertical: 10),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey[200]!)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.green[100]
                          ),
                          padding: EdgeInsets.all(7),
                          margin: EdgeInsets.only(right: 10),
                          child: Text('Biology',style:  TextStyle(
                              fontSize: 14.sp,
                              color: Colors.black,
                              fontFamily: Fonts.PoppinsRegular)),
                        ),

                        Row(children: [
                          SizedBox(
                              height: 40.sp,
                              width: 40.sp,
                              //square box; equal height and width so that it won't look like oval
                              child: Image.asset(Drawables.dummy5,fit: BoxFit.cover,)),

                          SizedBox(width: 5.w,),

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

                        ],),
                      ],),

                    SizedBox(height: 10.h,),

                    Text('15 May,2024 - 22 May,2024',style: blackPoppinsSemiBold14,),

                    SizedBox(height: 5.h,),

                    Text('11:00 am - 12:00 pm',style: greyPoppinsRegular14,)

                  ],
                ),
              ),
            );
          },),
        ),



      ],),
    );
  }

}
