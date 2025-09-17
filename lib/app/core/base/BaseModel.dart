

class BaseModel {
  bool? success;
  String? screenCode;
  String? response_msg;


  BaseModel({this.success, this.screenCode, this.response_msg});

  BaseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    screenCode = json['screen_code'];
    response_msg = json['response_msg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['screen_code'] = screenCode;
    data['response_msg'] = response_msg;
    return data;
  }
}