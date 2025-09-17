import '../../availability/model/Timeslots.dart';
import 'BookedDays.dart';

class BookingData {
  int? booking_id;
  String? booking_number;
  String? booking_slot_number;
  int? booking_slot_id;
  int? studentId;
  int? teacherId;
  String? subjectId;
  String? subjectTitle;
  int? gradeId;
  String? gradeTitle;
  String? bookingStatus;
  String? cancel_by;
  String? amount;
  String? discount;
  String? payableAmount;
  String? instruction;
  String? cancelReason;
  int? auto_cancel;
  String? booking_at;
  String? updatedAt;
  Null? deletedAt;
  int? bookingSlotId;
  String? date;
  String? time;
  String? ratePerHour;
  String? studentName;
  String? studentProfile;
  String? paymentStatus;
  String? transactionId;
  String? startDate;
  String? endDate;
  String? valid_for_start;
  List<BookedDays>? bookedDays;

  BookingData(
      {this.booking_id,
      this.booking_number,
      this.booking_slot_number,
      this.studentId,
      this.teacherId,
      this.subjectId,
      this.subjectTitle,
      this.gradeId,
      this.gradeTitle,
      this.bookingStatus,
      this.cancel_by,
      this.amount,
      this.discount,
      this.payableAmount,
      this.instruction,
      this.cancelReason,
      this.auto_cancel,
      this.booking_at,
      this.updatedAt,
      this.deletedAt,
      this.bookingSlotId,
      this.date,
      this.time,
        this.startDate,
        this.endDate,
      this.ratePerHour,
      this.studentName,
      this.studentProfile,
      this.paymentStatus,
      this.transactionId,
      this.booking_slot_id,
      this.valid_for_start,
      this.bookedDays});

  BookingData.fromJson(Map<String, dynamic> json) {
    booking_id = json['booking_id'];
    booking_number = json['booking_number'];
    booking_slot_number = json['booking_slot_number'];
    studentId = json['student_id'];
    teacherId = json['teacher_id'];
    subjectId = json['subject_id'];
    subjectTitle = json['subject_title'];
    gradeId = json['grade_id'];
    gradeTitle = json['grade_title'];
    bookingStatus = json['booking_status'];
    cancel_by = json['cancel_by'];
    amount = json['amount'];
    discount = json['discount'];
    payableAmount = json['payable_amount'];
    instruction = json['instruction'];
    cancelReason = json['cancel_reason'];
    auto_cancel = json['auto_cancel'];
    booking_at = json['booking_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    bookingSlotId = json['booking_slot_id'];
    date = json['date'];
    time = json['time'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    ratePerHour = json['rate_per_hour'];
    studentName = json['student_name'];
    studentProfile = json['student_profile'];
    paymentStatus = json['payment_status'];
    transactionId = json['transaction_id'];
    booking_slot_id = json['booking_slot_id'];
    valid_for_start = json['valid_for_start'];
    if (json['booked_days'] != null) {
      bookedDays = <BookedDays>[];
      json['booked_days'].forEach((v) {
        bookedDays!.add(new BookedDays.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['booking_id'] = this.booking_id;
    data['booking_number'] = this.booking_number;
    data['booking_slot_number'] = this.booking_slot_number;
    data['student_id'] = this.studentId;
    data['teacher_id'] = this.teacherId;
    data['subject_id'] = this.subjectId;
    data['subject_title'] = this.subjectTitle;
    data['grade_id'] = this.gradeId;
    data['grade_title'] = this.gradeTitle;
    data['booking_status'] = this.bookingStatus;
    data['cancel_by'] = this.cancel_by;
    data['amount'] = this.amount;
    data['discount'] = this.discount;
    data['payable_amount'] = this.payableAmount;
    data['instruction'] = this.instruction;
    data['cancel_reason'] = this.cancelReason;
    data['auto_cancel'] = this.auto_cancel;
    data['booking_at'] = this.booking_at;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['booking_slot_id'] = this.bookingSlotId;
    data['date'] = this.date;
    data['time'] = this.time;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['rate_per_hour'] = this.ratePerHour;
    data['student_name'] = this.studentName;
    data['student_profile'] = this.studentProfile;
    data['payment_status'] = this.paymentStatus;
    data['transaction_id'] = this.transactionId;
    data['booking_slot_id'] = this.booking_slot_id;
    data['valid_for_start'] = this.valid_for_start;
    if (this.bookedDays != null) {
      data['booked_days'] = this.bookedDays!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}