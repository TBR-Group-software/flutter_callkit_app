export class CallData {
  readonly callerId: string;
  readonly calleeId: string;
  readonly channelId: string;
  readonly callerPhone: string | undefined;
  readonly callerName: string | undefined;
  readonly hasVideo: boolean | undefined;

  constructor(
    callerId: string,
    calleeId: string,
    channelId: string,
    callerPhone: string | undefined,
    callerName: string | undefined,
    hasVideo: boolean | undefined
  ) {
    this.callerId = callerId;
    this.calleeId = calleeId;
    this.channelId = channelId;
    this.callerPhone = callerPhone;
    this.callerName = callerName;
    this.hasVideo = hasVideo;
  }
}
