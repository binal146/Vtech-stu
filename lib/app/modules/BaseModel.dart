
class BaseModel {
  String? responseMsg;
  bool? success;


  BaseModel({this.responseMsg, this.success});

  BaseModel.fromJson(Map<String, dynamic> json) {
    responseMsg = json['response_msg'];
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['response_msg'] = this.responseMsg;
    data['success'] = this.success;
    return data;
  }
}