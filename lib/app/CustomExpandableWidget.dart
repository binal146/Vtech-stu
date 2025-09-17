import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:vteach_teacher/app/modules/signup_1/signup1_controller.dart';
import 'core/utils/colour.dart';
import 'core/utils/fonts.dart';
import 'core/utils/image.dart';
import 'modules/signup_1/model/SubjectDataNew.dart';

class CustomExpandableWidget extends StatefulWidget {

  final List<Widget> children;
  final SubjectDataNew subject;
  final List<SubjectDataNew> subjects;
   bool isExpanded;
   int mainIndex;

  CustomExpandableWidget({
    required this.subject,
    required this.children,
    required this.isExpanded,
    required this.mainIndex,
    required this.subjects,
  });

  @override
  _CustomExpandableWidgetState createState() => _CustomExpandableWidgetState();
}

class _CustomExpandableWidgetState extends State<CustomExpandableWidget> {

  final SignUp1Controller controller = Get.put(SignUp1Controller(), permanent: false);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              widget.isExpanded = !widget.isExpanded;
            });
          },
          child: Container(
            padding: EdgeInsets.all(16.0),
            color: Clr.white,
            child: Column(
              children: [
                Row(
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap:(){
                           // widget.subject.toggleChildSelection(widget.subject, !widget.subject.isSelect.value, widget.subjects);
                            widget.subject.isSelect.value = !widget.subject.isSelect.value;
                            printSubjects(widget.subject.children,widget.subject.isSelect.value);
                            controller.gradesSubjectsList[widget.mainIndex].tempSelectedSubjects.clear();
                            getSelectedSubjectList(controller.gradesSubjectsList[widget.mainIndex].tempSubjects,widget.mainIndex);
                            //getSelectedSubjectList(controller.gradesSubjectsList[widget.mainIndex].subjects,widget.mainIndex);
                            },
                            child: Obx(() => (widget.subject.isSelect.value) ? SvgPicture.asset(Drawables.tick_enable) :  SvgPicture.asset(Drawables.tick_disable)),),
                        SizedBox(width: 5,),
                        Obx(() => GestureDetector(
                          onTap: (){
                            //widget.subject.toggleChildSelection(widget.subject, !widget.subject.isSelect.value, widget.subjects);
                            widget.subject.isSelect.value = !widget.subject.isSelect.value;
                            printSubjects(widget.subject.children,widget.subject.isSelect.value);
                            controller.gradesSubjectsList[widget.mainIndex].tempSelectedSubjects.clear();
                            getSelectedSubjectList(controller.gradesSubjectsList[widget.mainIndex].tempSubjects,widget.mainIndex);
                           // getSelectedSubjectList(controller.gradesSubjectsList[widget.mainIndex].subjects,widget.mainIndex);
                          },
                          child: Text(
                            widget.subject.subject,
                            style: TextStyle(fontSize: 14.sp,color: (widget.subject.isSelect.value) ? Clr.color2020f2 : Clr.blackColor,fontFamily: Fonts.PoppinsMedium),
                          ),
                        ),),
                      ],
                    ),
                    Expanded(child: GestureDetector(
                      onTap: (){
                        setState(() {
                          widget.isExpanded = !widget.isExpanded;
                        });
                      },
                        child: Container(color: Colors.transparent,))),
                    (widget.children.isNotEmpty) ? Icon(
                      widget.isExpanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                    ) : SizedBox(),
                  ],
                ),
                Divider(color: Clr.greyColor,)
              ],
            ),
          ),
        ),
        if (widget.isExpanded)
          Padding(
            padding:  EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: widget.children,
            ),
          ),
      ],
    );
  }

  void printSubjects(List<SubjectDataNew> subjects, bool isParentSelect, {int level = 0}) {
    for (var subject in subjects) {
      print('${'  ' * level}${subject.subject}');
      if(isParentSelect){
        subject.isSelect.value = true;
      }else{
        subject.isSelect.value = false;
      }

      if (subject.children.isNotEmpty) {
        printSubjects(subject.children,widget.subject.isSelect.value, level: level + 1);
      }
    }
  }

  void getSelectedSubjectList(List<SubjectDataNew> subjects,int mainIndex) {
    for (var subject in subjects) {
      // print("DDDDDDDDDDDDDDDD--> "+subject.subject.toString());
      // print("DDDDDDDDDDDDDDDD--> "+subject.isSelect.toString());
      if(subject.isSelect.value){
        controller.gradesSubjectsList[mainIndex].tempSelectedSubjects.add(subject);
      }
      if (subject.children.isNotEmpty) {
        getSelectedSubjectList(subject.children,mainIndex);
      }
    }
  }

}
