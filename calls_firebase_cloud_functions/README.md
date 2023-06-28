### in-app-calls-demo

Cloud functions needed for TBR Group in-app calls application.

## Code Formatter

- Use Prettier as the Default Formatter
- Disable ESLint

## Project Environment

The project uses 6 secret keys:

- AGORA_RTC_APP_ID — [Agora app ID](https://docs.agora.io/en/voice-calling/reference/manage-agora-account?platform=android#get-the-app-id).
- AGORA_RTC_CERTIFICATE — [Agora app certificate](https://docs.agora.io/en/voice-calling/reference/manage-agora-account?platform=android#get-the-app-certificate).
- ONE_SIGNAL_APP_ID — [OneSignal app ID](https://documentation.onesignal.com/docs/keys-and-ids#app-id) for 1st OneSignal app.
- ONE_SIGNAL_REST_API_KEY — [OneSignal REST API key](https://documentation.onesignal.com/docs/keys-and-ids#rest-api-key) for 1st OneSignal app.
- ONE_SIGNAL_VOIP_APP_ID — [OneSignal app ID](https://documentation.onesignal.com/docs/keys-and-ids#app-id) for 2nd OneSignal app.
- ONE_SIGNAL_VOIP_REST_API_KEY — [OneSignal REST API key](https://documentation.onesignal.com/docs/keys-and-ids#rest-api-key) for 2nd OneSignal app
.
Note: 1st and 2nd OneSignal apps are required according to OneSignal [documentation](https://documentation.onesignal.com/docs/voip-notifications#2-create-a-new-onesignal-app-for-your-voip-device-subscribers).

The project secretes are stored in the [Secret Manager](https://cloud.google.com/secret-manager/docs/overview).
So you need to add your secrets to the Secret Manager before or during the cloud function deployment to make them work.

## Deployment

To build Cloud Functions, the following have to be installed:

- [NodeJS 16](https://nodejs.org/)
- [Firebase CLI](https://firebase.google.com/docs/cli)

Follow these steps to prepare your functions and deploy:

- Switch your project to there you want to deploy cloud functions

```console
// $PROJECT_ID is a Firebase Project ID (like 'in-app-calls-demo')
firebase use $PROJECT_ID
```

- Install node modules

```shell
cd functions && npm install
```

- Run deploy script

```shell
cd functions && npm run deploy
```