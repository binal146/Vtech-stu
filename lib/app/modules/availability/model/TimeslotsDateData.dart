

import 'SlotDate.dart';

class TimeslotsdateData {
  List<SlotDate>? slotDate;

  TimeslotsdateData({this.slotDate});

  TimeslotsdateData.fromJson(Map<String, dynamic> json) {
    if (json['slot_date'] != null) {
      slotDate = <SlotDate>[];
      json['slot_date'].forEach((v) {
        slotDate!.add(new SlotDate.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.slotDate != null) {
      data['slot_date'] = this.slotDate!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}