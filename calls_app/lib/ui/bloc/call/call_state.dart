part of 'call_bloc.dart';

@immutable
abstract class CallState {}

/// Indicates that there is no call currently.
class CallInitial extends CallState {}

/// Indicates that the error occurred during call initialization.
class CallInitializeError extends CallInitial {
  CallInitializeError(this.error);

  final Object error;
}

/// Indicates that the user is in a call now.
class CallActive extends CallState {
  CallActive(
    this._callService,
    this._engine, {
    required this.remoteUsers,
    this.channelId,
  });

  final CallService _callService;
  final CallEngine _engine;

  final List<int> remoteUsers;

  /// Contains the channelId of the call. Will be set only after user
  /// successfully joins the channel.
  final String? channelId;

  RtcEngine get rtcEngine => _engine.rtcEngine;

  CallActive copyWith({
    List<int>? remoteUsers,
    String? channelId,
  }) {
    return CallActive(
      _callService,
      _engine,
      remoteUsers: remoteUsers ?? this.remoteUsers,
      channelId: channelId ?? this.channelId,
    );
  }
}

/// Indicates that the call was ended.
class CallEnded extends CallState {}
