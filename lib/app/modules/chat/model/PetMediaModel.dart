class PetMediaModel {
  int? id;
  int? petId;
  String? mediaName;
  String? fullPetMediaImagePath;
  String? videoThumbnail;
  String? media_type;

  int? postId;

  PetMediaModel(
      {this.id,
        this.petId,
        this.mediaName,
        this.fullPetMediaImagePath,
        this.videoThumbnail,
        this.media_type,
        this.postId});

  PetMediaModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    petId = json['pet_id'];
    mediaName = json['media_name'];
    fullPetMediaImagePath = json['full_pet_media_image_path'];
    if (json.containsKey('pet_memorial_id')) {
      petId = json['pet_memorial_id'];
    }
    if (json.containsKey('full_pet_memorial_media_image_path')) {
      fullPetMediaImagePath = json['full_pet_memorial_media_image_path'];
    }
    if (json.containsKey('full_chat_media_image_path')) {
      fullPetMediaImagePath = json['full_chat_media_image_path'];
    }
    if (json.containsKey('full_post_media_image_path')) {
      fullPetMediaImagePath = json['full_post_media_image_path'];
    }
    if (json.containsKey('full_thumbnail_image_path')) {
      videoThumbnail = json['full_thumbnail_image_path'];
    }
     /*if (json.containsKey('thumbnail_name')) {
      videoThumbnail = json['thumbnail_name'];
    }*/
    if (json.containsKey('media_type')) {
      media_type = json['media_type'];
    }
    postId = json['post_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['pet_id'] = this.petId;
    data['media_name'] = this.mediaName;
    data['full_pet_media_image_path'] = this.fullPetMediaImagePath;
    data['full_chat_media_image_path'] = this.fullPetMediaImagePath;
    return data;
  }

}