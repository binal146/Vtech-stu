
import 'package:get/get.dart';
import 'package:vteach_teacher/app/modules/signup_1/model/GradesData.dart';
import 'package:vteach_teacher/app/modules/signup_1/model/SubjectData.dart';
import 'package:vteach_teacher/app/modules/signup_1/model/SubjectDataNew.dart';

class GradeSubjectModelUpdate {


  RxList<GradesData> selectedGrades = <GradesData>[].obs;

  RxList<SubjectDataNew> selectedSubjects = <SubjectDataNew>[].obs;

  RxList<SubjectDataNew> tempSelectedSubjects = <SubjectDataNew>[].obs;

  RxList<SubjectDataNew> subjects = <SubjectDataNew>[].obs;

  RxList<SubjectDataNew> tempSubjects = <SubjectDataNew>[].obs;

  RxList<SubjectDataNew> duplicateSubjects = <SubjectDataNew>[].obs;

  String jsonValue = "";
  String tempSelectedJson = "";

  GradeSubjectModelUpdate({required this.selectedGrades, required this.selectedSubjects,required this.tempSelectedSubjects,required this.subjects});


}