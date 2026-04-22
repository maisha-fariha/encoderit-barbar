import 'package:gems_core/gems_core.dart';
import 'package:gems_data_layer/gems_data_layer.dart';
import 'package:gems_responsive/gems_responsive.dart';
import 'package:get_it/get_it.dart';

import '../di/barbar_list/barbar_list_di.dart';

/// Central bootstrap: core env, data layer (API, Hive [DatabaseService], [SyncService]), feature DI.
class AppServices {
  static final getIt = GetIt.instance;

  Future<void> initialize({
    EnvironmentMode environmentMode = EnvironmentMode.development,
    AppConfig? appConfig,
  }) async {
    await setupCoreServices(
      environmentMode: environmentMode,
      config: appConfig,
    );

    final env = Environment.instance;

    final apiConfig = ApiConfig(
      baseUrl: env.apiBaseUrl,
      enableLogging: env.enableLogging,
      timeout: env.apiTimeout,
    );

    await setupDataLayerServices(
      apiConfig: apiConfig,
      databaseBoxName: 'encoderit_barbar_db',
    );

    setupResponsiveServices();

    await setupBarbarListDomainServices();
  }

  ApiService get apiService => getIt<ApiService>();
  SyncService get syncService => getIt<SyncService>();
  AuthService get authService => getIt<AuthService>();
  DatabaseService get databaseService => getIt<DatabaseService>();

  Future<void> reset() async {
    await getIt.reset();
    await resetCoreServices();
    await resetDataLayerServices();
    await resetResponsiveServices();
  }
}
