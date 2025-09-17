class CancelReasonData {
  String? reason;

  CancelReasonData({this.reason});

  CancelReasonData.fromJson(Map<String, dynamic> json) {
    reason = json['reason'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['reason'] = this.reason;
    return data;
  }
}