import 'TransactionHistoryData.dart';
import 'Years.dart';

class TransactionHistoryModel {
  String? responseMsg;
  bool? success;
  int? offset;
  String? total_earnings;
  List<TransactionHistoryData>? data;
  List<Years>? years;

  TransactionHistoryModel(
      {this.responseMsg, this.success, this.offset, this.data,this.total_earnings});

  TransactionHistoryModel.fromJson(Map<String, dynamic> json) {
    responseMsg = json['response_msg'];
    success = json['success'];
    offset = json['offset'];
    total_earnings = json['total_earnings'];
    if (json['data'] != null) {
      data = <TransactionHistoryData>[];
      json['data'].forEach((v) {
        data!.add(new TransactionHistoryData.fromJson(v));
      });
    }

    if (json['years'] != null) {
      years = <Years>[];
      json['years'].forEach((v) {
        years!.add(new Years.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['response_msg'] = this.responseMsg;
    data['success'] = this.success;
    data['offset'] = this.offset;
    data['total_earnings'] = this.total_earnings;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (this.years != null) {
      data['years'] = this.years!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}