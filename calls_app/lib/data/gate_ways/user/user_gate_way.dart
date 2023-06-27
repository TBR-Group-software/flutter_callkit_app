import '../../models/user.dart';

abstract class UserGateWay {
  Future<User?> getCurrentUser();

  Future<void> addUser(User user);

  Future<void> addUserName(String id, String name);

  Future<User?> findUserByPhoneNumber(String phoneNumber);

  Future<User?> findUserById(String id);
}
