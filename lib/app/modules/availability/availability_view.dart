import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:vteach_teacher/app/core/utils/common_widgets.dart';
import '../../../time_picker_widget.dart';
import '../../core/utils/colour.dart';
import '../../core/utils/fonts.dart';
import '../../core/utils/keyboard_types.dart';
import '../../core/values/comman_text.dart';
import '../../core/values/text_styles.dart';
import '../../core/widget/comman_textfield.dart';
import '/app/core/base/base_view.dart';
import 'availability_controller.dart';


class AvailabilityView extends BaseView<AvailablityController> {

  AvailabilityView({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return null;
  }

  @override
  Widget body(BuildContext context) {
    return (controller.screen == "1")
        ? Obx(() =>
    (!controller.isDataLoaded.value) ? SizedBox() : mainView(context),)
        : mainView(context);
  }

  Column mainView(BuildContext context) {
    return Column(
      children: [
        Container(height: 40.h,
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Row(children: [
            InkWell(
              onTap: () {
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
            Text((controller.screen == "0") ? AppText.set_availablity : AppText
                .change_availability.toUpperCase(),
              style: appBarTitle,
              textAlign: TextAlign.center,
            )
          ],),),
        Expanded(
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Obx(() =>
                      SfDateRangePicker(
                        enablePastDates: false,
                        initialSelectedDate: (controller.initialSelectedDate!
                            .value.isNotEmpty) ? DateTime.parse(
                            controller.initialSelectedDate!.value) : null,
                        onSelectionChanged: onSelectionChanged,
                        selectionMode: (controller.screen == "0")
                            ? DateRangePickerSelectionMode.range
                            : DateRangePickerSelectionMode.single,
                        backgroundColor: Clr.white,
                        selectionColor: Clr.blackColor,
                        startRangeSelectionColor: Clr.blackColor,
                        endRangeSelectionColor: Clr.blackColor,
                        rangeSelectionColor: Clr.colorDFEFFC,
                        todayHighlightColor: Clr.blackColor,
                        showNavigationArrow: true,
                        selectionTextStyle: TextStyle(color: Clr.white,
                            fontSize: 12.sp,
                            fontFamily: Fonts.PoppinsRegular),
                        view: DateRangePickerView.month,
                        headerHeight: MediaQuery
                            .of(context)
                            .size
                            .width * 0.20,
                        rangeTextStyle: TextStyle(color: Clr.blackColor,
                            fontSize: 12.sp,
                            fontFamily: Fonts.PoppinsRegular),
                        monthCellStyle: DateRangePickerMonthCellStyle(
                          textStyle: TextStyle(color: Clr.black,
                              fontFamily: Fonts.PoppinsRegular,
                              fontSize: 12.sp),
                          cellDecoration: BoxDecoration(
                            color: Clr.colorDFEFFC,
                            shape: BoxShape.circle,
                          ),
                          todayCellDecoration: BoxDecoration(
                              color: Clr.appColor,
                              shape: BoxShape.circle
                          ),
                          todayTextStyle: TextStyle(color: Clr.blackColor,
                              fontFamily: Fonts.PoppinsRegular,
                              fontSize: 12.sp),
                          specialDatesDecoration: BoxDecoration(
                              color: Clr.green,
                              shape: BoxShape.circle),

                        ),
                        headerStyle: DateRangePickerHeaderStyle(
                            backgroundColor: Clr.white,
                            textAlign: TextAlign.left,
                            textStyle: TextStyle(
                              fontStyle: FontStyle.normal,
                              fontSize: 20.sp,
                              fontFamily: Fonts.PoppinsSemiBold,
                              color: Clr.blackColor,
                            )),
                        monthViewSettings: DateRangePickerMonthViewSettings(
                            firstDayOfWeek: 1,
                            viewHeaderStyle: DateRangePickerViewHeaderStyle(
                                backgroundColor: Clr.white,
                                textStyle: TextStyle(
                                  fontStyle: FontStyle.normal,
                                  fontSize: 14.sp,
                                  letterSpacing: 5,
                                  fontFamily: Fonts.PoppinsSemiBold,
                                  color: Clr.blackColor,
                                )),
                            specialDates: controller.availableDateList),

                      ),),

                  SizedBox(height: 10.h,),

                  Obx(() => Text(controller.timezoneText.value,
                    style: TextStyle(
                        fontSize: 12.sp,
                        color: Clr.redColor,
                        fontFamily: Fonts.PoppinsMedium),),),

                  SizedBox(height: 10.h,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(AppText.available_timeslots,
                        style: blackPoppinsMedium16,),

                      /*  Row(
                      children: [
                        Text(
                          'Date range',
                          style: blackPoppinsRegular12,
                        ),
                        Obx(() => Switch(
                          activeColor: Clr.appColor,
                          value: controller.isRangeSelected.value,
                          onChanged: toggleSwitch,
                        ),),
                      ],
                    )*/


                    ],
                  ),

                  SizedBox(height: 10.h,),

                  DottedBorder(
                    color: Clr.borderColor,
                    strokeWidth: 1,
                    radius: Radius.circular(10),
                    borderType: BorderType.RRect,
                    dashPattern: [4, 2],
                    child: Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      padding: EdgeInsets.all(5),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [

                          Text(AppText.set_start_and_end_time,
                            style: blackPoppinsRegular12,),

                          SizedBox(height: 10,),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Obx(() =>
                                  Row(
                                    children: [
                                      Text(AppText.start_time,
                                        style: blackPoppinsRegular12,),

                                      SizedBox(width: 5.w,),

                                      GestureDetector(
                                        onTap: () {
                                          print("Start time "+controller.start_time.value.toString());
                                          print("End time "+controller.end_time.value.toString());
                                          selectTime(context, true);
                                         // openViewTimeListDialog(context);
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(3.sp),
                                          decoration: BoxDecoration(
                                            color: Clr.white,
                                            border: Border.all(
                                                color: Clr.borderColor),
                                            borderRadius: BorderRadius.circular(15.sp),
                                          ),
                                          child: Row(
                                            children: [
                                              Text(getHourPart(controller
                                                  .convert24HourTo12Hour(
                                                  controller.start_time.value,
                                                  true)),
                                                style: blackPoppinsRegular14,),
                                              SizedBox(width: 5.w,),
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: Clr.blackColor,
                                                  borderRadius: BorderRadius
                                                      .circular(10.sp),
                                                ),
                                                padding: EdgeInsets.all(2.sp),
                                                child: Text(
                                                  controller.start_time_am
                                                      .value, style: TextStyle(
                                                    fontSize: 12.sp,
                                                    color: Clr.white,
                                                    fontFamily: Fonts
                                                        .PoppinsMedium),),
                                              )
                                            ],
                                          ),
                                        ),
                                      )

                                    ],
                                  ),),

                              Obx(() =>
                                  Row(
                                    children: [
                                      Text(AppText.end_time,
                                        style: blackPoppinsRegular12,),

                                      SizedBox(width: 5.sp,),

                                      GestureDetector(
                                        onTap: () {
                                           selectTime(context, false);
                                         // openViewTimeListDialog(context);
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(3.sp),
                                          decoration: BoxDecoration(
                                            color: Clr.white,
                                            border: Border.all(
                                                color: Clr.borderColor),
                                            borderRadius: BorderRadius.circular(15.sp),
                                          ),
                                          child: Row(
                                            children: [
                                              Text(getHourPart(controller
                                                  .convert24HourTo12Hour(
                                                  controller.end_time.value,
                                                  false)),
                                                style: blackPoppinsRegular14,),
                                              SizedBox(width: 5.w,),
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: Clr.blackColor,
                                                  borderRadius: BorderRadius
                                                      .circular(10.sp),
                                                ),
                                                padding: EdgeInsets.all(2.sp),
                                                child: Text(
                                                  controller.end_time_pm.value,
                                                  style: TextStyle(
                                                      fontSize: 12.sp,
                                                      color: Clr.white,
                                                      fontFamily: Fonts
                                                          .PoppinsMedium),),
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),),
                            ],),

                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 10.h,),

                  Obx(() =>
                                    (controller.timeslotsList.isNotEmpty) ? GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 3,
                        ),
                        itemCount: controller.timeslotsList.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              if (controller.timeslotsList[index].isSelect!
                                  .value == true) {
                                controller.timeslotsList[index].isSelect!
                                    .value = false;
                                controller.timeslotsListTemp[index].isSelect!
                                    .value = false;
                              } else {
                                controller.timeslotsList[index].isSelect!
                                    .value = true;
                                controller.timeslotsListTemp[index].isSelect!
                                    .value = true;
                              }
                            },
                            child: Obx(() =>
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(14),
                                      color: (controller.timeslotsList[index]
                                          .isSelect!.value == true) ? Clr
                                          .blackColor : Clr.grey_bg
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 5),
                                  margin: EdgeInsets.only(
                                      top: 10, left: 5, right: 5),
                                  child: Center(
                                    child: Text(
                                        controller.timeslotsList[index].time.toString(),
                                        style: TextStyle(
                                        fontSize: 13.sp,
                                        color: (controller
                                            .timeslotsList[index].isSelect!
                                            .value == true) ? Clr.white : Clr
                                            .searchHintColor,
                                        fontFamily: Fonts.PoppinsMedium)),
                                  ),
                                ),),
                          );
                        },
                      ) : Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: Center(child: Text(controller.emptyMessage.value,style: blackPoppinsMedium14
                            ,)),
                      ),),

                  SizedBox(height: 30.h,),

/*                  Text(AppText.enter_rates, style: blackPoppinsMedium16,),

                  SizedBox(height: 10.h,),

                  CommanTextField(
                    hint: "",
                    label: AppText.rates,
                    keyboardType: KeyboardComman.NUMBER,
                    inputAction: KeyboardComman.DONE,
                    maxlines: 1,
                    prefixIcon: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Text("|", style: TextStyle(
                            fontSize: 20.sp, color: Clr.greyColor),)),
                    sufixIcon: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("/", style: TextStyle(
                                fontSize: 20.sp, color: Clr.greyColor),),
                            SizedBox(width: 5.w,),
                            Text("Hr", style: TextStyle(fontSize: 14.sp,
                                color: Clr.greyColor,
                                fontFamily: Fonts.PoppinsRegular),),
                          ],
                        )),

                    controller: controller.ratesController,
                  ),

                  SizedBox(height: 20.h,),*/

                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget? bottomNavigationBar(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 45.h,
      margin: EdgeInsets.all(15),
      child: ElevatedButton(
        onPressed: () {
          //Get.back(result: true);
          controller.callService();
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Clr.appColor),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),),
        ),
        child: Text(
          (controller.screen == "0") ? AppText.save : AppText.save_changes,
          style: TextStyle(fontSize: 16.sp,
              color: Clr.white,
              fontFamily: Fonts.PoppinsMedium),),
      ),
    );
  }

  Future<void> selectTimeOld(BuildContext context, bool isStartTime) async {
    TimeOfDay selectedTime = TimeOfDay(hour: (isStartTime == true)
        ? int.parse(controller.start_time.value)
        : int.parse(controller.end_time.value), minute: 0);

    final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: selectedTime,
    );
    if (picked != null && picked != selectedTime) {
      print("BBBBBB"+picked.hour.toString());
      if (isStartTime) {
        if (int.parse(picked.hour.toString()) >=
            int.parse(controller.end_time.value.toString())) {
          CommonUtils.getIntance().toastMessage(
              "start time should be less than end time");
        } else {
          controller.start_time.value = picked.hour.toString();
          controller.generateTimeslots(int.parse(controller.start_time.value),
              int.parse(controller.end_time.value));
        }
      } else {
        if (int.parse(picked.hour.toString()) <=
            int.parse(controller.start_time.value.toString())) {
          CommonUtils.getIntance().toastMessage(
              "end time should be greater than start time");
        } else {
          controller.end_time.value = picked.hour.toString();
          controller.generateTimeslots(int.parse(controller.start_time.value),
              int.parse(controller.end_time.value));
        }
      }
    }
  }

  Future<void> selectTime(BuildContext context, bool isStartTime) async {
    TimeOfDay selectedTime = TimeOfDay(hour: (isStartTime == true)
        ? int.parse(controller.start_time.value)
        : int.parse(controller.end_time.value), minute: 0);
    showCustomTimePicker(
        context: context,
        onFailValidation: (context) => print('Unavailable selection'),
        initialTime: selectedTime,
        selectableTimePredicate: (time) =>
        time!.hour != -1 && time.minute == 0).then(
      (time) {
        if(time != null) {
          String hour = controller.convertTo24HourFormat(time!.format(context).toString());
          if (isStartTime) {
            if (int.parse(hour.toString()) >= int.parse(controller.end_time.value.toString())) {
              CommonUtils.getIntance().toastMessage("start time should be less than end time");
            } else {
              controller.start_time.value = hour.toString();
              controller.generateTimeslots(int.parse(controller.start_time.value), int.parse(controller.end_time.value));
            }
          } else {
            if (int.parse(hour.toString()) <= int.parse(controller.start_time.value.toString())) {
              CommonUtils.getIntance().toastMessage("end time should be greater than start time");
            } else {
              controller.end_time.value = hour.toString();
              controller.generateTimeslots(int.parse(controller.start_time.value), int.parse(controller.end_time.value));
            }
          }
        }
      },

    );
  }

  void onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    if (controller.screen == "0") {
      // controller.startDate.value = DateFormat('yyyy-MM-dd').format(args.value.startDate);
      // controller.endDate.value = DateFormat('yyyy-MM-dd').format(args.value.endDate ?? args.value.startDate);
      controller.startDate.value = DateFormat('dd-MM-yyyy').format(args.value.startDate);
      controller.endDate.value = DateFormat('dd-MM-yyyy').format(args.value.endDate ?? args.value.startDate);
    } else {
      controller.singleDate.value = DateFormat('dd-MM-yyy').format(args.value);
      controller.callGetSlotsService(controller.singleDate.value);
    }
  }

  String getHourPart(String time12) {
    // Split the time string by space
    List<String> parts = time12.split(' ');

    // Return the first part (hour part)
    return parts[0];
  }

  bool isAm(String time12) {
    if (time12.contains('am')) {
      return true;
    }
    return false;
  }

  void toggleSwitch(bool value) {
    controller.isRangeSelected.value = value;
  }

  List<String> timeList = List<String>.generate(
      12, (index) => (index + 1).toString());

  void openViewTimeListDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.width * 0.50,
          child: Column(
            children: [
              SizedBox(height: 10,),
              Padding(
                padding: EdgeInsets.only(right: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: (){
                        controller.isAmSelected.value =  !controller.isAmSelected.value;
                      },
                      child: Obx(() => Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: (controller.isAmSelected.value) ? Clr.appColor : Clr.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text('AM',style: TextStyle(color: (controller.isAmSelected.value) ? Clr.white : Clr.black),)),),
                    ),
                    SizedBox(width: 10,),
                    GestureDetector(
                      onTap: (){
                        controller.isAmSelected.value =  !controller.isAmSelected.value;
                      },
                      child: Obx(() => Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: (controller.isAmSelected.value) ? Clr.white : Clr.appColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text('PM',style: TextStyle(color: (controller.isAmSelected.value) ? Clr.black : Clr.white),)),),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: timeList.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: EdgeInsets.all(10),
                      child: Center(child: Text(timeList[index].toString(),style: blackPoppinsRegular14,)),
                    );
                  },),
              ),
            ],
          ),
        );
      },
    );
  }

  void openViewTimeListDialogold(BuildContext context) {
  showDialog(context: context,
  barrierDismissible: true,
  builder: (BuildContext context) {
  return Dialog(
  child:SizedBox(
  width: MediaQuery.of(context).size.width * 0.20,
  height: MediaQuery.of(context).size.width * 0.50,
  child: ListView.builder(
  itemCount: timeList.length,
  itemBuilder: (context, index) {
  return Container(
  child: Center(child: Text(timeList[index].toString(),style: blackPoppinsRegular12,)),
  );
  },),
  ),
  );
  },
  );
  }


}
