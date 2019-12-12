import 'package:sqflite/sqflite.dart';
import '../helpers/db_values.dart';
import '../helpers/database_helpers.dart';
import '../ports/command_operation_service.dart';

class CommandOperationServiceAdapter<Operation> implements CommandOperationService {

  DatabaseHelper helper = DatabaseHelper.instance;

  @override
  Future<bool> delete(m) {
    // TODO: implement delete
    return null;
  }

  @override
  Future<int> update(m) {
    // TODO: implement update
    return null;
  }

  @override
  Future<int> save(m) async {
    Database db = await helper.database;
    return db.insert(DBValues.tableOperations, m.toMap());
  }

}