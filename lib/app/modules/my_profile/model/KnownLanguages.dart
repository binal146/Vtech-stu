
class KnownLanguages {
  int? id;
  String? known_language;

  KnownLanguages({this.id, this.known_language});

  KnownLanguages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    known_language = json['known_language'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['known_language'] = this.known_language;
    return data;
  }
}
