import 'package:image_picker/image_picker.dart';

class UploadDocumentModel {
  int id;
  String title;
  XFile? image;

  UploadDocumentModel(this.id,this.title, this.image);

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'image': image,
  };
}
