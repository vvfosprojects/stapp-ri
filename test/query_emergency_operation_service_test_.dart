import 'package:flutter_test/flutter_test.dart';
import 'package:stapp_ri/adapters/query_operation_service_adapter.dart';
import 'package:stapp_ri/domain/entity/emergency_operation.dart';


void main(){
  test("Query Emergency Operation", () async {
    TestWidgetsFlutterBinding.ensureInitialized();
    QueryOperationServiceAdapter adapter = QueryOperationServiceAdapter();
    List<EmergencyOperation> result = await adapter.readAll();
    assert(result[0].media.length>0);
  }
  
  );
}
