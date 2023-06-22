import 'package:injectable/injectable.dart';

import '../../models/channel_data.dart';
import '../firebase/firebase_initializer_gate_way.dart';
import 'call_gate_way.dart';

@LazySingleton(as: CallGateWay)
class FirebaseCallGateWay implements CallGateWay {
  FirebaseCallGateWay(this._firebaseInitializer);

  final FirebaseInitializerGateWay _firebaseInitializer;

  final _sendCallNotificationEndpoint = 'sendCallNotification';
  final _crateCallTokenEndpoint = 'crateCallToken';

  @override
  Future<ChannelData> initiateCall(String calleeId) async {
    final functions = await _firebaseInitializer.functions;

    final result = await functions
        .httpsCallable(_sendCallNotificationEndpoint)
        .call<Map<String, dynamic>>(
      <String, dynamic>{
        'calleeId': calleeId,
      },
    );

    final data = result.data;
    final channelData = ChannelData.fromMap(data);

    return channelData;
  }

  @override
  Future<String> getChannelToken(String channelId) async {
    final functions = await _firebaseInitializer.functions;

    final result = await functions
        .httpsCallable(_crateCallTokenEndpoint)
        .call<Map<String, dynamic>>(
      <String, dynamic>{
        'channelId': channelId,
      },
    );

    final data = result.data;
    final token = data['token'] as String;

    return token;
  }
}
