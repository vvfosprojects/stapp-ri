import 'package:stapp_ri/domain/entities/emergency_operation.dart';

abstract class SaveEmOpUsecasePort {

  Future save(EmergencyOperation operation);

}