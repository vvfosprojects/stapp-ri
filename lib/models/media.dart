import 'package:stapp_ri/helpers/db_values.dart';

class Media {
  int _id;
  String name;
  String path;
  String type;
  int opId;

  Media({this.name, this.path, this.type, this.opId});

  @override
  String toString() {
    return "{ id:$_id, name:$name, path:$path, type:$type, opId:$opId }";
  }

  get id{ return this._id; }

  Media.fromMap(Map<String, dynamic> map) {
    this._id = map[DBValues.mediaId];
    this.name = map[DBValues.mediaName];
    this.path = map[DBValues.mediaPath];
    this.type = map[DBValues.mediaType];
    this.opId = map[DBValues.mediaOpId];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      DBValues.mediaName: this.name,
      DBValues.mediaPath: this.path,
      DBValues.mediaType: this.type,
    };
    if (_id != null) {
      map[DBValues.mediaId] = _id;
    }
    if (opId != null) {
      map[DBValues.mediaOpId] = this.opId;
    }
    return map;
  }
  
}