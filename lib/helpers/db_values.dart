class DBValues {

  static const String dbName = "stappri.db";
  static const int dbVersion = 1;

  // Operations Table and attributes
  static const String tableOperations = "operations";
  static const String opId = "_id";
  static const String opTitle = "title";
  static const String opDescription = "description";
  static const String opDate = "date";
  static const String opCoordinates = "coordinates";
  static const String opStatus = "status";

  // Media Table and attributes
  static const String tableMedia = "media";
  static const String mediaId = "_id";
  static const String mediaOpId = "opId";
  static const String mediaName = "name";
  static const String mediaType = "type";

}