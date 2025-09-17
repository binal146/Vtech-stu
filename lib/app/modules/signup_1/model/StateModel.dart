import 'package:vteach_teacher/app/modules/signup_1/model/StateData.dart';

import 'CountryData.dart';

class StateModel {
  String? responseMsg;
  bool? success;
  List<StateData>? data;

  StateModel({this.responseMsg, this.success, this.data});

  StateModel.fromJson(Map<String, dynamic> json) {
    responseMsg = json['response_msg'];
    success = json['success'];
    if (json['data'] != null) {
      data = <StateData>[];
      json['data'].forEach((v) {
        data!.add(new StateData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['response_msg'] = this.responseMsg;
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}