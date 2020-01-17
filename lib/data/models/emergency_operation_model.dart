import '../../domain/entity/emergency_operation.dart';
import '../../domain/values/values.dart';

class EmergencyOperationModel extends EmergencyOperation {

  EmergencyOperationModel.of(EmergencyOperation emergencyOperation){
    this.id = emergencyOperation.id;
    this.title = emergencyOperation.title;
    this.description = emergencyOperation.description;
    this.date = emergencyOperation.date;
    this.media = emergencyOperation.media;
    this.coordinates = emergencyOperation.coordinates;
    this.status = emergencyOperation.status;
  }

  EmergencyOperationModel.fromMap(Map<String, dynamic> map) {
    this.id = map[Values.opId];
    this.title = map[Values.opTitle];
    this.description = map[Values.opDescription];
    this.date = DateTime.parse(map[Values.opDate]);
    this.coordinates = map[Values.opCoordinates];
    this.status = map[Values.opStatus];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      Values.opTitle: this.title,
      Values.opDescription: this.description,
      Values.opDate: this.date.toIso8601String(),
      Values.opCoordinates: this.coordinates,
      Values.opStatus: this.status,
    };
    if (id != null) {
      map[Values.opId] = id;
    }
    if (coordinates != null) {
      map[Values.opCoordinates] = super.coordinates;
    }
    return map;
  }

}