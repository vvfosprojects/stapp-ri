import '../models/emergency_operation.dart';
import '../ports/remote_operation_service.dart';

class RemoteOperationServiceAdapter implements RemoteOperationService{

  @override
  Future<String> send(EmergencyOperation operation, {String qrCode, String otp}) async {
    // TODO: implement send
  }

}