class CallData {
  CallData({
    required this.channelId,
    required this.callerId,
    required this.callerPhone,
    required this.callerName,
    required this.hasVideo,
  });

  factory CallData.fromMap(Map<String, dynamic> data) {
    return CallData(
      channelId: data['channelId'] as String?,
      callerId: data['callerId'] as String?,
      callerPhone: data['callerPhone'] as String?,
      callerName: data['callerName'] as String?,
      hasVideo: data['hasVideo'] as bool?,
    );
  }

  final String? channelId;
  final String? callerId;
  final String? callerPhone;
  final String? callerName;
  final bool? hasVideo;
}
