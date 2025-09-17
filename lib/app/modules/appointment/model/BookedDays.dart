class BookedDays {
  String? days;

  BookedDays({this.days});

  BookedDays.fromJson(Map<String, dynamic> json) {
    days = json['days'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['days'] = this.days;
    return data;
  }
}