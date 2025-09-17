class BaseResponse {

  bool? success;
  String? screen_code;
  String? message;

  BaseResponse({this.success,this.screen_code, this.message});

  BaseResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    screen_code = json['screen_code'];
    message = json['response_msg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['screen_code'] = screen_code;
    data['response_msg'] = message;
    return data;
  }
}