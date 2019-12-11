import 'package:flutter/material.dart';

import 'media.dart';

class Operation {
  String title;
  String description;
  DateTime date;
  List<Media> pictures;
  List<Media> videos;
  List<Media> audios;
  String coordinates;
  String status;

  Operation(
      {@required this.title,
      @required this.description,
      @required this.date,
      this.pictures,
      this.audios,
      this.videos,
      this.coordinates,
      @required this.status});
}
