
class Interest {
  int? id;
  String? interest;

  Interest({this.id, this.interest});

  Interest.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    interest = json['interest'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['interest'] = this.interest;
    return data;
  }
}
