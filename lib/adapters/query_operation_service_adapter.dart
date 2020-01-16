import 'package:sqflite/sqflite.dart';
import 'package:stapp_ri/adapters/helpers/database_helpers.dart';
import 'package:stapp_ri/adapters/helpers/db_values.dart';
import 'package:stapp_ri/domain/entity/emergency_operation.dart';
import 'package:stapp_ri/domain/entity/media.dart';
import 'package:stapp_ri/domain/ports/query_operation_service.dart';

class QueryOperationServiceAdapter<M> implements QueryOperationService<M> {

  DatabaseHelper helper = DatabaseHelper.instance;

  @override
  Future<List<EmergencyOperation>> readAll() async {
    Database db = await helper.database;
    List<EmergencyOperation> result = List();
    List<Map> maps = await db.query(DBValues.tableOperations,
        columns: [DBValues.opId, DBValues.opTitle, DBValues.opDescription, DBValues.opDate, DBValues.opStatus, DBValues.opCoordinates]);
    if (maps.length > 0) {
      for(var emerop in maps){
        EmergencyOperation eo = EmergencyOperation.fromMap(emerop);
        if(eo.media == null) eo.media = List<Media>();
        List<Media> medias =  await readMedia(eo.id);
        if(medias != null) eo.media.addAll(medias);
        result.add(eo);
      }
    }
    return result;
  }

  @override
  Future<EmergencyOperation> read(int id) async {
    Database db = await helper.database;
    List<Map> maps = await db.query(DBValues.tableOperations,
        columns: [DBValues.opId, DBValues.opTitle, DBValues.opDescription, DBValues.opDate, DBValues.opStatus, DBValues.opCoordinates],
        where: '${DBValues.opId} = ?',
        whereArgs: [id]);
    if (maps.length > 0) {  
        EmergencyOperation eo = EmergencyOperation.fromMap(maps.first);
        if(eo.media == null) eo.media = List<Media>();
        List<Media> medias =  await readMedia(eo.id);
        eo.media.addAll(medias);
      return eo;
    }
    return null;
  }

  Future<List<Media>> readMedia(int id) async {
    Database db = await helper.database;
    List<Media> result = List<Media>();
    List<Map> maps = await db.query(DBValues.tableMedia,
        columns: [DBValues.mediaId, DBValues.mediaName, DBValues.mediaPath, DBValues.mediaOpId, DBValues.mediaType],
        where: '${DBValues.mediaOpId} = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      maps.forEach((map) => {
        result.add(Media.fromMap(map))
      });
    }
    return result;
  }

}