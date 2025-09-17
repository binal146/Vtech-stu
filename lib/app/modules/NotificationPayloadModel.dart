class NotificationPayloadModel {

  String? booking_id;
  String? booking_unique_id;
  String? subject_title;
  String? profile_image;
  String? full_name;
  String? email;
  String? country_code;
  String? mobile_number;
  String? notification_type;
  String? custom;
  String? title;
  String? body;
  String? booking_slot_id;
  String? channel_id;
  String? app_unique_call_id;
  String? sound;
  String? agoratoken;
  String? student_uid;
  String? agoraAppId;
  String? teacher_id;
  String? student_id;

  NotificationPayloadModel(
      {this.booking_id,
      this.booking_unique_id,
      this.subject_title,
      this.profile_image,
      this.full_name,
      this.email,
      this.country_code,
      this.mobile_number,
      this.custom,
      this.title,
      this.body,
      this.channel_id,
      this.booking_slot_id,
      this.app_unique_call_id,
      this.agoratoken,
      this.student_uid,
      this.sound,
      this.agoraAppId,
      this.notification_type,
      this.teacher_id,
      this.student_id,
      });

  NotificationPayloadModel.fromJson(Map<String, dynamic> json) {
    booking_id = json['booking_id'];
    booking_unique_id = json['booking_unique_id'];
    subject_title = json['subject_title'];
    profile_image = json['profile_image'];
    full_name = json['full_name'];
    email = json['email'];
    country_code = json['country_code'];
    mobile_number = json['mobile_number'];
    notification_type = json['notification_type'];
    custom = json['custom'];
    title = json['title'];
    body = json['body'];
    booking_slot_id = json['booking_slot_id'];
    channel_id = json['channel_id'];
    app_unique_call_id = json['app_unique_call_id'];
    sound = json['sound'];
    agoratoken = json['agoratoken'];
    student_uid = json['student_uid'];
    agoraAppId = json['agoraAppId'];
    teacher_id = json['teacher_id'];
    student_id = json['student_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['booking_id'] = booking_id;
    data['booking_unique_id'] = booking_unique_id;
    data['subject_title'] = subject_title;
    data['profile_image'] = profile_image;
    data['full_name'] = full_name;
    data['email'] = email;
    data['country_code'] = country_code;
    data['mobile_number'] = mobile_number;
    data['notification_type'] = notification_type;
    data['custom'] = custom;
    data['title'] = title;
    data['body'] = body;
    data['booking_slot_id'] = booking_slot_id;
    data['channel_id'] = channel_id;
    data['app_unique_call_id'] = app_unique_call_id;
    data['sound'] = sound;
    data['agoratoken'] = agoratoken;
    data['student_uid'] = student_uid;
    data['agoraAppId'] = agoraAppId;
    data['student_id'] = student_id;
    data['teacher_id'] = teacher_id;
    return data;
  }
}
