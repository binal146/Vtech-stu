class CallDetails {

  String? start_time;
  String? call_type_title;
  String? call_type;
  String? second;

  CallDetails(
      {this.start_time,
      this.call_type,
      this.second,});

  CallDetails.fromJson(Map<String, dynamic> json) {
    start_time = json['start_time'];
    call_type = json['call_type'];
    call_type_title = json['call_type_title'];
    second = json['second'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['start_time'] = this.start_time;
    data['call_type_title'] = this.call_type_title;
    data['call_type'] = this.call_type;
    data['second'] = this.second;
    return data;
  }
}