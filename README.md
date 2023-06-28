# About the project

The purpose of the project is to create a telecommunication app where users can make video calls to each other. The
project consists of 2 parts: the [mobile app](calls_app) and the [backend](calls_firebase_cloud_functions).

The mobile app was built with Flutter and works both on Android and iOS. The backend was built with Firebase and uses
Cloud Functions written in TypeScript.

// TODO: Add 3 gifs: sign in, receiving a call, answering a call

## Features

- Video calls.
- Receive calls in all app states: foreground, background, terminated.
- iOS VoIP push notifications.
- Android push notifications.
- Phone authentication.

## Built with

- [Flutter](https://flutter.dev/) — cross-platform UI framework for building beautiful apps with a signe code base.
- [OneSignal](https://onesignal.com/) — push notifications service.
- [Agora](https://www.agora.io/en/) — real-time video calls provider.
- [Firebase](https://firebase.google.com/) — backend as a service.
- [Cloud Functions](https://firebase.google.com/docs/functions) — serverless functions.
- [ConnectionService](https://developer.android.com/reference/android/telecom/ConnectionService) — Android API for
  managing phone calls.
- [CallKit](https://developer.apple.com/documentation/callkit) — iOS API for managing phone calls.

# How it works

## App states

The main difference between the general app and the telecommunication app is that the telecommunication app should work
in the background and even when the app is terminated. The user should be able to receive a call and answer it in any
app state.

There are 3 possible app states:

- Foreground — the app is opened and active. Flutter code is running.
- Background — the app is opened but not active. Flutter code is running but the user doesn't see the app UI.
- Terminated — the app is not opened. Flutter code is not running.

### Notifications

To receive a phone call the app uses push notifications. For Android
the [OneSignal Android Notification Service Extension](https://documentation.onesignal.com/docs/service-extensions#android-notification-service-extension)
is implemented to receive push notifications. For iOS
the [VoIP notifications](https://developer.apple.com/documentation/pushkit/responding_to_voip_notifications_from_pushkit/)
are used. Both these methods allow to receive push notifications in all app states.

### CallKit

To show the incoming call after receiving a push notification the app
uses [CallKit](https://developer.apple.com/documentation/callkit) for iOS
and [ConnectionService](https://developer.android.com/reference/android/telecom/ConnectionService) for Android. It
allows to show the incoming call screen with answer and decline options for user. For Android the custom implementation
for [ConnectionService](calls_app/android/app/src/main/kotlin/com/tbrgroup/in_app_calls_demo/connection_service/CallConnectionService.kt)
and [Connection](calls_app/android/app/src/main/kotlin/com/tbrgroup/in_app_calls_demo/connection_service/CallConnection.kt)
are written. On iOS the [flutter_callkit_voximplant](https://pub.dev/packages/flutter_callkit_voximplant) package is
used to integrate CallKit.

// TODO: Add Android&iOS call screens

### Launch the app

When the user answered a call the video call should start. If the app is in the background or terminated state then it
should be returned to foreground so user can see the video call screen. If the app is already in foreground it can just
show the video call screen.

// TODO: App launch scheme

## Video calls

To launch a video call between two users the app uses [Agora](https://www.agora.io/en/) as a real-time video calls
provider. Joining a video call is based on
the [token authentication](https://docs.agora.io/en/video-calling/develop/integrate-token-generation?platform=android).

// TODO: Video call screenshots?

## Push notifications service

[OneSignal](https://onesignal.com/) is used to send push and VoIP notifications to the app. Under the hood it
uses [Firebase Cloud Messaging](https://firebase.google.com/docs/cloud-messaging) for Android
and [APNs](https://developer.apple.com/documentation/usernotifications/setting_up_a_remote_notification_server/sending_notification_requests_to_apns)
for iOS. Regarding the
OneSignal [documentation](https://documentation.onesignal.com/docs/voip-notifications#2-create-a-new-onesignal-app-for-your-voip-device-subscribers)
the iOS VoIP setup requires to create a new OneSignal app. So in the project implementation 2 OneSignal apps are used:
one for Android push notifications and one for iOS VoIP notifications.

## Cloud Functions

The backend is built with Firebase and uses Cloud Functions written in TypeScript. There are 2 main features that
backend provides:

1. Send push notifications to the app.
2. Generate Agora tokens to join a video call.

It uses [Secret Manager](https://cloud.google.com/secret-manager/docs/overview) to store the project secrets such as:

- Agora app ID and app certificate.
- OneSignal 1st app ID and REST API key (for general push notifications).
- OneSignal 2nd app ID and REST API key (for VoIP notifications).