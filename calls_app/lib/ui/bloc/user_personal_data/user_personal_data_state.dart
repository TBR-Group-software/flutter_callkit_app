part of 'user_personal_data_cubit.dart';

@immutable
abstract class UserPersonalDataState {}

class UserPersonalDataInitial extends UserPersonalDataState {}

class UserPersonalDataLoading extends UserPersonalDataState {}

class UserPersonalDataLoadingError extends UserPersonalDataState {
  UserPersonalDataLoadingError(this.error);

  final Object error;
}

class UserPersonalDataLoaded extends UserPersonalDataState {
  UserPersonalDataLoaded(this.user);

  final User user;
}

class UserPersonalDataUpdating extends UserPersonalDataLoaded {
  UserPersonalDataUpdating(super.user);
}

class UserPersonalDataUpdatingError extends UserPersonalDataLoaded {
  UserPersonalDataUpdatingError(this.error, super.user);

  final Object error;
}
