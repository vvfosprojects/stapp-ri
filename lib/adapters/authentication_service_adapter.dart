import 'package:stapp_ri/domain/entity/user.dart';
import 'package:stapp_ri/domain/ports/authentication_service.dart';

class AuthenticationServiceAdapter implements AuthenticationService {
  @override
  Future<User> authenticate(String username, String password) async {
    // TODO: implement authenticate
    return null;
  }

  @override
  Future<bool> isAuthenticated(User user) async {
    // TODO: implement isAuthenticated
    return null;
  }
  

}