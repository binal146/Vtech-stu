import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:vteach_teacher/app/core/utils/common_widgets.dart';
import 'package:vteach_teacher/app/core/values/text_styles.dart';
import '../../core/utils/colour.dart';
import '../../core/utils/fonts.dart';
import '../../core/utils/image.dart';
import '../../core/utils/keyboard_types.dart';
import '../../core/values/comman_text.dart';
import '../../core/widget/comman_textfield.dart';
import '/app/core/base/base_view.dart';
import 'add_document_controller.dart';


class AddDocumentView extends BaseView<AddDocumentController> {

  AddDocumentView({super.key});

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
            Text((controller.isAdd.value) ? AppText.add_documents : AppText.edit_documents.toUpperCase(),
              style: appBarTitle,
              textAlign: TextAlign.center,
            ),

          ],),),
        Expanded(
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      SizedBox(
                        height: 20.h,
                      ),

                      Obx(() => ListView.builder(
                        itemCount: controller.textfieldControllers.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Column(children: [
                            SizedBox(
                              height: 15.h,
                            ),
                            Padding(
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                child: CommanTextField(hint:"",label :AppText.document_title,keyboardType:KeyboardComman.NAME,inputAction:KeyboardComman.DONE,maxlines:1,controller: controller.textfieldControllers[index])),
                            SizedBox(
                              height: 20.h,
                            ),
                            InkWell(
                              onTap:(){
                                //controller.pickImage(index);
                                chooseFileOption(context, index);
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                child: Stack(
                                  children: [

                                    DottedBorder(
                                      color: Clr.borderColor,
                                      strokeWidth: 1,
                                      radius : Radius.circular(20),
                                      borderType : BorderType.RRect,
                                      dashPattern: [4,2],
                                      child: (controller.isAdd.value) ? Obx(() => Container(
                                        width: MediaQuery.of(context).size.width,
                                        height: MediaQuery.of(context).size.width * 0.6,
                                        child:  (controller.images[index] == null) ? Center(
                                            child: SvgPicture.asset(Drawables.placeholder1)) : Center(
                                            child: (controller.images[index]!.path.contains('pdf')) ? Padding(
                                                padding: EdgeInsets.all(30),
                                                child: SvgPicture.asset(Drawables.pdf_document,height: 100,width: 100,)) : ClipRRect(
                                                borderRadius: BorderRadius.circular(20),
                                                child: Image.file(File(controller.images[index]!.path),fit: BoxFit.fill,))),
                                      ),) :
                                      Obx(() => Container(
                                        width: MediaQuery.of(context).size.width,
                                        height: MediaQuery.of(context).size.width * 0.6,
                                        child: Center(
                                            child: (controller.documentList!.value[index].fileUrl.toString().isEmpty) ? (controller.images[index] == null) ? Center(
                                                child: SvgPicture.asset(Drawables.placeholder1)) : (controller.images[index]!.path.contains('pdf')) ? Padding(
                                                padding: EdgeInsets.all(30),
                                                child: SvgPicture.asset(Drawables.pdf_document,height: 100,width: 100,)) : ClipRRect(
                          borderRadius: BorderRadius.circular(20),child: Image.file(File(controller.images[index]!.path),fit: BoxFit.fill,)) : ((controller.images[index] == null)) ? (controller.documentList!.value[index].file_type == 'pdf') ? Padding(
                                                padding: EdgeInsets.all(30),
                                                child: SvgPicture.asset(Drawables.pdf_document,height: 100,width: 100,)) : ClipRRect(
                          borderRadius: BorderRadius.circular(20),child: Image.network(controller.documentList!.value[index].fileUrl.toString(),fit: BoxFit.fill,)) : (controller.images[index]!.path.contains('pdf')) ? Padding(
                                                padding: EdgeInsets.all(30),
                                                child: SvgPicture.asset(Drawables.pdf_document,height: 100,width: 100,)) : ClipRRect(
                                                borderRadius: BorderRadius.circular(20),child: Image.file(File(controller.images[index]!.path),fit: BoxFit.fill,)) ),
                                      ),),
                                    ),

                                Obx(() =>  (controller.documentList!.value[index].fileUrl.toString().isEmpty) ? (controller.images[index] == null) ? SizedBox(): Positioned(
                                  right: 20,
                                  top :20,
                                  child: GestureDetector(
                                      onTap: (){
                                        removeImage(index);
                                      },
                                      child: SvgPicture.asset(Drawables.close)),) : ((controller.images[index] == null)) ? Positioned(
                                  right: 20,
                                  top :20,
                                  child: GestureDetector(
                                      onTap: (){
                                        removeImage(index);
                                      },
                                      child: SvgPicture.asset(Drawables.close)),) : Positioned(
                                  right: 20,
                                  top :20,
                                  child: GestureDetector(
                                      onTap: (){
                                        removeImage(index);
                                      },
                                      child: SvgPicture.asset(Drawables.close)),),),

                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            GestureDetector(
                              onTap: (){
                                if(controller.documentList!.length == 1){
                                  CommonUtils.getIntance().toastMessage(AppText.atleast_one_document_must_be_available);
                                } else{
                                  if(controller.documentList![index].id != 0) {
                                    controller.deletedDocumentsList.add(controller.documentList![index].id.toString());
                                  }
                                  controller.textfieldControllers.removeAt(index);
                                  controller.images.removeAt(index);
                                  controller.documentList?.removeAt(index);
                                  controller.documentList!.refresh();
                                }
                              },
                              child:   Padding(
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(AppText.remove_lower,style: TextStyle(
                                          fontSize: 16.sp,
                                          fontFamily: Fonts.PoppinsRegular,
                                          color: Clr.redDark),)
                                    ],),
                                ),
                              ),
                            ),

                            SizedBox(
                              height: 10.h,
                            ),
                            (controller.textfieldControllers.length - 1 == index) ? SizedBox() : Container(
                              height: 10.h,
                              color: Clr.colorF5F5F5,
                            )
                          ],);
                        },),),

                      SizedBox(height: 10.h,),

                      GestureDetector(
                        onTap: (){
                          if(controller.isAdd.value){
                            //controller.addTextField();
                            controller.addMoreDocuments();
                          }else{
                            controller.addMoreDocuments();
                          }

                        },
                        child:   Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                              SvgPicture.asset(Drawables.add),
                              Text(AppText.add_more,style: TextStyle(
                                  fontSize: 16.sp,
                                  fontFamily: Fonts.PoppinsRegular,
                                  color: Clr.color2020f2),)
                            ],),
                          ),
                        ),
                      ),

                      SizedBox(height: 40.h,),

                    ],),

                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void removeImage(int index){
    controller.images[index] = null;
    controller.documentList!.value[index].fileUrl = "";
  }



  @override
  Widget? bottomNavigationBar(BuildContext context) {
    return   Container(
      width: double.infinity,
      height: 45.h,
      margin: EdgeInsets.all(15),
      child: ElevatedButton(
        onPressed: () {
         // controller.getSavedData();
          controller.addUpdateDocumentService();
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Clr.appColor),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),),
        ),
        child: Text(AppText.save_changes.toUpperCase(),style:  TextStyle(fontSize: 16.sp,color: Clr.white,fontFamily: Fonts.PoppinsMedium),),
      ),
    );
  }

  void chooseFileOption(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding:  EdgeInsets.all(20.0),
          width: MediaQuery.of(context).size.width,
          child: Wrap(  // Wrap allows dynamic height adjustment
            children: [
             Center(
               child: Column(
                 children: [
                 SizedBox(height: 10),
                 ElevatedButton(
                   onPressed: () {
                     controller.pickImage(index);
                     Get.back();
                   },
                   child: Text(AppText.select_image),
                 ),
                 SizedBox(height: 10),
                 ElevatedButton(
                   onPressed: () {
                     controller.pickPdf(index);
                     Get.back();
                   },
                   child: Text(AppText.select_pdf),
                 ),
               ],),
             )
            ],
          ),
        );
      },
    );
  }


}
