part of 'call_kit_cubit.dart';

@immutable
abstract class CallKitState {}

class CallKitInitial extends CallKitState {}

class CallKitLoading extends CallKitState {}

class CallKitError extends CallKitState {
  CallKitError(this.error);

  final Object error;
}

class CallKitInitialized extends CallKitState {}

class CallKitNotInitialized extends CallKitState {}
