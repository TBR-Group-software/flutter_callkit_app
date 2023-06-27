import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../data/models/user.dart';
import '../../../domain/user/user_service.dart';

part 'user_personal_data_state.dart';

@injectable
class UserPersonalDataCubit extends Cubit<UserPersonalDataState> {
  UserPersonalDataCubit(this._userServices) : super(UserPersonalDataInitial()) {
    _loadPersonalData();
  }

  final UserService _userServices;

  Future<void> _loadPersonalData() async {
    emit(UserPersonalDataLoading());

    try {
      final user = await _userServices.getCurrentUser();
      if (user == null) {
        emit(UserPersonalDataLoadingError('There is no signed in user'));
        return;
      }

      final userData = await _userServices.findUserById(user.id);
      if (userData == null) {
        emit(UserPersonalDataLoadingError('There is no user data'));
        return;
      }

      emit(UserPersonalDataLoaded(userData));
    } catch (e) {
      emit(UserPersonalDataLoadingError(e));
    }
  }

  Future<void> changeUserName(String firstName, String lastName) async {
    final localState = state;
    if (localState is! UserPersonalDataLoaded) {
      return;
    }

    final name = '$firstName $lastName'.trim();
    final newUser = localState.user.copyWith(name: name);
    emit(UserPersonalDataUpdating(newUser));

    try {
      await _userServices.addUserName(newUser.id, name);
      emit(UserPersonalDataLoaded(newUser));
    } catch (e) {
      emit(UserPersonalDataUpdatingError(e, newUser));
    }
  }
}
