import 'package:flutter_test/flutter_test.dart';
import 'package:stapp_ri/domain/entities/emergency_operation.dart';
import 'package:stapp_ri/data/adapters/query_operation_service_adapter.dart';


void main(){
  test("Query Emergency Operation", () async {
    TestWidgetsFlutterBinding.ensureInitialized();
    QueryOperationServiceAdapter adapter = QueryOperationServiceAdapter();
    List<EmergencyOperation> result = await adapter.readAll();
    assert(result[0].media.length>0);
  }
  
  );
}
