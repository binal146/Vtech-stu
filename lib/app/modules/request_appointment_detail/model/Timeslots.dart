import 'package:get/get_rx/src/rx_types/rx_types.dart';

class Timeslots {
  String? time;
  int? booking_slot_id;
  int? is_cancel;
  RxBool isSelect = true.obs;
  Timeslots({
    this.time,
    this.booking_slot_id,
    this.is_cancel
  });

  Timeslots.fromJson(Map<String, dynamic> json) {
    time = json['time'];
    booking_slot_id = json['booking_slot_id'];
    is_cancel = json['is_cancel'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['time'] = this.time;
    data['booking_slot_id'] = this.booking_slot_id;
    data['is_cancel'] = this.is_cancel;
    return data;
  }
}