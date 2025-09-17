import 'AvailableSlotData.dart';

class AvailableSlotsModel {
  String? responseMsg;
  bool? success;
  AvailableSlotData? data;

  AvailableSlotsModel({this.responseMsg, this.success, this.data});

  AvailableSlotsModel.fromJson(Map<String, dynamic> json) {
    responseMsg = json['response_msg'];
    success = json['success'];
    data = json['data'] != null ? new AvailableSlotData.fromJson(json['data']) : null;
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