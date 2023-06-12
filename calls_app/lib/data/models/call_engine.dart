import 'dart:async';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';

import 'call_error.dart';

class CallEngine {
  CallEngine(this.rtcEngine);

  final RtcEngine rtcEngine;

  /// Receives an event when a remote user joins the channel. Contains the
  /// integer ID of connected users.
  final _remoteUserJoinedController = StreamController<int>();

  /// Receives an event when a remote user become offline. Contains the integer
  /// ID of disconnected users.
  final _remoteUserOfflineController = StreamController<int>();

  /// Receives an event when a user joins successfully joins the channel.
  /// Contains the string channel ID.
  final _userJoinedController = StreamController<String?>();

  /// Receives an event when a an error occurred during the call. Contains the
  /// [CallError].
  final _errorController = StreamController<CallError>();

  Stream<int> get remoteUserJoinedStream => _remoteUserJoinedController.stream;

  Stream<int> get remoteUserOfflineStream =>
      _remoteUserOfflineController.stream;

  Stream<String?> get userJoinedStream => _userJoinedController.stream;

  Stream<CallError> get errorStream => _errorController.stream;

  /// Adds an [userId] to [_remoteUserJoinedController]
  void addRemoteUserJoinedEvent(int userId) =>
      _remoteUserJoinedController.add(userId);

  /// Adds an [userId] to [_remoteUserOfflineController]
  void addRemoteUserOfflineEvent(int userId) =>
      _remoteUserOfflineController.add(userId);

  /// Adds an [channelId] to [_userJoinedController]
  void addUserJoinedEvent(String? channelId) =>
      _userJoinedController.add(channelId);

  /// Adds an [error] to [_errorController]
  void addErrorEvent(CallError error) => _errorController.add(error);

  Future<void> release() async {
    await rtcEngine.release();

    await Future.wait<void>([
      _remoteUserJoinedController.close(),
      _remoteUserOfflineController.close(),
      _userJoinedController.close(),
      _errorController.close(),
    ]);
  }
}
