import '../../models/user.dart';

abstract class UserGateWay {
  Future<User?> getCurrentUser();

  Future<void> addUser(User user);

  Future<User?> findUserByPhoneNumber(String phoneNumber);
}
