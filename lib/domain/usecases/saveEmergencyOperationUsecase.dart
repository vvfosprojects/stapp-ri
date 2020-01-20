import 'package:stapp_ri/domain/entities/emergency_operation.dart';
import 'package:stapp_ri/domain/ports/command_operation_service.dart';
import 'package:stapp_ri/domain/ports/save_em_op_usecase_port.dart';

class SaveEmergencyOperationUsecase implements SaveEmOpUsecasePort {
  CommandOperationService operationService;

  SaveEmergencyOperationUsecase(CommandOperationService operationService) {
    this.operationService = operationService;
  }

  @override
  Future save(EmergencyOperation operation) async {
    var result;
    if (operation.id != null) {
      await operationService.update(operation).then((id) {
        print("Salvataggio operation id: $id");
        result = operation;
      });
    } else {
      await operationService.insert(operation).then((id) {
        print("Inserimento operation id: $id");
        operation.id = id;
        result = operation;
      });
    }
    return result;
  }
}
