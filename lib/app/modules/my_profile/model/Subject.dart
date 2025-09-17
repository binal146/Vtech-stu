class Subject {
  int? id;
  int? gradeId;
  String? subject;

  Subject({this.id, this.gradeId, this.subject});

  Subject.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    gradeId = json['grade_id'];
    subject = json['subject'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['grade_id'] = this.gradeId;
    data['subject'] = this.subject;
    return data;
  }
}
