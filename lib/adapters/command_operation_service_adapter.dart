import 'package:sqflite/sqflite.dart';
import 'package:stapp_ri/ports/command_operation_service.dart';
import '../helpers/db_values.dart';
import '../helpers/database_helpers.dart';
import '../models/emergency_operation.dart';

class CommandOperationServiceAdapter<M> implements CommandOperationService {
  DatabaseHelper helper = DatabaseHelper.instance;

  @override
  Future<int> delete(m) async {
    Database db = await helper.database;
    db.execute("BEGIN TRANSACTION");
    int result = await db.delete(DBValues.tableOperations,
        where: '${DBValues.opId} = ?', whereArgs: [m.id]);
    await db.delete(DBValues.tableMedia,
        where: '${DBValues.mediaOpId} = ?', whereArgs: [m.id]);
    db.execute("COMMIT TRANSACTION");
    return result;
  }

  @override
  Future<int> update(m) async {
    Database db = await helper.database;
    EmergencyOperation emOp = m as EmergencyOperation;
    db.execute("BEGIN TRANSACTION");
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
    db.execute("COMMIT TRANSACTION");
    return opId;
  }

  @override
  Future<int> insert(m) async {
    EmergencyOperation emOp = m as EmergencyOperation;
    Database db = await helper.database;
    db.execute("BEGIN TRANSACTION");
    int opId = await db.insert(DBValues.tableOperations, emOp.toMap());
    var batch = db.batch();
    emOp.media.forEach((m) {
      m.opId = opId;
      print(m.toMap());
      batch.insert(DBValues.tableMedia, m.toMap());
    });
    batch.commit();
    db.execute("COMMIT TRANSACTION");
    return opId;
  }
}
