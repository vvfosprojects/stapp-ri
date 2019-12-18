import 'package:flutter/material.dart';
import 'package:stapp_ri/helpers/db_values.dart';

import 'media.dart';

class EmergencyOperation {
  int _id;
  String title;
  String description;
  DateTime date;
  List<Media> media;
  String coordinates;
  String status;

  EmergencyOperation(
      {@required this.title,
      @required this.description,
      @required this.date,
      this.media,
      this.coordinates,
      @required this.status});

  get id{ return this._id; }

  EmergencyOperation.fromMap(Map<String, dynamic> map) {
    this._id = map[DBValues.opId];
    this.title = map[DBValues.opTitle];
    this.description = map[DBValues.opDescription];
    this.date = DateTime.parse(map[DBValues.opDate]);
    this.coordinates = map[DBValues.opCoordinates];
    this.status = map[DBValues.opStatus];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      DBValues.opTitle: this.title,
      DBValues.opDescription: this.description,
      DBValues.opDate: this.date.toIso8601String(),
      DBValues.opCoordinates: this.coordinates,
      DBValues.opStatus: this.status,
    };
    if (_id != null) {
      map[DBValues.opId] = _id;
    }
    if (coordinates != null) {
      map[DBValues.opCoordinates] = this.coordinates;
    }
    return map;
  }
}
