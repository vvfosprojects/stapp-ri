import 'package:flutter_simple_dependency_injection/injector.dart';
import 'package:stapp_ri/domain/ports/command_operation_service.dart';
import 'package:stapp_ri/domain/ports/query_operation_service.dart';
import 'package:stapp_ri/data/adapters/command_operation_service_adapter.dart';
import 'package:stapp_ri/data/adapters/query_operation_service_adapter.dart';
import 'package:stapp_ri/domain/ports/save_em_op_usecase_port.dart';
import 'package:stapp_ri/domain/usecases/saveEmergencyOperationUsecase.dart';

/// Dependency Injection Configuration
class ModuleContainer {

  Injector initialise(Injector injector) {

    injector.map<CommandOperationService>((i) => CommandOperationServiceAdapter(), isSingleton: true);
    injector.map<QueryOperationService>((i) => QueryOperationServiceAdapter(), isSingleton: true);
    injector.map<SaveEmOpUsecasePort>((i) => SaveEmergencyOperationUsecase(
      injector.get<CommandOperationService>()
    ));

    // injector.map<String>((i) => "https://api.com/", key: "apiUrl");
    // injector.map<SomeService>((i) => SomeService(i.get<Logger>(), i.get<String>(key: "apiUrl")));

    return injector;
  }

}
