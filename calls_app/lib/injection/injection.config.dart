// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../data/gate_ways/call_kit/android_call_kit_gate_way.dart' as _i3;
import '../data/gate_ways/call_kit/ios_call_kit_gate_way.dart' as _i5;
import '../data/gate_ways/calls/call_gate_way.dart' as _i15;
import '../data/gate_ways/calls/firebase_call_gate_way.dart' as _i16;
import '../data/gate_ways/firebase/firebase_initializer_gate_way.dart' as _i4;
import '../data/gate_ways/notifications/one_signal_notifications_gate_way.dart'
    as _i6;
import '../data/gate_ways/notifications/one_signal_voip_notifications_gate_way.dart'
    as _i7;
import '../data/gate_ways/phone_auth/firebase_phone_auth_gate_way.dart' as _i9;
import '../data/gate_ways/phone_auth/phone_auth_gate_way.dart' as _i8;
import '../data/gate_ways/user/firebase_user_gate_way.dart' as _i11;
import '../data/gate_ways/user/user_gate_way.dart' as _i10;
import '../data/gate_ways/video_call/agora_video_call_gate_way.dart' as _i13;
import '../data/gate_ways/video_call/video_call_gate_way.dart' as _i12;
import '../data/gate_ways/voip_token_gate_way.dart' as _i14;
import '../domain/call_kit_service/android_call_kit_service.dart' as _i19;
import '../domain/call_kit_service/call_kit_service.dart' as _i17;
import '../domain/call_kit_service/ios_call_kit_service.dart' as _i18;
import '../domain/calls/callee_call_service.dart' as _i20;
import '../domain/calls/caller_call_service.dart' as _i21;
import '../domain/phone_auth/phone_auth_service.dart' as _i22;
import '../domain/phone_auth/user_phone_auth_service.dart' as _i23;

const String _ios = 'ios';
const String _android = 'android';

extension GetItInjectableX on _i1.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i1.GetIt init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.lazySingleton<_i3.AndroidCallKitGateWay>(
        () => _i3.AndroidCallKitGateWay());
    gh.lazySingleton<_i4.FirebaseInitializerGateWay>(
        () => _i4.FirebaseInitializerGateWay());
    gh.lazySingleton<_i5.IosCallKitGateWay>(() => _i5.IosCallKitGateWay());
    gh.singleton<_i6.OneSignalNotificationsGateWay>(
        _i6.OneSignalNotificationsGateWay());
    gh.singleton<_i7.OneSignalVoipNotificationsGateWay>(
        _i7.OneSignalVoipNotificationsGateWay());
    gh.lazySingleton<_i8.PhoneAuthGateWay>(() =>
        _i9.FirebasePhoneAuthGateWay(gh<_i4.FirebaseInitializerGateWay>()));
    gh.lazySingleton<_i10.UserGateWay>(
        () => _i11.FirebaseUserGateWay(gh<_i4.FirebaseInitializerGateWay>()));
    gh.factory<_i12.VideoCallGateWay>(() => _i13.AgoraVideoCallGateWay());
    gh.singleton<_i14.VoipTokenGateWay>(_i14.VoipTokenGateWay());
    gh.lazySingleton<_i15.CallGateWay>(
        () => _i16.FirebaseCallGateWay(gh<_i4.FirebaseInitializerGateWay>()));
    gh.lazySingleton<_i17.CallKitService>(
      () => _i18.IosCallKitService(
        gh<_i10.UserGateWay>(),
        gh<_i14.VoipTokenGateWay>(),
        gh<_i7.OneSignalVoipNotificationsGateWay>(),
        gh<_i5.IosCallKitGateWay>(),
      ),
      registerFor: {_ios},
    );
    gh.lazySingleton<_i17.CallKitService>(
      () => _i19.AndroidCallKitService(
        gh<_i10.UserGateWay>(),
        gh<_i6.OneSignalNotificationsGateWay>(),
        gh<_i3.AndroidCallKitGateWay>(),
      ),
      registerFor: {_android},
    );
    gh.factory<_i20.CalleeCallService>(() => _i20.CalleeCallService(
          gh<_i12.VideoCallGateWay>(),
          gh<_i10.UserGateWay>(),
          gh<_i15.CallGateWay>(),
        ));
    gh.factory<_i21.CallerCallService>(() => _i21.CallerCallService(
          gh<_i12.VideoCallGateWay>(),
          gh<_i10.UserGateWay>(),
          gh<_i15.CallGateWay>(),
        ));
    gh.lazySingleton<_i22.PhoneAuthService>(() => _i23.UserPhoneAuthService(
          gh<_i8.PhoneAuthGateWay>(),
          gh<_i10.UserGateWay>(),
        ));
    return this;
  }
}
