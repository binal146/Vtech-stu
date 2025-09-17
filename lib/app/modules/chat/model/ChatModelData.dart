import 'package:get/get_rx/src/rx_types/rx_types.dart';

class ChatModelData {
  int? id;
  int? toUserId;
  int? fromUserId;
  int? bookingId;
  int? bookingSlotId;
  String? messageType;
  //RxString? message= RxString('');
  String? message;
  String? fileName;
  String? fileUrl;
  int? isRead;
  Null? readedAt;
  String? createdAt;
  String? updatedAt;
  Null? deletedAt;
  String? fileImagePath;
  String type = "";

  ChatModelData(
      {this.id,
      this.toUserId,
      this.fromUserId,
      this.bookingId,
      this.bookingSlotId,
      this.messageType,
      this.message,
      this.fileName,
      this.fileUrl,
      this.isRead,
      this.readedAt,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.fileImagePath});

  ChatModelData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    toUserId = json['to_user_id'];
    fromUserId = json['from_user_id'];
    bookingId = json['booking_id'];
    bookingSlotId = json['booking_slot_id'];
    messageType = json['message_type'];
    message = json['message'];
    fileName = json['file_name'];
    fileUrl = json['file_url'];
    isRead = json['is_read'];
    readedAt = json['readed_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    fileImagePath = json['file_image_path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['to_user_id'] = this.toUserId;
    data['from_user_id'] = this.fromUserId;
    data['booking_id'] = this.bookingId;
    data['booking_slot_id'] = this.bookingSlotId;
    data['message_type'] = this.messageType;
    data['message'] = this.message;
    data['file_name'] = this.fileName;
    data['file_url'] = this.fileUrl;
    data['is_read'] = this.isRead;
    data['readed_at'] = this.readedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['file_image_path'] = this.fileImagePath;
    return data;
  }
}