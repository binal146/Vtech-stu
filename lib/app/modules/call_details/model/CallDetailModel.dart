import 'CallDetails.dart';

class CallDetailModel {
  String? responseMsg;
  bool? success;
  List<CallDetails>? callDetails;

  CallDetailModel({this.responseMsg, this.success, this.callDetails});

  CallDetailModel.fromJson(Map<String, dynamic> json) {
    responseMsg = json['response_msg'];
    success = json['success'];
    if (json['data'] != null) {
      callDetails = <CallDetails>[];
      json['data'].forEach((v) {
        callDetails!.add(new CallDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['response_msg'] = this.responseMsg;
    data['success'] = this.success;
    if (this.callDetails != null) {
      data['data'] = this.callDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}