import 'BookingData.dart';

class BookingModel {
  String? responseMsg;
  bool? success;
  List<BookingData>? data;

  BookingModel({this.responseMsg, this.success, this.data});

  BookingModel.fromJson(Map<String, dynamic> json) {
    responseMsg = json['response_msg'];
    success = json['success'];
    if (json['data'] != null) {
      data = <BookingData>[];
      json['data'].forEach((v) {
        data!.add(new BookingData.fromJson(v));
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