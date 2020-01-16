
import 'package:stapp_ri/adapters/helpers/db_values.dart';
import 'package:stapp_ri/domain/values/values.dart';

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
    this._id = map[Values.mediaId];
    this.name = map[Values.mediaName];
    this.path = map[Values.mediaPath];
    this.type = map[Values.mediaType];
    this.opId = map[Values.mediaOpId];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      Values.mediaName: this.name,
      Values.mediaPath: this.path,
      Values.mediaType: this.type,
    };
    if (_id != null) {
      map[Values.mediaId] = _id;
    }
    if (opId != null) {
      map[Values.mediaOpId] = this.opId;
    }
    return map;
  }
  
}