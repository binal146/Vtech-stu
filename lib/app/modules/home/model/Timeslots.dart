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