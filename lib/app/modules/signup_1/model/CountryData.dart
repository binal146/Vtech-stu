class CountryData {
  int? id;
  String? name;
  String? phonecode;
  String? iso_code;

  CountryData({this.id, this.name, this.phonecode});

  CountryData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    phonecode = json['phonecode'];
    iso_code = json['iso_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['phonecode'] = this.phonecode;
    data['iso_code'] = this.iso_code;
    return data;
  }
}