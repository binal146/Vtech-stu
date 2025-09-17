import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:get/get.dart';
import 'package:vteach_teacher/app/modules/view_image/viewimage_controller.dart';
import '../../core/utils/colour.dart';
import '../../core/values/text_styles.dart';
import '/app/core/base/base_view.dart';


class ViewImageView extends BaseView<ViewImageController> {
  ViewImageView({super.key});


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
            Text(controller.pdfTitle,
              style: appBarTitle,
              textAlign: TextAlign.center,
            )
          ],),),
       /* Expanded(
          child: PDFViewer(
            backgroundColor: Clr.white,
           document : controller.document,
          ),
        ),*/

        Expanded(
          child:  FullScreenWidget(
            disposeLevel: DisposeLevel.High,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                controller.fileUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ],
    );
  }



}
