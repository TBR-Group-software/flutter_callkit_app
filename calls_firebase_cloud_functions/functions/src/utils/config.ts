import { defineSecret } from "firebase-functions/params";

export const AGORA_RTC_APP_ID = defineSecret("AGORA_RTC_APP_ID");
export const AGORA_RTC_CERTIFICATE = defineSecret("AGORA_RTC_CERTIFICATE");

export const ONE_SIGNAL_APP_ID = defineSecret("ONE_SIGNAL_APP_ID");
export const ONE_SIGNAL_REST_API_KEY = defineSecret("ONE_SIGNAL_REST_API_KEY");

export const ONE_SIGNAL_VOIP_APP_ID = defineSecret("ONE_SIGNAL_VOIP_APP_ID");
export const ONE_SIGNAL_VOIP_REST_API_KEY = defineSecret(
  "ONE_SIGNAL_VOIP_REST_API_KEY"
);
