import * as functions from "firebase-functions";
import { buildRtcToken } from "./build_rtc_token";

export const crateCallTokenHandler = async (
  data: any,
  context: functions.https.CallableContext
) => {
  const userId = context.auth?.uid;
  if (!userId) {
    throw new functions.https.HttpsError(
      "unauthenticated",
      "Can't get the caller id from request."
    );
  }

  const channelId = data.channelId;

  if (typeof channelId !== "string") {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "channelId should be a string."
    );
  }

  const callToken = buildRtcToken(userId, channelId);

  return {
    token: callToken,
  };
};
