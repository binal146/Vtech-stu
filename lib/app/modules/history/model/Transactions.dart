class Transactions {
  String? transactionId;
  String? bookingNumber;
  String? bookingSlotNumber;
  String? amount;
  String? studentName;
  String? studentProfile;
  String? subjectTitle;
  String? paymentStatus;
  Null? paymentMethod;
  Null? stripePaymentId;
  String? transactionAt;
  String? sessionDate;
  String? time;
  bool isRefund = false;

  Transactions(
      {this.transactionId,
      this.bookingNumber,
      this.bookingSlotNumber,
      this.amount,
      this.studentName,
      this.studentProfile,
      this.subjectTitle,
      this.paymentStatus,
      this.paymentMethod,
      this.stripePaymentId,
      this.transactionAt,
      this.sessionDate,
      this.time});

  Transactions.fromJson(Map<String, dynamic> json) {
    transactionId = json['transaction_id'];
    bookingNumber = json['booking_number'];
    bookingSlotNumber = json['booking_slot_number'];
    amount = json['amount'];
    studentName = json['student_name'];
    studentProfile = json['student_profile'];
    subjectTitle = json['subject_title'];
    paymentStatus = json['payment_status'];
    paymentMethod = json['payment_method'];
    stripePaymentId = json['stripe_payment_id'];
    transactionAt = json['transactionAt'];
    sessionDate = json['session_date'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['transaction_id'] = this.transactionId;
    data['booking_number'] = this.bookingNumber;
    data['booking_slot_number'] = this.bookingSlotNumber;
    data['amount'] = this.amount;
    data['student_name'] = this.studentName;
    data['student_profile'] = this.studentProfile;
    data['subject_title'] = this.subjectTitle;
    data['payment_status'] = this.paymentStatus;
    data['payment_method'] = this.paymentMethod;
    data['stripe_payment_id'] = this.stripePaymentId;
    data['transactionAt'] = this.transactionAt;
    data['session_date'] = this.sessionDate;
    data['time'] = this.time;
    return data;
  }
}