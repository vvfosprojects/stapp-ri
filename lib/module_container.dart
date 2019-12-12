import 'package:flutter_simple_dependency_injection/injector.dart';
import './adapters/command_operation_service_adapter.dart';
import './ports/command_operation_service.dart';
import './adapters/query_operation_service_adapter.dart';
import './ports/query_operation_service.dart';

/// Dependency Injection Configuration
class ModuleContainer {

  Injector initialise(Injector injector) {

    injector.map<CommandOperationService>((i) => CommandOperationServiceAdapter(), isSingleton: true);
    injector.map<QueryOperationService>((i) => QueryOperationServiceAdapter(), isSingleton: true);

    // injector.map<String>((i) => "https://api.com/", key: "apiUrl");
    // injector.map<SomeService>((i) => SomeService(i.get<Logger>(), i.get<String>(key: "apiUrl")));

    return injector;
  }

}
