import 'DateTimeslotsModel.dart';

class RequestDetailData {
  int? id;
  String? bookingUniqueId;
  String? booking_number;
  int? studentId;
  int? teacherId;
  String? subjectId;
  String? subjectTitle;
  int? gradeId;
  String? gradeTitle;
  String? bookingStatus;
  Null? rejectReason;
  String? amount;
  String? discount;
  String? payableAmount;
  String? instruction;
  Null? cancelReason;
  String? updatedAt;
  Null? deletedAt;
  String? startDate;
  String? endDate;
  String? studentName;
  String? studentProfile;
  String? paymentStatus;
  String? transactionId;
  String? booking_at;
  String? rate_per_hour;
  List<Timeslots>? timeslots;
  List<DatetimeSlotsmodel>? datetimeSlotsmodel;

  RequestDetailData(
      {this.id,
      this.bookingUniqueId,
      this.booking_number,
      this.studentId,
      this.teacherId,
      this.subjectId,
      this.subjectTitle,
      this.gradeId,
      this.gradeTitle,
      this.bookingStatus,
      this.rejectReason,
      this.amount,
      this.discount,
      this.payableAmount,
      this.instruction,
      this.cancelReason,
      this.updatedAt,
      this.deletedAt,
      this.startDate,
      this.endDate,
      this.studentName,
      this.studentProfile,
      this.paymentStatus,
      this.transactionId,
      this.booking_at,
      this.timeslots,
      this.datetimeSlotsmodel,
      this.rate_per_hour
      });

  RequestDetailData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bookingUniqueId = json['booking_unique_id'];
    booking_number = json['booking_number'];
    studentId = json['student_id'];
    teacherId = json['teacher_id'];
    subjectId = json['subject_id'];
    subjectTitle = json['subject_title'];
    gradeId = json['grade_id'];
    gradeTitle = json['grade_title'];
    bookingStatus = json['booking_status'];
    rejectReason = json['reject_reason'];
    amount = json['amount'];
    discount = json['discount'];
    payableAmount = json['payable_amount'];
    instruction = json['instruction'];
    cancelReason = json['cancel_reason'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    studentName = json['student_name'];
    studentProfile = json['student_profile'];
    paymentStatus = json['payment_status'];
    transactionId = json['transaction_id'];
    booking_at = json['booking_at'];
    rate_per_hour = json['rate_per_hour'];
    if (json['timeslots'] != null) {
      timeslots = <Timeslots>[];
      json['timeslots'].forEach((v) {
        timeslots!.add(new Timeslots.fromJson(v));
      });
    }
    if (json['timeslots_by_date'] != null) {
      datetimeSlotsmodel = <DatetimeSlotsmodel>[];
      json['timeslots_by_date'].forEach((v) {
        datetimeSlotsmodel!.add(new DatetimeSlotsmodel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['booking_unique_id'] = this.bookingUniqueId;
    data['booking_number'] = this.booking_number;
    data['student_id'] = this.studentId;
    data['teacher_id'] = this.teacherId;
    data['subject_id'] = this.subjectId;
    data['subject_title'] = this.subjectTitle;
    data['grade_id'] = this.gradeId;
    data['grade_title'] = this.gradeTitle;
    data['booking_status'] = this.bookingStatus;
    data['reject_reason'] = this.rejectReason;
    data['amount'] = this.amount;
    data['discount'] = this.discount;
    data['payable_amount'] = this.payableAmount;
    data['instruction'] = this.instruction;
    data['cancel_reason'] = this.cancelReason;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['student_name'] = this.studentName;
    data['student_profile'] = this.studentProfile;
    data['payment_status'] = this.paymentStatus;
    data['transaction_id'] = this.transactionId;
    data['booking_at'] = this.booking_at;
    data['rate_per_hour'] = this.rate_per_hour;
    if (this.timeslots != null) {
      data['timeslots'] = this.timeslots!.map((v) => v.toJson()).toList();
    }
    if (this.datetimeSlotsmodel != null) {
      data['timeslots_by_date'] = this.datetimeSlotsmodel!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Timeslots {
  String? time;

  Timeslots({this.time});

  Timeslots.fromJson(Map<String, dynamic> json) {
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['time'] = this.time;
    return data;
  }
}