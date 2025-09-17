import '../../../core/base/BaseModel.dart';

class BreedTypeModel extends BaseModel {
  int? id;
  int? pet_id;
  String? breed;
  List<BreedTypeModel>? data;

  BreedTypeModel({this.id, this.breed, this.pet_id, this.data});

  BreedTypeModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    pet_id = json['pet_id'];
    breed = json['breed'];
    if (json.containsKey('data') && json['data'] is List<dynamic>) {
      if (json['data'] != null) {
        data = <BreedTypeModel>[];
        json['data'].forEach((v) {
          data!.add(BreedTypeModel.fromJson(v));
        });
      }
    }
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['id'] = id;
    data['pet_id'] = pet_id;
    data['breed'] = breed;

    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
