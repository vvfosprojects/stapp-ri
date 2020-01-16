import 'package:flutter/material.dart';
import 'package:stapp_ri/adapters/helpers/db_values.dart';
import 'package:stapp_ri/domain/values/values.dart';

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
    this._id = map[Values.opId];
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
    if (_id != null) {
      map[Values.opId] = _id;
    }
    if (coordinates != null) {
      map[Values.opCoordinates] = this.coordinates;
    }
    return map;
  }
}
