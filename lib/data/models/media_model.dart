import 'package:stapp_ri/domain/entities/media.dart';

class MediaModel extends Media {
  // Media Table and attributes
  static const String mediaId = "id";
  static const String mediaOpId = "opId";
  static const String mediaName = "name";
  static const String mediaPath = "path";
  static const String mediaType = "type";

  MediaModel.of(Media media) {
    this.id = media.id;
    this.name = media.name;
    this.path = media.path;
    this.type = media.type;
    this.opId = media.opId;
  }

  MediaModel.fromMap(Map<String, dynamic> map) {
    this.id = map[mediaId];
    this.name = map[mediaName];
    this.path = map[mediaPath];
    this.type = map[mediaType];
    this.opId = map[mediaOpId];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      mediaName: this.name,
      mediaPath: this.path,
      mediaType: this.type,
    };
    if (id != null) {
      map[mediaId] = id;
    }
    if (opId != null) {
      map[mediaOpId] = this.opId;
    }
    return map;
  }
}
