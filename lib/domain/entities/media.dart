class Media {
  int id;
  String name;
  String path;
  String type;
  int opId;

  Media({this.name, this.path, this.type, this.opId});

  @override
  String toString() {
    return "{ id:$id, name:$name, path:$path, type:$type, opId:$opId }";
  }
  
}