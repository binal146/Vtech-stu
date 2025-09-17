class RateData {

  String? booking_slot_number;
  String? student_name;
  String? student_profile;
  String? rating;
  String? review;
  String? date;

  RateData(
      {this.booking_slot_number,
      this.student_name,
      this.student_profile,
      this.rating,
      this.review,
      this.date,
      });

  RateData.fromJson(Map<String, dynamic> json) {
    booking_slot_number = json['booking_slot_number'];
    student_name = json['student_name'];
    student_profile = json['student_profile'];
    rating = json['rating'];
    review = json['review'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['booking_slot_number'] = this.booking_slot_number;
    data['student_name'] = this.student_name;
    data['student_profile'] = this.student_profile;
    data['rating'] = this.rating;
    data['review'] = this.review;
    data['date'] = this.date;
    return data;
  }
}