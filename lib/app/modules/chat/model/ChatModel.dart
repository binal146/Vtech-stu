import 'ChatModelData.dart';

class ChatModel {
  String? responseMsg;
  String? date;
  String? time;
  bool? success;
  List<ChatModelData>? data;

  ChatModel({this.responseMsg, this.success, this.data});

  ChatModel.fromJson(Map<String, dynamic> json) {
    responseMsg = json['response_msg'];
    date = json['date'];
    time = json['time'];
    success = json['success'];
    if (json['data'] != null) {
      data = <ChatModelData>[];
      json['data'].forEach((v) {
        data!.add(new ChatModelData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['response_msg'] = this.responseMsg;
    data['date'] = this.date;
    data['time'] = this.time;
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}