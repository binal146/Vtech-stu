import 'MyProfileData.dart';

class MyProfileModel {
  String? responseMsg;
  bool? success;
  MyProfileData? data;

  MyProfileModel({this.responseMsg, this.success, this.data});

  MyProfileModel.fromJson(Map<String, dynamic> json) {
    responseMsg = json['response_msg'];
    success = json['success'];
    data = json['data'] != null ? new MyProfileData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['response_msg'] = this.responseMsg;
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}
