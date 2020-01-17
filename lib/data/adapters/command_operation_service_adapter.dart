import 'package:sqflite/sqflite.dart';
import 'package:stapp_ri/domain/entities/emergency_operation.dart';
import 'package:stapp_ri/domain/ports/command_operation_service.dart';
import 'package:stapp_ri/domain/values/values.dart';
import 'package:stapp_ri/data/helpers/database_helpers.dart';
import 'package:stapp_ri/data/helpers/db_values.dart';
import 'package:stapp_ri/data/models/emergency_operation_model.dart';


class CommandOperationServiceAdapter<M> implements CommandOperationService {
  DatabaseHelper helper = DatabaseHelper.instance;

  @override
  Future<int> delete(id) async {
    Database db = await helper.database;
    int result = await db.delete(DBValues.tableOperations,
        where: '${Values.opId} = ?', whereArgs: [id]);
    await db.delete(DBValues.tableMedia,
        where: '${Values.mediaOpId} = ?', whereArgs: [id]);
    return result;
  }

  @override
  Future<int> update(m) async {
    Database db = await helper.database;
    EmergencyOperation emOp = m as EmergencyOperation;
    int opId = await db.update(DBValues.tableOperations, m.toMap(),
        where: '${Values.opId} = ?', whereArgs: [m.id]);
    var batch = db.batch();
    emOp.media.forEach((m) {
      m.opId = opId;
      if(m.id!=null){
        batch.update(DBValues.tableMedia, m.toMap(), where: '${Values.mediaId} = ?',
        whereArgs: [m.id]);
      } else {
        batch.insert(DBValues.tableMedia, m.toMap());
      }
    });
    batch.commit();
    return opId;
  }

  @override
  Future<int> insert(em) async {
    EmergencyOperationModel emOp = EmergencyOperationModel.of(em as EmergencyOperation);
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
