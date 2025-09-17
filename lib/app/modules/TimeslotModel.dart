import 'package:get/get.dart';

class Timeslotmodel {
  String? time;
  RxBool isSelect = false.obs;

  Timeslotmodel({this.time, required this.isSelect});

  Timeslotmodel.fromJson(Map<String, dynamic> json) {
    time = json['time'];
    isSelect.value = json['is_select'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['time'] = time;
    data['is_select'] = isSelect;
    return data;
  }
}