import 'dart:async';

import 'package:injectable/injectable.dart';

import '../../data/models/call_data.dart';

/// Controller for errors that occur getting the [CallData] from OS level.
@lazySingleton
class CallDataErrorController {
  final _callDataErrorStream = StreamController<Object>();

  Stream<Object> get callDataErrorStream => _callDataErrorStream.stream;

  void addCallError(Object error) {
    _callDataErrorStream.add(error);
  }
}
