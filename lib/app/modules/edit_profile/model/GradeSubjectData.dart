import 'SubjectDataUpdate.dart';

class GradeSubjectData {
  int? id;
  String? grade;
  List<SubjectDataUpdate>? subjects;

  GradeSubjectData({this.id, this.grade, this.subjects});

  GradeSubjectData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    grade = json['grade'];
    if (json['subjects'] != null) {
      subjects = <SubjectDataUpdate>[];
      json['subjects'].forEach((v) {
        subjects!.add(new SubjectDataUpdate.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['grade'] = this.grade;
    if (this.subjects != null) {
      data['subjects'] = this.subjects!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}