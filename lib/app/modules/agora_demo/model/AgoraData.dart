class AgoraData {
  String? bookingId;
  String? bookingSlotId;
  String? bookingUniqueId;
  String? subjectTitle;
  String? profileImage;
  String? fullName;
  String? email;
  String? countryCode;
  String? mobileNumber;
  String? custom;
  String? channel_id;
  String? app_unique_call_id;
  String? agoratoken;
  int? teacherUid;
  int? studentUid;
  String? agoraAppId;

  AgoraData(
      {this.bookingId,
      this.bookingSlotId,
      this.bookingUniqueId,
      this.subjectTitle,
      this.profileImage,
      this.fullName,
      this.email,
      this.countryCode,
      this.mobileNumber,
      this.custom,
      this.channel_id,
      this.agoratoken,
      this.teacherUid,
      this.agoraAppId,
      this.studentUid});

  AgoraData.fromJson(Map<String, dynamic> json) {
    bookingId = json['booking_id'];
    bookingSlotId = json['booking_slot_id'];
    bookingUniqueId = json['booking_unique_id'];
    subjectTitle = json['subject_title'];
    profileImage = json['profile_image'];
    fullName = json['full_name'];
    email = json['email'];
    countryCode = json['country_code'];
    mobileNumber = json['mobile_number'];
    custom = json['custom'];
    channel_id = json['channel_id'];
    agoratoken = json['agoratoken'];
    teacherUid = json['teacher_uid'];
    studentUid = json['student_uid'];
    app_unique_call_id = json['app_unique_call_id'];
    agoraAppId = json['agoraAppId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['booking_id'] = this.bookingId;
    data['booking_slot_id'] = this.bookingSlotId;
    data['booking_unique_id'] = this.bookingUniqueId;
    data['subject_title'] = this.subjectTitle;
    data['profile_image'] = this.profileImage;
    data['full_name'] = this.fullName;
    data['email'] = this.email;
    data['country_code'] = this.countryCode;
    data['mobile_number'] = this.mobileNumber;
    data['custom'] = this.custom;
    data['channel_id'] = this.channel_id;
    data['agoratoken'] = this.agoratoken;
    data['teacher_uid'] = this.teacherUid;
    data['student_uid'] = this.studentUid;
    data['app_unique_call_id'] = this.app_unique_call_id;
    data['agoraAppId'] = this.agoraAppId;
    return data;
  }
}