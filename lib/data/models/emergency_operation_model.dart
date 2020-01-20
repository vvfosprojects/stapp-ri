import '../../domain/entities/emergency_operation.dart';

class EmergencyOperationModel extends EmergencyOperation {
  // Operations Table and attributes
  static const String opId = "id";
  static const String opTitle = "title";
  static const String opDescription = "description";
  static const String opDate = "date";
  static const String opCoordinates = "coordinates";
  static const String opStatus = "status";

  EmergencyOperationModel.of(EmergencyOperation emergencyOperation) {
    this.id = emergencyOperation.id;
    this.title = emergencyOperation.title;
    this.description = emergencyOperation.description;
    this.date = emergencyOperation.date;
    this.media = emergencyOperation.media;
    this.coordinates = emergencyOperation.coordinates;
    this.status = emergencyOperation.status;
  }

  EmergencyOperationModel.fromMap(Map<String, dynamic> map) {
    this.id = map[opId];
    this.title = map[opTitle];
    this.description = map[opDescription];
    this.date = DateTime.parse(map[opDate]);
    this.coordinates = map[opCoordinates];
    this.status = map[opStatus];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      opTitle: this.title,
      opDescription: this.description,
      opDate: this.date.toIso8601String(),
      opCoordinates: this.coordinates,
      opStatus: this.status,
    };
    if (id != null) {
      map[opId] = id;
    }
    if (coordinates != null) {
      map[opCoordinates] = super.coordinates;
    }
    return map;
  }
}
