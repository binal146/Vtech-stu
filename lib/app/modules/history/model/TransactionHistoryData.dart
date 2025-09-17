
import 'Transactions.dart';

class TransactionHistoryData {
  String? monthName;
  List<Transactions>? transactions;
  int? totalEarnings;

  TransactionHistoryData({this.monthName, this.transactions, this.totalEarnings});

  TransactionHistoryData.fromJson(Map<String, dynamic> json) {
    monthName = json['month_name'];
    if (json['transactions'] != null) {
      transactions = <Transactions>[];
      json['transactions'].forEach((v) {
        transactions!.add(new Transactions.fromJson(v));
      });
    }
    totalEarnings = json['total_earnings'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['month_name'] = this.monthName;
    if (this.transactions != null) {
      data['transactions'] = this.transactions!.map((v) => v.toJson()).toList();
    }
    data['total_earnings'] = this.totalEarnings;
    return data;
  }
}
