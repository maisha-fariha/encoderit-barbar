import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:gems_core/gems_core.dart';
import 'package:gems_data_layer/gems_data_layer.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../auth/app_auth_gateway.dart';
import '../../config/auth_backend_config.dart';
import '../../controllers/auth_controller.dart';

Future<void> setupAuthDomainServices() async {
  final getIt = GetIt.instance;

  final AppAuthGateway gateway = kUseLocalAuthBackend
      ? LocalAppAuthGateway(getIt<AuthService>(), getIt<SharedPreferences>())
      : RemoteAppAuthGateway(getIt<AuthService>());

  if (!getIt.isRegistered<AppAuthGateway>()) {
    getIt.registerSingleton<AppAuthGateway>(gateway);
  }

  DIHelper.registerController<AuthController>(
    factory: () => AuthController(
      authGateway: getIt<AppAuthGateway>(),
      connectivity: getIt<Connectivity>(),
    ),
  );
}
