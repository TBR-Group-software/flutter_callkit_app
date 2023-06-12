import '../../models/channel_data.dart';

abstract class CallGateWay {
  /// Initiates a call to another user, [calleeId] is equal to the ID of the
  /// user you want to call. Returns the data to join the call channel.
  Future<ChannelData> initiateCall(String calleeId);

  /// Returns a token to join the channel with [channelId].
  Future<String> getChannelToken(String channelId);
}
