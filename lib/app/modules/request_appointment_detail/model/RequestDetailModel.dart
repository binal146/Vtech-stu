import 'package:vteach_teacher/app/modules/request_appointment_detail/model/RequestDetailData.dart';

class RequestDetailModel {
  String? responseMsg;
  bool? success;
  RequestDetailData? data;

  RequestDetailModel({this.responseMsg, this.success, this.data});

  RequestDetailModel.fromJson(Map<String, dynamic> json) {
    responseMsg = json['response_msg'];
    success = json['success'];
    data = json['data'] != null ? new RequestDetailData.fromJson(json['data']) : null;
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