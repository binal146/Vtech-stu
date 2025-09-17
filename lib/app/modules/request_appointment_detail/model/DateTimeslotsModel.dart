import 'Timeslots.dart';

class DatetimeSlotsmodel {
  String? date;
  List<Timeslots>? timeslots;

  DatetimeSlotsmodel({
    this.date,
    this.timeslots
  });

  DatetimeSlotsmodel.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    if (json['timeslots'] != null) {
      timeslots = <Timeslots>[];
      json['timeslots'].forEach((v) {
        timeslots!.add(new Timeslots.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    if (this.timeslots != null) {
      data['timeslots'] = this.timeslots!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}