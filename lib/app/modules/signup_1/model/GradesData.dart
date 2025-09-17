
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class GradesData {
  int? id;
  String? grade;
  String? createdAt;
  RxBool? isSelect;

  GradesData({this.id, this.grade, this.createdAt});

  GradesData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    grade = json['grade'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['grade'] = this.grade;
    data['created_at'] = this.createdAt;
    return data;
  }
}