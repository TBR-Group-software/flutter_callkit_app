### in_app_calls_demo

TBR Group in-app calls application.

## Requirements

To run this project you need to have:

- Flutter SDK minimum version 3.10.2
- Dart SDK minimum version 3.0.2

## Getting Started

To configure this project you need to have:

- Firebase project with enabled [Phone Authentication](https://firebase.google.com/docs/auth/flutter/phone-auth)
  and [Cloud Firestore](https://firebase.google.com/docs/firestore/quickstart).
- Two [OneSignal](https://onesignal.com/) apps: one for Android push notifications and one for iOS VoIP notifications
- [Agora](https://www.agora.io/en/) project.

### Firebase

1. Create a [Firebase project](https://console.firebase.google.com/).
2. Set up Android and iOS apps in the Firebase project settings.
3. Enable [Phone Authentication](https://firebase.google.com/docs/auth/flutter/phone-auth).
4. Enable a [Cloud Firestore](https://firebase.google.com/docs/firestore/quickstart) database.
5. Replace [google-services.json](android/app/google-services.json) with your own Android services file from Firebase
   project settings.
6. Replace [GoogleService-Info.plist](ios/Runner/GoogleService-Info.plist) with your own iOS services file from Firebase
   project settings.

### OneSignal

1. [Setup 1st OneSignal app](https://documentation.onesignal.com/docs/generate-a-google-server-api-key) for Android push
   notifications.
2. [Setup 2nd OneSignal app](https://documentation.onesignal.com/docs/generate-an-ios-push-certificate) for iOS VoIP
   notifications. Use VoIP Services Certificate as your APNs Certificate as mentioned
   in [documentation](https://documentation.onesignal.com/docs/generate-an-ios-push-certificate).

### Agora

1. Create an [Agora project](https://docs.agora.io/en/video-calling/reference/manage-agora-account?platform=android#create-an-agora-project).
2. Enable [App Certificate](https://docs.agora.io/en/video-calling/reference/manage-agora-account?platform=android#get-the-app-certificate).

### Project Environment

The app uses 3 environment variables:

- oneSignalKey — [OneSignal app ID](https://documentation.onesignal.com/docs/keys-and-ids#app-id) for Android push
  notifications OneSignal app.
- oneSignalVoipKey — [OneSignal app ID](https://documentation.onesignal.com/docs/keys-and-ids#app-id) for iOS VoIP
  notifications OneSignal app.
- agoraRtcAppId — [Agora app ID](https://docs.agora.io/en/voice-calling/reference/manage-agora-account?platform=android#get-the-app-id).

See [environment_config.yaml](environment_config.yaml) file. Replace the values with your own. Run the script to
generate environment variables:

```shell
make generate_env
```

### Run the app

```shell
flutter pub get && flutter run
```
