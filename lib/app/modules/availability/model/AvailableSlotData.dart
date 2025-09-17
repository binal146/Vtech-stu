import '../../TimeslotModel.dart';
import 'Timeslots.dart';

class AvailableSlotData {
  String? startDate;
  String? endDate;
  String? ratePerHour;
  List<Timeslotmodel>? timeslots;

  AvailableSlotData({this.startDate, this.endDate, this.ratePerHour, this.timeslots});

  AvailableSlotData.fromJson(Map<String, dynamic> json) {
    startDate = json['start_date'];
    endDate = json['end_date'];
    ratePerHour = json['rate_per_hour'];
    if (json['timeslots'] != null) {
      timeslots = <Timeslotmodel>[];
      json['timeslots'].forEach((v) {
        timeslots!.add(new Timeslotmodel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['rate_per_hour'] = this.ratePerHour;
    if (this.timeslots != null) {
      data['timeslots'] = this.timeslots!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}