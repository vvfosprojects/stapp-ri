import 'package:stapp_ri/domain/entity/emergency_operation.dart';
import 'package:stapp_ri/domain/ports/remote_operation_service.dart';

class RemoteOperationServiceAdapter implements RemoteOperationService{

  @override
  Future<String> send(EmergencyOperation operation, {String qrCode, String otp}) async {
    // TODO: implement send
  }

}