import 'package:sqflite/sqflite.dart';
import 'package:stapp_ri/data/models/media_model.dart';
import 'package:stapp_ri/domain/entities/emergency_operation.dart';
import 'package:stapp_ri/domain/ports/command_operation_service.dart';
import 'package:stapp_ri/data/helpers/database_helpers.dart';
import 'package:stapp_ri/data/helpers/db_values.dart';
import 'package:stapp_ri/data/models/emergency_operation_model.dart';

class CommandOperationServiceAdapter<M> implements CommandOperationService {
  DatabaseHelper helper = DatabaseHelper.instance;

  @override
  Future<int> delete(id) async {
    Database db = await helper.database;
    int result = await db.delete(DBValues.tableOperations,
        where: '${EmergencyOperationModel.opId} = ?', whereArgs: [id]);
    await db.delete(DBValues.tableMedia,
        where: '${MediaModel.mediaOpId} = ?', whereArgs: [id]);
    return result;
  }

  @override
  Future<int> update(m) async {
    Database db = await helper.database;
    EmergencyOperationModel emOp =
        EmergencyOperationModel.of(m as EmergencyOperation);
    await db.update(DBValues.tableOperations, emOp.toMap(),
        where: '${EmergencyOperationModel.opId} = ?',
        whereArgs: [emOp.id]).then((id) {
      var batch = db.batch();
      emOp.media.forEach((media) {
        MediaModel m = MediaModel.of(media);
        m.opId = id;
        if (m.id != null) {
          batch.update(DBValues.tableMedia, m.toMap(),
              where: '${MediaModel.mediaId} = ?', whereArgs: [m.id]);
        } else {
          batch.insert(DBValues.tableMedia, m.toMap());
        }
      });
      batch.commit();
    });

    return emOp.id;
  }

  @override
  Future<int> insert(em) async {
    EmergencyOperationModel emOp =
        EmergencyOperationModel.of(em as EmergencyOperation);
    Database db = await helper.database;
    int opId = await db.insert(DBValues.tableOperations, emOp.toMap());
    var batch = db.batch();
    emOp.media.forEach((media) {
      MediaModel m = MediaModel.of(media);
      m.opId = opId;
      print(m.toMap());
      batch.insert(DBValues.tableMedia, m.toMap());
    });
    batch.commit();
    return opId;
  }
}
