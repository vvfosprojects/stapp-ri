
import '../models/operation.dart';

abstract class QueryOperationService<M> {

  Future<Operation> read(int id) async {}

  Future<List<Operation>> readAll() async {}

}