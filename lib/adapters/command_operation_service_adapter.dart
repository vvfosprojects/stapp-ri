import 'package:sqflite/sqflite.dart';
import 'package:stapp_ri/adapters/helpers/database_helpers.dart';
import 'package:stapp_ri/adapters/helpers/db_values.dart';
import 'package:stapp_ri/domain/entity/emergency_operation.dart';
import 'package:stapp_ri/domain/ports/command_operation_service.dart';

class CommandOperationServiceAdapter<M> implements CommandOperationService {
  DatabaseHelper helper = DatabaseHelper.instance;

  @override
  Future<int> delete(id) async {
    Database db = await helper.database;
    int result = await db.delete(DBValues.tableOperations,
        where: '${DBValues.opId} = ?', whereArgs: [id]);
    await db.delete(DBValues.tableMedia,
        where: '${DBValues.mediaOpId} = ?', whereArgs: [id]);
    return result;
  }

  @override
  Future<int> update(m) async {
    Database db = await helper.database;
    EmergencyOperation emOp = m as EmergencyOperation;
    int opId = await db.update(DBValues.tableOperations, m.toMap(),
        where: '${DBValues.opId} = ?', whereArgs: [m.id]);
    var batch = db.batch();
    emOp.media.forEach((m) {
      m.opId = opId;
      if(m.id!=null){
        batch.update(DBValues.tableMedia, m.toMap(), where: '${DBValues.mediaId} = ?',
        whereArgs: [m.id]);
      } else {
        batch.insert(DBValues.tableMedia, m.toMap());
      }
    });
    batch.commit();
    return opId;
  }

  @override
  Future<int> insert(m) async {
    EmergencyOperation emOp = m as EmergencyOperation;
    Database db = await helper.database;
    int opId = await db.insert(DBValues.tableOperations, emOp.toMap());
    var batch = db.batch();
    emOp.media.forEach((m) {
      m.opId = opId;
      print(m.toMap());
      batch.insert(DBValues.tableMedia, m.toMap());
    });
    batch.commit();
    return opId;
  }
}
