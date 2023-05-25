import * as admin from "firebase-admin";
import * as functions from "firebase-functions";
import { sendCallNotificationHandler } from "./notifications/sendCallNotification";
import * as config from "./utils/config";

admin.initializeApp();

export const sendCallNotification = functions
  .runWith({
    secrets: [
      config.ONE_SIGNAL_APP_ID.name,
      config.ONE_SIGNAL_REST_API_KEY.name,
      config.ONE_SIGNAL_VOIP_APP_ID.name,
      config.ONE_SIGNAL_VOIP_REST_API_KEY.name,
    ],
  })
  .https.onCall(sendCallNotificationHandler);
