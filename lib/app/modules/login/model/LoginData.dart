class LoginData {

  int? userId;
  String? userType;
  String? fullName;
  String? profileImage;
  int? profile_approved_app;
  int? slot_availability;
  String? mobileNumber;
  String? email;
  int? isEmailVerified;
  String? emailVerifiedAt;
  int? status;
  String? createdAt;
  String? token;
  int? notification_status;

  LoginData(
      {this.userId,
        this.userType,
        this.fullName,
        this.profileImage,
        this.profile_approved_app,
        this.slot_availability,
        this.mobileNumber,
        this.email,
        this.isEmailVerified,
        this.emailVerifiedAt,
        this.status,
        this.createdAt,
        this.notification_status,
        this.token});

  LoginData.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    userType = json['user_type'];
    fullName = json['full_name'];
    profileImage = json['profile_image'];
    profile_approved_app = json['profile_approved_app'];
    slot_availability = json['slot_availability'];
    mobileNumber = json['mobile_number'];
    email = json['email'];
    isEmailVerified = json['is_email_verified'];
    emailVerifiedAt = json['email_verified_at'];
    status = json['status'];
    createdAt = json['created_at'];
    token = json['token'];
    notification_status = json['notification_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['user_type'] = this.userType;
    data['full_name'] = this.fullName;
    data['profile_image'] = this.profileImage;
    data['profile_approved_app'] = this.profile_approved_app;
    data['slot_availability'] = this.slot_availability;
    data['mobile_number'] = this.mobileNumber;
    data['email'] = this.email;
    data['is_email_verified'] = this.isEmailVerified;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['token'] = this.token;
    data['notification_status'] = this.notification_status;
    return data;
  }
}