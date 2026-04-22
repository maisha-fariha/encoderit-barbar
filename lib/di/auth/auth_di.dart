import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:gems_data_layer/gems_data_layer.dart';
import 'package:gems_core/gems_core.dart';
import 'package:get_it/get_it.dart';

import '../../controllers/auth_controller.dart';

Future<void> setupAuthDomainServices() async {
  final getIt = GetIt.instance;

  DIHelper.registerController<AuthController>(
    factory: () => AuthController(
      authService: getIt<AuthService>(),
      connectivity: getIt<Connectivity>(),
    ),
  );
}
