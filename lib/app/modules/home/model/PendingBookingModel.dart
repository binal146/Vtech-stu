import 'PendingBookingData.dart';

class PendingBookingModel {
  String? responseMsg;
  bool? success;
  List<PendingBookingdata>? data;

  PendingBookingModel({this.responseMsg, this.success, this.data});

  PendingBookingModel.fromJson(Map<String, dynamic> json) {
    responseMsg = json['response_msg'];
    success = json['success'];
    if (json['data'] != null) {
      data = <PendingBookingdata>[];
      json['data'].forEach((v) {
        data!.add(new PendingBookingdata.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['response_msg'] = this.responseMsg;
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}