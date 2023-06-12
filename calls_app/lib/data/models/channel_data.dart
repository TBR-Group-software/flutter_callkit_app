class ChannelData {
  ChannelData({required this.channelId, required this.token});

  factory ChannelData.fromMap(Map<String, dynamic> data) {
    return ChannelData(
      channelId: data['channelId'] as String,
      token: data['token'] as String,
    );
  }

  final String channelId;
  final String token;
}
