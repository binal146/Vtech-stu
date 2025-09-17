
import 'package:get/get.dart';
import 'package:vteach_teacher/app/modules/edit_profile/model/SubjectDataUpdate.dart';
import 'package:vteach_teacher/app/modules/signup_1/model/GradesData.dart';
import 'package:vteach_teacher/app/modules/signup_1/model/SubjectData.dart';
import 'package:vteach_teacher/app/modules/signup_1/model/SubjectDataNew.dart';

class GradeSubjectModelUpdated {


  RxList<GradesData> selectedGrades = <GradesData>[].obs;

  RxList<SubjectDataUpdate> selectedSubjects = <SubjectDataUpdate>[].obs;
  RxList<SubjectDataUpdate> tempSelectedSubjects = <SubjectDataUpdate>[].obs;

  RxList<SubjectDataUpdate> subjects = <SubjectDataUpdate>[].obs;
  RxList<SubjectDataUpdate> tempSubjects = <SubjectDataUpdate>[].obs;

  String jsonValue = "";

  String tempSelectedJson = "";


  RxList<SubjectDataUpdate> duplicateSubjects = <SubjectDataUpdate>[].obs;

  GradeSubjectModelUpdated({required this.selectedGrades, required this.selectedSubjects,required this.subjects});

}