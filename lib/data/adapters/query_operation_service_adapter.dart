import 'package:sqflite/sqflite.dart';
import 'package:stapp_ri/data/helpers/database_helpers.dart';
import 'package:stapp_ri/data/helpers/db_values.dart';
import 'package:stapp_ri/data/models/emergency_operation_model.dart';
import 'package:stapp_ri/data/models/media_model.dart';
import 'package:stapp_ri/domain/entities/emergency_operation.dart';
import 'package:stapp_ri/domain/entities/media.dart';
import 'package:stapp_ri/domain/ports/query_operation_service.dart';

class QueryOperationServiceAdapter<M> implements QueryOperationService<M> {
  DatabaseHelper helper = DatabaseHelper.instance;

  @override
  Future<List<EmergencyOperation>> readAll() async {
    Database db = await helper.database;
    List<EmergencyOperation> result = List();
    List<Map> maps = await db.query(DBValues.tableOperations, columns: [
      EmergencyOperationModel.opId,
      EmergencyOperationModel.opTitle,
      EmergencyOperationModel.opDescription,
      EmergencyOperationModel.opDate,
      EmergencyOperationModel.opStatus,
      EmergencyOperationModel.opCoordinates
    ]);
    if (maps.length > 0) {
      for (var emerop in maps) {
        EmergencyOperationModel eo = EmergencyOperationModel.fromMap(emerop);
        if (eo.media == null) eo.media = List<Media>();
        List<Media> medias = await readMedia(eo.id);
        if (medias != null) eo.media.addAll(medias);
        result.add(eo);
      }
    }
    return result;
  }

  @override
  Future<EmergencyOperation> read(int id) async {
    Database db = await helper.database;
    List<Map> maps = await db.query(DBValues.tableOperations,
        columns: [
          EmergencyOperationModel.opId,
          EmergencyOperationModel.opTitle,
          EmergencyOperationModel.opDescription,
          EmergencyOperationModel.opDate,
          EmergencyOperationModel.opStatus,
          EmergencyOperationModel.opCoordinates
        ],
        where: '${EmergencyOperationModel.opId} = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      EmergencyOperationModel eo = EmergencyOperationModel.fromMap(maps.first);
      if (eo.media == null) eo.media = List<Media>();
      List<Media> medias = await readMedia(eo.id);
      eo.media.addAll(medias);
      return eo;
    }
    return null;
  }

  Future<List<Media>> readMedia(int id) async {
    Database db = await helper.database;
    List<Media> result = List<Media>();
    List<Map> maps = await db.query(DBValues.tableMedia,
        columns: [
          MediaModel.mediaId,
          MediaModel.mediaName,
          MediaModel.mediaPath,
          MediaModel.mediaOpId,
          MediaModel.mediaType
        ],
        where: '${MediaModel.mediaOpId} = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      maps.forEach((map) => {result.add(MediaModel.fromMap(map))});
    }
    return result;
  }
}
