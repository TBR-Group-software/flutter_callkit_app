part of 'call_bloc.dart';

@immutable
abstract class CallEvent {}

/// Initiates a call as a caller.
class InitiateCall extends CallEvent {
  InitiateCall(this.phoneNumber);

  final String phoneNumber;
}

/// Joins a call as a callee.
class JoinCall extends CallEvent {
  JoinCall(this.callData);

  final CallData callData;
}

class _AddRemoteUser extends CallEvent {
  _AddRemoteUser(this.uid);

  final int uid;
}

class _RemoveRemoteUser extends CallEvent {
  _RemoveRemoteUser(this.uid);

  final int uid;
}

class _JoinChannel extends CallEvent {
  _JoinChannel(this.channelId);

  final String? channelId;
}

class LeaveCall extends CallEvent {}

class ChangeMicrophoneMode extends CallEvent {
  ChangeMicrophoneMode({required this.mute});

  final bool mute;
}

class SwitchCamera extends CallEvent {}

class ChangeVideoMode extends CallEvent {
  ChangeVideoMode({required this.disable});

  final bool disable;
}
