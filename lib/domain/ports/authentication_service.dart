
import 'package:stapp_ri/domain/entity/user.dart';

abstract class AuthenticationService {

  Future<User> authenticate(String username, String password) async {}

  Future<bool> isAuthenticated(User user) async {}

}