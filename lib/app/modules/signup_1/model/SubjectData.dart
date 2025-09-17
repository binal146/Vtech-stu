import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';

class SubjectData {
  int? id;
  String? subject;
  String? created_at;
  RxBool? isSelect = false.obs;


  SubjectData({this.id, this.subject,this.created_at});

  SubjectData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    subject = json['subject'];
    created_at = json['created_at'];
    if(json['is_selected'] != null) {
      isSelect!.value = json['is_selected'];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['subject'] = this.subject;
    data['created_at'] = this.created_at;
    data['is_selected'] = this.isSelect;
    return data;
  }
}

/*
class Subjects {
  int? id;
  String? subject;
  String? createdAt;
  RxBool? isSelect = false.obs;

  Subjects({this.id, this.subject, this.createdAt});

  Subjects.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    subject = json['subject'];
    createdAt = json['created_at'];
    if(json['is_selected'] != null) {
      isSelect!.value = json['is_selected'];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['subject'] = this.subject;
    data['created_at'] = this.createdAt;
    data['is_selected'] = this.isSelect;
    return data;
  }
}*/
