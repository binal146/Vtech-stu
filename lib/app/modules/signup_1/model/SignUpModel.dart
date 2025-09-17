class SignupModel {
  String? responseMsg;
  bool? success;
  String? commission_rate;
  int? is_notification_read;

  SignupModel({this.responseMsg, this.success,this.commission_rate,this.is_notification_read});

  SignupModel.fromJson(Map<String, dynamic> json) {
    responseMsg = json['response_msg'];
    success = json['success'];
    commission_rate = json['commission_rate'];
    is_notification_read = json['is_notification_read'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['response_msg'] = this.responseMsg;
    data['success'] = this.success;
    data['commission_rate'] = this.commission_rate;
    data['is_notification_read'] = this.is_notification_read;
    return data;
  }
}