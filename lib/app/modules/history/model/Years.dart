

class Years {
  String? year;
  int? is_default;

  Years({this.year, this.is_default});

  Years.fromJson(Map<String, dynamic> json) {
    year = json['year'];
    is_default = json['is_default'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['year'] = this.year;
    data['is_default'] = this.is_default;
    return data;
  }
}
