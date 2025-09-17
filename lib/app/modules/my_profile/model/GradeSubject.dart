import 'package:vteach_teacher/app/modules/my_profile/model/Subject.dart';

class GradeSubject {
  int? id;
  String? grade;
  List<Subject>? subject;

  GradeSubject({this.id, this.grade, this.subject});

  GradeSubject.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    grade = json['grade'];
    if (json['subjects'] != null) {
      subject = <Subject>[];
      json['subjects'].forEach((v) {
        subject!.add(new Subject.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['grade'] = this.grade;
    if (this.subject != null) {
      data['subjects'] = this.subject!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
