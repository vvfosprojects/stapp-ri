import 'package:sqflite/sqflite.dart';
import '../helpers/db_values.dart';

import '../ports/query_operation_service.dart';
import '../helpers/database_helpers.dart';
import '../models/operation.dart';

class QueryOperationServiceAdapter<M> implements QueryOperationService<M> {

  DatabaseHelper helper = DatabaseHelper.instance;

  @override
  Future<List<Operation>> readAll() async {
    Database db = await helper.database;
    List<Operation> result = List();
    List<Map> maps = await db.query(DBValues.tableOperations,
        columns: [DBValues.opId, DBValues.opTitle, DBValues.opDescription, DBValues.opDate, DBValues.opStatus, DBValues.opCoordinates]);
    if (maps.length > 0) {
      maps.forEach((map) => {
        result.add(Operation.fromMap(map))
      });
    }
    return result;
  }

  @override
  Future<Operation> read(int id) async {
    Database db = await helper.database;
    List<Map> maps = await db.query(DBValues.tableOperations,
        columns: [DBValues.opId, DBValues.opTitle, DBValues.opDescription, DBValues.opDate, DBValues.opStatus, DBValues.opCoordinates],
        where: '${DBValues.opId} = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return Operation.fromMap(maps.first);
    }
    return null;
  }


}