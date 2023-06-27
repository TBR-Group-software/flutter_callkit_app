import 'package:injectable/injectable.dart';

import '../../data/gate_ways/user/user_gate_way.dart';
import '../../data/models/user.dart';
import 'user_service.dart';

@LazySingleton(as: UserService)
class UserServiceImpl implements UserService {
  UserServiceImpl(this._userGateWay);

  final UserGateWay _userGateWay;

  @override
  Future<User?> getCurrentUser() => _userGateWay.getCurrentUser();

  @override
  Future<void> addUserName(String id, String name) =>
      _userGateWay.addUserName(id, name);

  @override
  Future<User?> findUserById(String id) => _userGateWay.findUserById(id);
}
