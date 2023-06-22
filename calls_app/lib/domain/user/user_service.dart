import '../../data/models/user.dart';

abstract class UserService {
  Future<User?> getCurrentUser();
}
