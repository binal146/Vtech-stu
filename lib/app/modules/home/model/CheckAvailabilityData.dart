class CheckAvailabilityData {
  int? profileApprovedApp;
  int? slotAvailability;
  String? timezone_text;

  CheckAvailabilityData({this.profileApprovedApp, this.slotAvailability});

  CheckAvailabilityData.fromJson(Map<String, dynamic> json) {
    profileApprovedApp = json['profile_approved_app'];
    slotAvailability = json['slot_availability'];
    timezone_text = json['timezone_text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['profile_approved_app'] = this.profileApprovedApp;
    data['slot_availability'] = this.slotAvailability;
    data['timezone_text'] = this.timezone_text;
    return data;
  }
}