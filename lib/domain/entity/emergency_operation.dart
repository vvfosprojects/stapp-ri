import 'package:flutter/material.dart';

import 'media.dart';

class EmergencyOperation {
  int id;
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

}
