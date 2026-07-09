import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:kamkor/core/app_icon/app_icon_cubit.dart';
import 'package:kamkor/core/localization/locale_cubit.dart';
import 'package:kamkor/core/network/dio_client.dart';
import 'package:kamkor/core/router/app_router.dart';
import 'package:kamkor/core/router/guards/auth_guard.dart';
import 'package:kamkor/core/storage/secure_storage.dart';
import 'package:kamkor/core/theme/theme_cubit.dart';
import 'package:kamkor/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:kamkor/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:kamkor/features/auth/domain/repositories/auth_repository.dart';
import 'package:kamkor/features/auth/domain/usecases/get_current_session.dart';
import 'package:kamkor/features/auth/domain/usecases/login_user.dart';
import 'package:kamkor/features/auth/domain/usecases/logout.dart';
import 'package:kamkor/features/auth/domain/usecases/validate_access_link.dart';
import 'package:kamkor/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:kamkor/features/auth/presentation/login/bloc/login_bloc.dart';
import 'package:kamkor/features/contacts/data/datasources/contacts_remote_data_source.dart';
import 'package:kamkor/features/contacts/data/repositories/contacts_repository_impl.dart';
import 'package:kamkor/features/contacts/domain/repositories/contacts_repository.dart';
import 'package:kamkor/features/contacts/domain/usecases/add_contact.dart';
import 'package:kamkor/features/contacts/domain/usecases/delete_contact.dart';
import 'package:kamkor/features/contacts/domain/usecases/get_contacts.dart';
import 'package:kamkor/features/contacts/domain/usecases/update_contact.dart';
import 'package:kamkor/features/contacts/presentation/bloc/contacts_bloc.dart';
import 'package:kamkor/features/info/data/datasources/info_remote_data_source.dart';
import 'package:kamkor/features/info/data/repositories/info_repository_impl.dart';
import 'package:kamkor/features/info/domain/repositories/info_repository.dart';
import 'package:kamkor/features/info/domain/usecases/get_crisis_centers.dart';
import 'package:kamkor/features/info/domain/usecases/get_emergency_instructions.dart';
import 'package:kamkor/features/info/domain/usecases/get_privacy_policy.dart';
import 'package:kamkor/features/info/domain/usecases/get_psychological_help.dart';
import 'package:kamkor/features/info/presentation/bloc/info_bloc.dart';
import 'package:kamkor/features/message_template/data/datasources/message_template_remote_data_source.dart';
import 'package:kamkor/features/message_template/data/repositories/message_template_repository_impl.dart';
import 'package:kamkor/features/message_template/domain/repositories/message_template_repository.dart';
import 'package:kamkor/features/message_template/domain/usecases/get_message_template.dart';
import 'package:kamkor/features/message_template/domain/usecases/update_message_template.dart';
import 'package:kamkor/features/message_template/presentation/bloc/message_template_bloc.dart';
import 'package:kamkor/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:kamkor/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:kamkor/features/profile/domain/repositories/profile_repository.dart';
import 'package:kamkor/features/profile/domain/usecases/update_profile.dart';
import 'package:kamkor/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:kamkor/features/sos/data/datasources/sos_remote_data_source.dart';
import 'package:kamkor/features/sos/data/repositories/sos_repository_impl.dart';
import 'package:kamkor/features/sos/domain/repositories/sos_repository.dart';
import 'package:kamkor/features/sos/domain/usecases/create_sos.dart';
import 'package:kamkor/features/sos/domain/usecases/get_sos.dart';
import 'package:kamkor/features/sos/domain/usecases/preflight_sos.dart';
import 'package:kamkor/features/sos/domain/usecases/update_location.dart';
import 'package:kamkor/features/sos/domain/usecases/watch_sos_status.dart';
import 'package:kamkor/features/sos/presentation/bloc/sos_bloc.dart';
import 'package:kamkor/features/sos/service/location_tracker.dart';
import 'package:kamkor/features/sos_history/data/datasources/sos_history_remote_data_source.dart';
import 'package:kamkor/features/sos_history/data/repositories/sos_history_repository_impl.dart';
import 'package:kamkor/features/sos_history/domain/repositories/sos_history_repository.dart';
import 'package:kamkor/features/sos_history/domain/usecases/get_sos_history.dart';
import 'package:kamkor/features/sos_history/domain/usecases/get_sos_history_item.dart';
import 'package:kamkor/features/sos_history/presentation/bloc/sos_history_bloc.dart';
import 'package:kamkor/features/sos_history/presentation/bloc/sos_history_detail_bloc.dart';

final GetIt sl = GetIt.instance;

/// Registers app-wide dependencies.
Future<void> configureDependencies() async {
  // Core
  sl
    ..registerLazySingleton(SecureStorage.new)
    ..registerLazySingleton<Dio>(() => DioClient.create(sl()))
    ..registerLazySingleton(() => AppRouter(AuthGuard(sl())))
    ..registerLazySingleton(LocaleCubit.new)
    ..registerLazySingleton(ThemeCubit.new)
    ..registerLazySingleton(AppIconCubit.new);

  // feature registrations
  _registerAuth();
  _registerSos();
  _registerContacts();
  _registerMessageTemplate();
  _registerSosHistory();
  _registerInfo();
  _registerProfile();
}

/// Clears session-scoped singleton state on logout so nothing leaks into the
/// next session. The auth token itself is revoked by the Logout use case.
Future<void> resetSessionState() async {
  if (sl.isRegistered<SosBloc>()) {
    final sos = sl<SosBloc>();
    await sos.clear(); // wipe the persisted alarm (HydratedBloc storage)
    await sos.close(); // cancel tracking and release GPS
    await sl.resetLazySingleton<SosBloc>(); // rebuild fresh on next login
  }
}

void _registerAuth() {
  sl
    ..registerLazySingleton(
      () => AuthRemoteDataSource(AuthApiClient(sl<Dio>())),
    )
    ..registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(sl(), sl()),
    )
    ..registerLazySingleton(() => ValidateAccessLink(sl()))
    ..registerLazySingleton(() => LoginUser(sl()))
    ..registerLazySingleton(() => Logout(sl()))
    ..registerLazySingleton(() => GetCurrentSession(sl()))
    ..registerLazySingleton(
      () => AuthBloc(getCurrentSession: sl(), logout: sl()),
    )
    ..registerFactory(
      () => LoginBloc(validateAccessLink: sl(), loginUser: sl()),
    );
}

void _registerSos() {
  sl
    // Device services + data.
    ..registerLazySingleton(LocationTracker.new)
    ..registerLazySingleton(
      () => SosRemoteDataSource(SosApiClient(sl<Dio>())),
    )
    ..registerLazySingleton<SosRepository>(
      () => SosRepositoryImpl(sl(), sl()),
    )
    // Use cases.
    ..registerLazySingleton(() => PreflightSos(sl()))
    ..registerLazySingleton(() => CreateSos(sl()))
    ..registerLazySingleton(() => UpdateLocation(sl()))
    ..registerLazySingleton(() => WatchSosStatus(sl()))
    ..registerLazySingleton(() => GetSos(sl()))
    // Singleton: one app-wide alarm that survives navigation and is restored
    // on relaunch (HydratedBloc). Provided to the page via BlocProvider.value.
    ..registerLazySingleton(
      () => SosBloc(
        preflight: sl(),
        createSos: sl(),
        updateLocation: sl(),
        watchSosStatus: sl(),
        getSos: sl(),
      ),
    );
}

void _registerContacts() {
  sl
    ..registerLazySingleton(
      () => ContactsRemoteDataSource(ContactsApiClient(sl<Dio>())),
    )
    ..registerLazySingleton<ContactsRepository>(
      () => ContactsRepositoryImpl(sl()),
    )
    ..registerLazySingleton(() => GetContacts(sl()))
    ..registerLazySingleton(() => AddContact(sl()))
    ..registerLazySingleton(() => UpdateContact(sl()))
    ..registerLazySingleton(() => DeleteContact(sl()))
    ..registerFactory(
      () => ContactsBloc(
        getContacts: sl(),
        addContact: sl(),
        updateContact: sl(),
        deleteContact: sl(),
      ),
    );
}

void _registerMessageTemplate() {
  sl
    ..registerLazySingleton(
      () => MessageTemplateRemoteDataSource(
        MessageTemplateApiClient(sl<Dio>()),
      ),
    )
    ..registerLazySingleton<MessageTemplateRepository>(
      () => MessageTemplateRepositoryImpl(sl()),
    )
    ..registerLazySingleton(() => GetMessageTemplate(sl()))
    ..registerLazySingleton(() => UpdateMessageTemplate(sl()))
    ..registerFactory(
      () => MessageTemplateBloc(getTemplate: sl(), updateTemplate: sl()),
    );
}

void _registerSosHistory() {
  sl
    ..registerLazySingleton(
      () => SosHistoryRemoteDataSource(SosHistoryApiClient(sl<Dio>())),
    )
    ..registerLazySingleton<SosHistoryRepository>(
      () => SosHistoryRepositoryImpl(sl()),
    )
    ..registerLazySingleton(() => GetSosHistory(sl()))
    ..registerLazySingleton(() => GetSosHistoryItem(sl()))
    ..registerFactory(() => SosHistoryBloc(getHistory: sl()))
    ..registerFactory(() => SosHistoryDetailBloc(getItem: sl()));
}

void _registerInfo() {
  sl
    ..registerLazySingleton(
      () => InfoRemoteDataSource(InfoApiClient(sl<Dio>())),
    )
    ..registerLazySingleton<InfoRepository>(() => InfoRepositoryImpl(sl()))
    ..registerLazySingleton(() => GetCrisisCenters(sl()))
    ..registerLazySingleton(() => GetPsychologicalHelp(sl()))
    ..registerLazySingleton(() => GetEmergencyInstructions(sl()))
    ..registerLazySingleton(() => GetPrivacyPolicy(sl()))
    ..registerFactory(
      () => InfoBloc(
        getCrisisCenters: sl(),
        getPsychologicalHelp: sl(),
        getEmergencyInstructions: sl(),
        getPrivacyPolicy: sl(),
      ),
    );
}

void _registerProfile() {
  sl
    ..registerLazySingleton(
      () => ProfileRemoteDataSource(ProfileApiClient(sl<Dio>())),
    )
    ..registerLazySingleton<ProfileRepository>(
      () => ProfileRepositoryImpl(sl()),
    )
    ..registerLazySingleton(() => UpdateProfile(sl()))
    ..registerFactory(
      () => ProfileBloc(updateProfile: sl(), getCurrentSession: sl()),
    );
}
