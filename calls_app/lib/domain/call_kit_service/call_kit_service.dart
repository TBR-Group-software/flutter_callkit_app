import 'dart:async';

import '../../data/models/call_data.dart';

abstract class CallKitService {
  /// Returns true if telecom services were enabled successfully, false if
  /// something went wrong during services setup.
  Future<bool> initTelecomServices();

  Future<CallData?> launchCallData();

  StreamSubscription<CallData> listenAcceptedCalls(
    void Function(CallData callData) onData, {
    void Function(Object e, StackTrace s)? onError,
    void Function()? onDone,
    bool? cancelOnError,
  });
}
