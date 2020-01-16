
import 'package:stapp_ri/domain/entity/emergency_operation.dart';

abstract class RemoteOperationService {
  
  Future<String> send(EmergencyOperation operation, {String qrCode, String otp}) async {}

}