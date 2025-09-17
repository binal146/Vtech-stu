import 'package:flutter/material.dart';
import 'package:vteach_teacher/app/CustomExpandableWidget.dart';
import 'package:vteach_teacher/app/modules/signup_1/model/SubjectDataNew.dart';

class SubjectWidget extends StatelessWidget {
  final SubjectDataNew subject;
  final List<SubjectDataNew> subjects;
   int index;
   bool isExpanded;
   int mainIndex;

  SubjectWidget({required this.subject,required this.index,required this.isExpanded,required this.mainIndex,required this.subjects});

  @override
  Widget build(BuildContext context) {
    return CustomExpandableWidget(
      subject: subject,
      isExpanded: isExpanded,
      mainIndex: mainIndex,
      subjects: subjects,
      children: subject.children.map((child) {
        return SubjectWidget(subject: child,index: index,isExpanded: isExpanded,mainIndex: mainIndex,subjects: subjects,);
      }).toList(),
    );
  }
}