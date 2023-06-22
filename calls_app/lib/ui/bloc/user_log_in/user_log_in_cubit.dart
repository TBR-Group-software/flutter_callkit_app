import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/user/user_service.dart';

part 'user_log_in_state.dart';

@injectable
class UserLogInCubit extends Cubit<UserLogInState> {
  UserLogInCubit(this._userServices) : super(UserLogInInitial()) {
    _checkLogIn();
  }

  final UserService _userServices;

  Future<void> _checkLogIn() async {
    emit(UserLogInLoading());
    final user = await _userServices.getCurrentUser();

    if (user == null) {
      emit(UserLoggedOut());
    } else {
      emit(UserLoggedIn());
    }
  }
}
