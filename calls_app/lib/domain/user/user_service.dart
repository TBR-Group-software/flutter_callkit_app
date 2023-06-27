import '../../data/models/user.dart';

abstract class UserService {
  Future<User?> getCurrentUser();

  Future<void> addUserName(String id, String name);

  Future<User?> findUserById(String id);
}
