import { RtcRole, RtcTokenBuilder } from "agora-token";
import * as functions from "firebase-functions";

const role = RtcRole.PUBLISHER;
const expirationTimeInSeconds = 3600;

export const buildRtcToken = (uid: string, channelId: string): string => {
  const agoraAppId = process.env.AGORA_RTC_APP_ID;
  const agoraCertificate = process.env.AGORA_RTC_CERTIFICATE;

  if (!agoraAppId || !agoraCertificate) {
    throw new functions.https.HttpsError("internal", "API keys not found.");
  }

  const currentTimestamp = Math.floor(Date.now() / 1000);

  const privilegeExpiredTs = currentTimestamp + expirationTimeInSeconds;
  return RtcTokenBuilder.buildTokenWithUserAccount(
    agoraAppId,
    agoraCertificate,
    channelId,
    uid,
    role,
    privilegeExpiredTs,
    privilegeExpiredTs
  );
};
