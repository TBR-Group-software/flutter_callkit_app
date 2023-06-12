import 'package:agora_rtc_engine/agora_rtc_engine.dart';

class CallError {
  CallError({required this.code, required this.message});

  final ErrorCodeType code;
  final String message;
}
