import 'dart:async';

import 'package:injectable/injectable.dart';

import '../../data/models/call_data.dart';

@lazySingleton
class CallController {
  final _callDataStream = StreamController<CallData>();

  Stream<CallData> get callDataStream => _callDataStream.stream;

  void addCallData(CallData callData) {
    _callDataStream.add(callData);
  }
}
