
import 'package:get/get.dart';
import 'package:vteach_teacher/app/modules/signup_1/model/GradesData.dart';
import 'package:vteach_teacher/app/modules/signup_1/model/SubjectData.dart';
import 'package:vteach_teacher/app/modules/signup_1/model/SubjectDataNew.dart';

class GradeSubjectModel {

  RxList<GradesData> selectedGrades = <GradesData>[].obs;

  RxList<SubjectData> selectedSubjects = <SubjectData>[].obs;

  RxList<SubjectData> subjects = <SubjectData>[].obs;

  GradeSubjectModel({required this.selectedGrades, required this.selectedSubjects,required this.subjects});


}