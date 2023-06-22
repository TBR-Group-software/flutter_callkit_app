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
}
