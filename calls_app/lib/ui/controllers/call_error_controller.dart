import 'dart:async';

import 'package:injectable/injectable.dart';

/// Controller for errors that occur during a call.
@lazySingleton
class CallErrorController {
  final _callErrorStream = StreamController<Object>();

  Stream<Object> get callErrorStream => _callErrorStream.stream;

  void addCallError(Object error) {
    _callErrorStream.add(error);
  }
}
