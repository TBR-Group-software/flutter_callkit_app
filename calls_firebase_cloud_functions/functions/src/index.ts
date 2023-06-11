import * as admin from "firebase-admin";
import * as functions from "firebase-functions";
import { sendCallNotificationHandler } from "./notifications/sendCallNotification";
import * as config from "./utils/config";
import { crateCallTokenHandler } from "./calls/create_call_token";

admin.initializeApp();

export const sendCallNotification = functions
  .runWith({
    secrets: [
      config.AGORA_RTC_APP_ID.name,
      config.AGORA_RTC_CERTIFICATE.name,
      config.ONE_SIGNAL_APP_ID.name,
      config.ONE_SIGNAL_REST_API_KEY.name,
      config.ONE_SIGNAL_VOIP_APP_ID.name,
      config.ONE_SIGNAL_VOIP_REST_API_KEY.name,
    ],
  })
  .https.onCall(sendCallNotificationHandler);

export const crateCallToken = functions
  .runWith({
    secrets: [config.AGORA_RTC_APP_ID.name, config.AGORA_RTC_CERTIFICATE.name],
  })
  .https.onCall(crateCallTokenHandler);
