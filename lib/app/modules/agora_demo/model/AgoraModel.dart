import 'package:vteach_teacher/app/modules/agora_demo/model/AgoraData.dart';

class AgoraModel {
  String? responseMsg;
  bool? success;
  AgoraData? data;

  AgoraModel({this.responseMsg, this.success, this.data});

  AgoraModel.fromJson(Map<String, dynamic> json) {
    responseMsg = json['response_msg'];
    success = json['success'];
    data = json['data'] != null ? new AgoraData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['response_msg'] = this.responseMsg;
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}