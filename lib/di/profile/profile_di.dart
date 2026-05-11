import 'package:gems_core/gems_core.dart';
import 'package:gems_data_layer/gems_data_layer.dart';
import 'package:get_it/get_it.dart';

import '../../controllers/profile_controller.dart';
import '../../repositories/profile_repository.dart';

Future<void> setupProfileDomainServices() async {
  final getIt = GetIt.instance;

  DIHelper.registerRepository<ProfileRepository>(
    factory: () => ProfileRepository(
      apiService: getIt<ApiService>(),
      authService: getIt<AuthService>(),
    ),
  );

  DIHelper.registerController<ProfileController>(
    factory: () => ProfileController(repository: getIt<ProfileRepository>()),
  );
}
