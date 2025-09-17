import 'package:get/get_rx/src/rx_types/rx_types.dart';

import 'User.dart';

class MessageModel {
  String? responseMsg;
  bool? success;
  String? id;
  RxString? message=RxString('');
  User? sender;
  User? receiver;
  String? messageType;
  RxString? lastMsgType=RxString('');
  int? isRead;
  RxInt unreadCount=RxInt(0);
  String? readedAt;
  RxString? createdAt=RxString('');
  String? currentDatetime;
  List<MessageModel>? data;
  MessageModel? messageDetails;
  String type = "";
  String? muteTime;

  MessageModel({this.responseMsg, this.success, this.data});

  MessageModel.fromJson(Map<String, dynamic> json) {
    responseMsg = json['response_msg'];
    success = json['success'];

    id = json['id'].toString();
    if(json.containsKey('message')){
      message?.value = json['message'];
    }



    if(json.containsKey('chat_message')){
      message?.value = json['chat_message'];
    }

    if (json['sender'] is String) {
     // sender = User.fromJson(JSON.jsonDecode(json['sender'].toString()));
    } else {
     // sender = json['sender'] != null ? User.fromJson(json['sender']) : null;
    }

    if (json['receive'] is String) {
    //  receiver = User.fromJson(JSON.jsonDecode(json['receive'].toString()));
    } else {
      // receiver = json['receive'] != null ? User.fromJson(json['receive']) : null;
    }

    messageType = json['message_type'];
    if (json.containsKey('chat_message_type')) {
      messageType = json['chat_message_type'];
    }
    if (json.containsKey('last_msg_type')) {
      lastMsgType?.value = json['last_msg_type'];
    }


    isRead = json['is_read'];
    if(json.containsKey('unread_count')){
      unreadCount.value = json['unread_count'];
    }

    readedAt = json['readed_at'];
    if(json.containsKey('created_at')){
      createdAt?.value = json['created_at'];
    }

    currentDatetime = json['current_datetime'];

    if (json['data'] != null && json['data'] is List<dynamic>) {
      data = <MessageModel>[];
      json['data'].forEach((v) {
        data!.add(MessageModel.fromJson(v));
      });
    } else {
      messageDetails =
      json['data'] != null ? MessageModel.fromJson(json['data']) : null;
    }

    muteTime = json['mute_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['response_msg'] = responseMsg;
    data['success'] = success;

    data['id'] = id;
    data['message'] = message?.value;
   /* if (sender != null) {
      data['sender'] = sender!.toJson();
    }
    if (receiver != null) {
      data['receive'] = receiver!.toJson();
    }*/
    data['message_type'] = messageType;
    data['last_msg_type'] = lastMsgType?.value;
    data['is_read'] = isRead;
    data['unread_count'] = unreadCount.value;
  
    data['readed_at'] = readedAt;
    data['created_at'] = createdAt?.value;

    data['current_datetime'] = currentDatetime;

    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['mute_time'] = muteTime;
    return data;
  }
}

class AllMessageModel {
  late final String date;
  late final List<MessageModel> messages;

  AllMessageModel({required this.date, required this.messages});
}

