
class UserResponseMain {

  final List<UserResponse> list;

  UserResponseMain(this.list);

  factory UserResponseMain.fromJson(List<dynamic> json) =>
      UserResponseMain(json.map((e) => UserResponse.fromJson(e)).toList());

}

class UserResponse {
  int? userId;
  int? id;
  String? title;
  String? body;

  UserResponse({this.userId, this.id, this.title, this.body});

  UserResponse.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    id = json['id'];
    title = json['title'];
    body = json['body'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['id'] = id;
    data['title'] = title;
    data['body'] = body;

    return data;
  }
}