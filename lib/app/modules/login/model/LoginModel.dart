import 'LoginData.dart';

class LoginModel {
  bool? success;
  String? code;
  String? response_msg;
  LoginData? data;

  LoginModel({this.success, this.code, this.response_msg, this.data});

  LoginModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];
    response_msg = json['response_msg'];
    data = json['data'] != null ? json['data'].isEmpty ? null : LoginData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['code'] = code;
    data['response_msg'] = response_msg;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}