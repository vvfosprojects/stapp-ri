import 'package:stapp_ri/domain/entity/emergency_operation.dart';

abstract class QueryOperationService<M> {

  Future<EmergencyOperation> read(int id) async {}

  Future<List<EmergencyOperation>> readAll() async {}

}