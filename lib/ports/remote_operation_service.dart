import '../models/operation.dart';

abstract class RemoteOperationService {
  
  Future<String> send(Operation operation, {String qrCode, String otp}) async {}

}