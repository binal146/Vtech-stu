import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:vteach_teacher/app/modules/view_pdf/viewpdf_controller.dart';
import '../../core/utils/colour.dart';
import '../../core/values/comman_text.dart';
import '../../core/values/text_styles.dart';
import '/app/core/base/base_view.dart';


class ViewPdfView extends BaseView<ViewPdfController> {
  ViewPdfView({super.key});


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
          child: SfPdfViewer.network(
              controller.fileUrl,),
        ),
      ],
    );
  }



}
