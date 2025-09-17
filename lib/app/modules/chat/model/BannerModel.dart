class BannerModel {
  String? responseMsg;
  bool? success;
  List<BannerModel>? data;
  int? offset;
  int? id;
  String? banner;
  String? url;
  int? status;
  String? createdAt;
  String? bannerPath;
  BannerModel({this.responseMsg, this.success, this.data, this.offset});

  BannerModel.fromJson(Map<String, dynamic> json) {
    responseMsg = json['response_msg'];
    success = json['success'];
    id = json['id'];
    banner = json['banner'];
    url = json['url'];
    status = json['status'];
    createdAt = json['created_at'];
    bannerPath = json['banner_path'];
    if (json['data'] != null) {
      data = <BannerModel>[];
      json['data'].forEach((v) {
        data!.add(BannerModel.fromJson(v));
      });
    }
    offset = json['offset'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['response_msg'] = responseMsg;
    data['success'] = success;
    data['id'] = id;
    data['banner'] = banner;
    data['url'] = url;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['banner_path'] = bannerPath;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['offset'] = offset;
    return data;
  }
}