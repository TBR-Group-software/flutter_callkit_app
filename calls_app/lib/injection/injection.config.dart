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
import '../data/gate_ways/call_kit/ios_call_kit_gate_way.dart' as _i8;
import '../data/gate_ways/calls/call_gate_way.dart' as _i22;
import '../data/gate_ways/calls/firebase_call_gate_way.dart' as _i23;
import '../data/gate_ways/firebase/firebase_initializer_gate_way.dart' as _i7;
import '../data/gate_ways/notifications/one_signal_notifications_gate_way.dart'
    as _i10;
import '../data/gate_ways/notifications/one_signal_voip_notifications_gate_way.dart'
    as _i11;
import '../data/gate_ways/phone_auth/firebase_phone_auth_gate_way.dart' as _i13;
import '../data/gate_ways/phone_auth/phone_auth_gate_way.dart' as _i12;
import '../data/gate_ways/user/firebase_user_gate_way.dart' as _i15;
import '../data/gate_ways/user/user_gate_way.dart' as _i14;
import '../data/gate_ways/video_call/agora_video_call_gate_way.dart' as _i19;
import '../data/gate_ways/video_call/video_call_gate_way.dart' as _i18;
import '../data/gate_ways/voip_token_gate_way.dart' as _i20;
import '../domain/call_kit/android_call_kit_service.dart' as _i26;
import '../domain/call_kit/call_kit_service.dart' as _i24;
import '../domain/call_kit/ios_call_kit_service.dart' as _i25;
import '../domain/calls/callee_call_service.dart' as _i27;
import '../domain/calls/caller_call_service.dart' as _i28;
import '../domain/phone_auth/phone_auth_service.dart' as _i29;
import '../domain/phone_auth/user_phone_auth_service.dart' as _i30;
import '../domain/user/user_service.dart' as _i16;
import '../domain/user/user_service_impl.dart' as _i17;
import '../ui/bloc/call/call_bloc.dart' as _i21;
import '../ui/bloc/call_kit/call_kit_cubit.dart' as _i32;
import '../ui/bloc/navigation/navigation_cubit.dart' as _i9;
import '../ui/bloc/phone_auth/phone_auth_bloc.dart' as _i33;
import '../ui/bloc/user_log_in/user_log_in_cubit.dart' as _i31;
import '../ui/controllers/call_controller.dart' as _i4;
import '../ui/controllers/call_data_error_controller.dart' as _i5;
import '../ui/controllers/call_error_controller.dart' as _i6;

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
    gh.lazySingleton<_i4.CallController>(() => _i4.CallController());
    gh.lazySingleton<_i5.CallDataErrorController>(
        () => _i5.CallDataErrorController());
    gh.lazySingleton<_i6.CallErrorController>(() => _i6.CallErrorController());
    gh.lazySingleton<_i7.FirebaseInitializerGateWay>(
        () => _i7.FirebaseInitializerGateWay());
    gh.lazySingleton<_i8.IosCallKitGateWay>(() => _i8.IosCallKitGateWay());
    gh.singleton<_i9.NavigationCubit>(_i9.NavigationCubit());
    gh.singleton<_i10.OneSignalNotificationsGateWay>(
        _i10.OneSignalNotificationsGateWay());
    gh.singleton<_i11.OneSignalVoipNotificationsGateWay>(
        _i11.OneSignalVoipNotificationsGateWay());
    gh.lazySingleton<_i12.PhoneAuthGateWay>(() =>
        _i13.FirebasePhoneAuthGateWay(gh<_i7.FirebaseInitializerGateWay>()));
    gh.lazySingleton<_i14.UserGateWay>(
        () => _i15.FirebaseUserGateWay(gh<_i7.FirebaseInitializerGateWay>()));
    gh.lazySingleton<_i16.UserService>(
        () => _i17.UserServiceImpl(gh<_i14.UserGateWay>()));
    gh.factory<_i18.VideoCallGateWay>(() => _i19.AgoraVideoCallGateWay());
    gh.singleton<_i20.VoipTokenGateWay>(_i20.VoipTokenGateWay());
    gh.lazySingleton<_i21.CallBloc>(() => _i21.CallBloc(
          gh<_i4.CallController>(),
          gh<_i6.CallErrorController>(),
        ));
    gh.lazySingleton<_i22.CallGateWay>(
        () => _i23.FirebaseCallGateWay(gh<_i7.FirebaseInitializerGateWay>()));
    gh.lazySingleton<_i24.CallKitService>(
      () => _i25.IosCallKitService(
        gh<_i14.UserGateWay>(),
        gh<_i20.VoipTokenGateWay>(),
        gh<_i11.OneSignalVoipNotificationsGateWay>(),
        gh<_i8.IosCallKitGateWay>(),
      ),
      registerFor: {_ios},
    );
    gh.lazySingleton<_i24.CallKitService>(
      () => _i26.AndroidCallKitService(
        gh<_i14.UserGateWay>(),
        gh<_i10.OneSignalNotificationsGateWay>(),
        gh<_i3.AndroidCallKitGateWay>(),
      ),
      registerFor: {_android},
    );
    gh.factory<_i27.CalleeCallService>(() => _i27.CalleeCallService(
          gh<_i18.VideoCallGateWay>(),
          gh<_i14.UserGateWay>(),
          gh<_i22.CallGateWay>(),
        ));
    gh.factory<_i28.CallerCallService>(() => _i28.CallerCallService(
          gh<_i18.VideoCallGateWay>(),
          gh<_i14.UserGateWay>(),
          gh<_i22.CallGateWay>(),
        ));
    gh.lazySingleton<_i29.PhoneAuthService>(() => _i30.UserPhoneAuthService(
          gh<_i12.PhoneAuthGateWay>(),
          gh<_i14.UserGateWay>(),
        ));
    gh.factory<_i31.UserLogInCubit>(
        () => _i31.UserLogInCubit(gh<_i16.UserService>()));
    gh.lazySingleton<_i32.CallKitCubit>(() => _i32.CallKitCubit(
          gh<_i4.CallController>(),
          gh<_i5.CallDataErrorController>(),
          gh<_i24.CallKitService>(),
        ));
    gh.factory<_i33.PhoneAuthBloc>(
        () => _i33.PhoneAuthBloc(gh<_i29.PhoneAuthService>()));
    return this;
  }
}
