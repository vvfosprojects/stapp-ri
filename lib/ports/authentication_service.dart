import '../models/user.dart';

abstract class AuthenticationService {

  Future<User> authenticate(String username, String password) async {}

  Future<bool> isAuthenticated(User user) async {}

}