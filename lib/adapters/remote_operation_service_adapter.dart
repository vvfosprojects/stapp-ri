import '../models/operation.dart';
import '../ports/remote_operation_service.dart';

class RemoteOperationServiceAdapter implements RemoteOperationService{

  @override
  Future<String> send(Operation operation, {String qrCode, String otp}) async {
    // TODO: implement send
  }

}