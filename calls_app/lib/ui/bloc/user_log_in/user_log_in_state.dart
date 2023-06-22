part of 'user_log_in_cubit.dart';

@immutable
abstract class UserLogInState {}

class UserLogInInitial extends UserLogInState {}

class UserLogInLoading extends UserLogInState {}

class UserLoggedIn extends UserLogInState {}

class UserLoggedOut extends UserLogInState {}
