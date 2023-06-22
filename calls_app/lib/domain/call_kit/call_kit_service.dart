import 'dart:async';

import '../../data/models/call_data.dart';

abstract class CallKitService {
  /// Returns true if telecom services were enabled successfully, false if
  /// something went wrong during services setup.
  Future<bool> initTelecomServices();

  Future<CallData?> launchCallData();

  Stream<CallData> get acceptedCallsStream;
}
