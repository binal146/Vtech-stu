class PendingBookingdata {
  int? booking_id;
  String? booking_number;
  String? booking_at;
  String? booking_status;
  String? student_name;
  String? student_profile;
  String? grade_title;
  String? subject_title;

  PendingBookingdata(
      {this.booking_id,
      this.booking_number,
      this.booking_at,
      this.booking_status,
      this.student_name,
      this.student_profile,
      this.grade_title,
      this.subject_title,
      });

  PendingBookingdata.fromJson(Map<String, dynamic> json) {
    booking_id = json['booking_id'];
    booking_number = json['booking_number'];
    booking_at = json['booking_at'];
    booking_status = json['booking_status'];
    student_name = json['student_name'];
    student_profile = json['student_profile'];
    grade_title = json['grade_title'];
    subject_title = json['subject_title'];
     }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['booking_id'] = this.booking_id;
    data['booking_number'] = this.booking_number;
    data['booking_at'] = this.booking_at;
    data['booking_status'] = this.booking_status;
    data['student_name'] = this.student_name;
    data['student_profile'] = this.student_profile;
    data['grade_title'] = this.grade_title;
    data['subject_title'] = this.subject_title;
    return data;
  }
}
