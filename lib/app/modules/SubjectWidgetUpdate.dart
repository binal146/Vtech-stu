import 'package:flutter/material.dart';
import 'package:vteach_teacher/app/CustomExpandableWidgetUpdate.dart';
import 'edit_profile/model/SubjectDataUpdate.dart';

class SubjectWidgetUpdate extends StatelessWidget {

  final SubjectDataUpdate subject;
  final List<SubjectDataUpdate> subjects;
   int index;
   bool isExpanded;
   int mainIndex;

  SubjectWidgetUpdate({required this.subject,required this.index,required this.isExpanded,required this.mainIndex,required this.subjects});

  @override
  Widget build(BuildContext context) {
    return CustomExpandableWidgetUpdate(
      subject: subject,
      isExpanded: isExpanded,
      mainIndex: mainIndex,
      subjects: subjects,
      children: subject.children.map((child) {
        return SubjectWidgetUpdate(subject: child,index: index,isExpanded: isExpanded,mainIndex: mainIndex,subjects: subjects,);
      }).toList(),
    );
  }
}