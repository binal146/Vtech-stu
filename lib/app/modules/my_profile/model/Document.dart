
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class Document {
  int? id;
  int? teacherId;
  String? title;
  String? fileName;
  String? fileUrl;
  String? file_type;

  Document({this.id, this.teacherId, this.title, this.fileName, this.fileUrl});

  Document.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    teacherId = json['teacher_id'];
    title = json['title'];
    fileName = json['file_name'];
    fileUrl = json['file_url'];
    file_type = json['file_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['teacher_id'] = this.teacherId;
    data['title'] = this.title;
    data['file_name'] = this.fileName;
    data['file_url'] = this.fileUrl;
    data['file_type'] = this.file_type;
    return data;
  }

  Document.copy(Document other) : id = other.id,teacherId = other.teacherId,title = other.title,fileName = other.fileName,fileUrl = other.fileUrl,file_type = other.file_type;
}