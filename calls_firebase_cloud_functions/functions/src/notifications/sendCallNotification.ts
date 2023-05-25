import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import axios, { AxiosError } from "axios";
import { handleAxiosError } from "../utils/handleAxiosError";
import { CallData } from "./callData";

const oneSignalNotificationUrl = "https://onesignal.com/";

export const sendCallNotificationHandler = async (
  data: any,
  context: functions.https.CallableContext
) => {
  const callerId = context.auth?.uid;
  if (!callerId) {
    throw new functions.https.HttpsError(
      "unauthenticated",
      "Can't get the caller id from request."
    );
  }

  const databaseRef = admin.firestore();

  const callerDoc = await databaseRef.doc(`/users/${callerId}`).get();
  const callerData = callerDoc.data();
  if (!callerDoc.exists || !callerData) {
    throw new functions.https.HttpsError(
      "not-found",
      "Caller with provided id wasn't found."
    );
  }

  const calleeId = data.calleeId;

  const calleeDoc = await databaseRef.doc(`/users/${calleeId}`).get();
  const calleeData = calleeDoc.data();
  if (!calleeDoc.exists || !calleeData) {
    throw new functions.https.HttpsError(
      "not-found",
      "Callee with provided id wasn't found."
    );
  }

  const callData = new CallData(
    callerId,
    calleeId,
    "1",
    callerData.phoneNumber,
    callerData.name,
    data.hasVideo
  );

  const userPlatform = calleeData.platform;

  if (userPlatform === "IOS") {
    await sendIosCallVoipNotification(callData);
  } else if (userPlatform === "Android") {
    await sendAndroidCallNotification(callData);
  } else {
    throw new functions.https.HttpsError(
      "unimplemented",
      `Send call notification is not supported for ${userPlatform}.`
    );
  }
};

const sendIosCallVoipNotification = async (
  callData: CallData
): Promise<void> => {
  const oneSignalVoipAppId = process.env.ONE_SIGNAL_VOIP_APP_ID;
  const oneSignalVoipRestApiKey = process.env.ONE_SIGNAL_VOIP_REST_API_KEY;

  if (!oneSignalVoipAppId || !oneSignalVoipRestApiKey) {
    throw new functions.https.HttpsError("internal", "API keys not found.");
  }

  const instance = axios.create({
    baseURL: oneSignalNotificationUrl,
    headers: {
      accept: "application/json",
      Authorization: `Basic ${oneSignalVoipRestApiKey}`,
      "content-type": "application/json",
    },
  });

  try {
    await instance.post("api/v1/notifications", {
      app_id: oneSignalVoipAppId,
      include_aliases: {
        external_id: [callData.calleeId],
      },
      target_channel: "push",
      contents: { en: `${callData.callerPhone} is calling you` },
      data: {
        caller_id: callData.callerId,
        channel_id: callData.channelId,
        caller_phone: callData.callerPhone,
        caller_name: callData.callerName,
        has_video: callData.hasVideo,
      },
    });
  } catch (error: any | AxiosError) {
    if (axios.isAxiosError(error)) {
      handleAxiosError(error);
    } else {
      functions.logger.error(error);
    }

    throw new functions.https.HttpsError(
      "internal",
      "OneSignal request failed."
    );
  }
};

const sendAndroidCallNotification = async (
  callData: CallData
): Promise<void> => {
  const oneSignalAppId = process.env.ONE_SIGNAL_APP_ID;
  const oneSignalRestApiKey = process.env.ONE_SIGNAL_REST_API_KEY;

  if (!oneSignalAppId || !oneSignalRestApiKey) {
    throw new functions.https.HttpsError("internal", "API keys not found.");
  }

  const instance = axios.create({
    baseURL: oneSignalNotificationUrl,
    headers: {
      accept: "application/json",
      Authorization: `Basic ${oneSignalRestApiKey}`,
      "content-type": "application/json",
    },
  });

  try {
    await instance.post("api/v1/notifications", {
      app_id: oneSignalAppId,
      include_aliases: {
        external_id: [callData.calleeId],
      },
      target_channel: "push",
      contents: { en: `Phone number - ${callData.callerPhone}` },
      headings: { en: `${callData.callerName} is calling you` },
      data: {
        notification_type: "CALL_INVITATION",
        caller_id: callData.callerId,
        channel_id: callData.channelId,
        caller_phone: callData.callerPhone,
        caller_name: callData.callerName,
        has_video: callData.hasVideo,
      },
    });
  } catch (error: any | AxiosError) {
    if (axios.isAxiosError(error)) {
      handleAxiosError(error);
    } else {
      functions.logger.error(error);
    }

    throw new functions.https.HttpsError(
      "internal",
      "OneSignal request failed."
    );
  }
};
