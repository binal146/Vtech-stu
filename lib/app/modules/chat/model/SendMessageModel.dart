import 'ChatModelData.dart';

class SendMessageModel {
  String? responseMsg;
  bool? success;
  ChatModelData? data;

  SendMessageModel({this.responseMsg, this.success, this.data});

  SendMessageModel.fromJson(Map<String, dynamic> json) {
    responseMsg = json['response_msg'];
    success = json['success'];
    data = json['data'] != null ? new ChatModelData.fromJson(json['data']) : null;
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