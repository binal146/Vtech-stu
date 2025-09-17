
class Grade {
  int? id;
  String? grade;

  Grade({this.id, this.grade});

  Grade.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    grade = json['grade'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['grade'] = this.grade;
    return data;
  }
}
