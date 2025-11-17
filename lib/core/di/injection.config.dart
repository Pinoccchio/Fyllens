// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import '../../data/services/auth_service.dart' as _i117;
import '../../data/services/database_service.dart' as _i556;
import '../../data/services/local_storage_service.dart' as _i903;
import '../../data/services/ml_service.dart' as _i830;
import '../../data/services/storage_service.dart' as _i27;
import '../../data/services/supabase_service.dart' as _i999;
import '../../features/authentication/data/repositories/auth_repository_impl.dart'
    as _i317;
import '../../features/authentication/domain/repositories/auth_repository.dart'
    as _i742;
import '../../features/authentication/domain/usecases/get_current_user_usecase.dart'
    as _i455;
import '../../features/authentication/domain/usecases/reset_password_usecase.dart'
    as _i318;
import '../../features/authentication/domain/usecases/sign_in_usecase.dart'
    as _i349;
import '../../features/authentication/domain/usecases/sign_out_usecase.dart'
    as _i749;
import '../../features/authentication/domain/usecases/sign_up_usecase.dart'
    as _i298;
import '../../features/authentication/presentation/providers/auth_provider.dart'
    as _i672;
import '../../features/profile/data/repositories/profile_repository_impl.dart'
    as _i334;
import '../../features/profile/domain/repositories/profile_repository.dart'
    as _i894;
import '../../features/profile/domain/usecases/create_profile_usecase.dart'
    as _i230;
import '../../features/profile/domain/usecases/get_user_profile_usecase.dart'
    as _i146;
import '../../features/profile/domain/usecases/update_profile_usecase.dart'
    as _i478;
import '../../features/profile/domain/usecases/upload_profile_picture_usecase.dart'
    as _i538;
import '../../features/profile/presentation/providers/profile_provider.dart'
    as _i919;
import '../../features/scan/data/repositories/scan_repository_impl.dart'
    as _i987;
import '../../features/scan/domain/repositories/scan_repository.dart' as _i664;
import '../../features/scan/domain/usecases/delete_scan_usecase.dart' as _i763;
import '../../features/scan/domain/usecases/get_user_scans_usecase.dart'
    as _i394;
import '../../features/scan/domain/usecases/perform_scan_usecase.dart' as _i229;
import '../../features/scan/presentation/providers/history_provider.dart'
    as _i728;
import '../../features/scan/presentation/providers/scan_provider.dart' as _i238;
import 'register_module.dart' as _i291;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => registerModule.prefs,
      preResolve: true,
    );
    gh.singleton<_i830.MLService>(() => _i830.MLService());
    gh.singleton<_i999.SupabaseService>(() => _i999.SupabaseService());
    gh.factory<_i117.AuthService>(
      () => _i117.AuthService(gh<_i999.SupabaseService>()),
    );
    gh.singleton<_i556.DatabaseService>(
      () => _i556.DatabaseService(gh<_i999.SupabaseService>()),
    );
    gh.singleton<_i27.StorageService>(
      () => _i27.StorageService(gh<_i999.SupabaseService>()),
    );
    gh.singleton<_i903.LocalStorageService>(
      () => _i903.LocalStorageService(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i742.AuthRepository>(
      () => _i317.AuthRepositoryImpl(gh<_i117.AuthService>()),
    );
    gh.lazySingleton<_i894.ProfileRepository>(
      () => _i334.ProfileRepositoryImpl(
        gh<_i556.DatabaseService>(),
        gh<_i27.StorageService>(),
      ),
    );
    gh.lazySingleton<_i664.ScanRepository>(
      () => _i987.ScanRepositoryImpl(
        gh<_i556.DatabaseService>(),
        gh<_i27.StorageService>(),
        gh<_i830.MLService>(),
      ),
    );
    gh.factory<_i230.CreateProfileUseCase>(
      () => _i230.CreateProfileUseCase(gh<_i894.ProfileRepository>()),
    );
    gh.factory<_i146.GetUserProfileUseCase>(
      () => _i146.GetUserProfileUseCase(gh<_i894.ProfileRepository>()),
    );
    gh.factory<_i478.UpdateProfileUseCase>(
      () => _i478.UpdateProfileUseCase(gh<_i894.ProfileRepository>()),
    );
    gh.factory<_i538.UploadProfilePictureUseCase>(
      () => _i538.UploadProfilePictureUseCase(gh<_i894.ProfileRepository>()),
    );
    gh.factory<_i455.GetCurrentUserUseCase>(
      () => _i455.GetCurrentUserUseCase(gh<_i742.AuthRepository>()),
    );
    gh.factory<_i318.ResetPasswordUseCase>(
      () => _i318.ResetPasswordUseCase(gh<_i742.AuthRepository>()),
    );
    gh.factory<_i349.SignInUseCase>(
      () => _i349.SignInUseCase(gh<_i742.AuthRepository>()),
    );
    gh.factory<_i749.SignOutUseCase>(
      () => _i749.SignOutUseCase(gh<_i742.AuthRepository>()),
    );
    gh.factory<_i298.SignUpUseCase>(
      () => _i298.SignUpUseCase(gh<_i742.AuthRepository>()),
    );
    gh.factory<_i672.AuthProvider>(
      () => _i672.AuthProvider(
        gh<_i349.SignInUseCase>(),
        gh<_i298.SignUpUseCase>(),
        gh<_i749.SignOutUseCase>(),
        gh<_i318.ResetPasswordUseCase>(),
        gh<_i455.GetCurrentUserUseCase>(),
        gh<_i742.AuthRepository>(),
      ),
    );
    gh.factory<_i763.DeleteScanUseCase>(
      () => _i763.DeleteScanUseCase(gh<_i664.ScanRepository>()),
    );
    gh.factory<_i394.GetUserScansUseCase>(
      () => _i394.GetUserScansUseCase(gh<_i664.ScanRepository>()),
    );
    gh.factory<_i229.PerformScanUseCase>(
      () => _i229.PerformScanUseCase(gh<_i664.ScanRepository>()),
    );
    gh.factory<_i728.HistoryProvider>(
      () => _i728.HistoryProvider(
        gh<_i394.GetUserScansUseCase>(),
        gh<_i763.DeleteScanUseCase>(),
      ),
    );
    gh.factory<_i919.ProfileProvider>(
      () => _i919.ProfileProvider(
        gh<_i146.GetUserProfileUseCase>(),
        gh<_i230.CreateProfileUseCase>(),
        gh<_i478.UpdateProfileUseCase>(),
        gh<_i538.UploadProfilePictureUseCase>(),
      ),
    );
    gh.factory<_i238.ScanProvider>(
      () => _i238.ScanProvider(gh<_i229.PerformScanUseCase>()),
    );
    return this;
  }
}

class _$RegisterModule extends _i291.RegisterModule {}
