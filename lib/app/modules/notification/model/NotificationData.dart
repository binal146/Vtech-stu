class NotificationData {
  int? id;
  int? toUserId;
  String? notificationType;
  String? bookingStatus;
  String? title;
  String? message;
  int? bookingId;
  int? bookingSlotId;
  String? status;
  int? isRead;
  String? createdAt;

  NotificationData(
      {this.id,
      this.toUserId,
      this.notificationType,
      this.bookingStatus,
      this.title,
      this.message,
      this.bookingId,
      this.bookingSlotId,
      this.status,
      this.isRead,
      this.createdAt});

  NotificationData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    toUserId = json['to_user_id'];
    notificationType = json['notification_type'];
    bookingStatus = json['booking_status'];
    title = json['title'];
    message = json['message'];
    bookingId = json['booking_id'];
    bookingSlotId = json['booking_slot_id'];
    status = json['status'];
    isRead = json['is_read'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['to_user_id'] = this.toUserId;
    data['notification_type'] = this.notificationType;
    data['booking_status'] = this.bookingStatus;
    data['title'] = this.title;
    data['message'] = this.message;
    data['booking_id'] = this.bookingId;
    data['booking_slot_id'] = this.bookingSlotId;
    data['status'] = this.status;
    data['is_read'] = this.isRead;
    data['createdAt'] = this.createdAt;
    return data;
  }
}