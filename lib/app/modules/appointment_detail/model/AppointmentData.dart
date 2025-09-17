class AppointmentData {
  int? bookingId;
  int? bookingSlotId;
  String? bookingNumber;
  String? booking_slot_number;
  String? bookingAt;
  String? bookingStatus;
  String? cancel_by;
  String? studentName;
  int? student_id;
  String? studentProfile;
  String? gradeTitle;
  String? subjectTitle;
  String? date;
  String? time;
  String? instruction;
  String? amount;
  String? discount;
  String? payableAmount;
  String? validForStart;
  String? cancelReason;
  int? auto_cancel;
  String? paymentStatus;
  String? transactionId;
  String? rating;
  String? review;
  String? review_created_at;


  AppointmentData(
      {this.bookingId,
      this.bookingSlotId,
      this.bookingNumber,
      this.bookingAt,
      this.bookingStatus,
      this.cancel_by,
      this.studentName,
      this.student_id,
      this.studentProfile,
      this.gradeTitle,
      this.subjectTitle,
      this.date,
      this.time,
      this.instruction,
      this.amount,
      this.discount,
      this.payableAmount,
      this.validForStart,
      this.cancelReason,
      this.auto_cancel,
      this.paymentStatus,
      this.transactionId,
      this.rating,
      this.review,
      this.review_created_at,
      });

  AppointmentData.fromJson(Map<String, dynamic> json) {
    bookingId = json['booking_id'];
    bookingSlotId = json['booking_slot_id'];
    bookingNumber = json['booking_number'];
    booking_slot_number = json['booking_slot_number'];
    bookingAt = json['booking_at'];
    bookingStatus = json['booking_status'];
    cancel_by = json['cancel_by'];
    studentName = json['student_name'];
    student_id = json['student_id'];
    studentProfile = json['student_profile'];
    gradeTitle = json['grade_title'];
    subjectTitle = json['subject_title'];
    date = json['date'];
    time = json['time'];
    instruction = json['instruction'];
    amount = json['amount'];
    discount = json['discount'];
    payableAmount = json['payable_amount'];
    validForStart = json['valid_for_start'];
    cancelReason = json['cancel_reason'];
    paymentStatus = json['payment_status'];
    transactionId = json['transaction_id'];
    auto_cancel = json['auto_cancel'];
    rating = json['rating'];
    review = json['review'];
    review_created_at = json['review_created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['booking_id'] = this.bookingId;
    data['booking_slot_id'] = this.bookingSlotId;
    data['booking_number'] = this.bookingNumber;
    data['booking_slot_number'] = this.booking_slot_number;
    data['booking_at'] = this.bookingAt;
    data['booking_status'] = this.bookingStatus;
    data['cancel_by'] = this.cancel_by;
    data['student_name'] = this.studentName;
    data['student_id'] = this.student_id;
    data['student_profile'] = this.studentProfile;
    data['grade_title'] = this.gradeTitle;
    data['subject_title'] = this.subjectTitle;
    data['date'] = this.date;
    data['time'] = this.time;
    data['instruction'] = this.instruction;
    data['amount'] = this.amount;
    data['discount'] = this.discount;
    data['payable_amount'] = this.payableAmount;
    data['valid_for_start'] = this.validForStart;
    data['cancel_reason'] = this.cancelReason;
    data['payment_status'] = this.paymentStatus;
    data['transaction_id'] = this.transactionId;
    data['auto_cancel'] = this.auto_cancel;
    data['rating'] = this.rating;
    data['review'] = this.review;
    data['review_created_at'] = this.review_created_at;
    return data;
  }
}