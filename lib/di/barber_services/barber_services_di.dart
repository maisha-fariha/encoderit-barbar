import 'package:gems_core/gems_core.dart';
import 'package:gems_data_layer/gems_data_layer.dart';
import 'package:get_it/get_it.dart';

import '../../controllers/barber_services_controller.dart';
import '../../repositories/barber_service_repository.dart';

Future<void> setupBarberServicesDomainServices() async {
  final getIt = GetIt.instance;

  DIHelper.registerRepository<BarberServiceRepository>(
    factory: () => BarberServiceRepository(
      apiService: getIt<ApiService>(),
      databaseService: getIt<DatabaseService>(),
      syncService: getIt<SyncService>(),
    ),
  );

  DIHelper.registerController<BarberServicesController>(
    factory: () => BarberServicesController(
      repository: getIt<BarberServiceRepository>(),
    ),
  );
}
