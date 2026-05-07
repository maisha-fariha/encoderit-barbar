import 'package:gems_core/gems_core.dart';
import 'package:gems_data_layer/gems_data_layer.dart';
import 'package:get_it/get_it.dart';

import '../../controllers/barber_list_controller.dart';
import '../../repositories/barber_repository.dart';

Future<void> setupBarberListDomainServices() async {
  final getIt = GetIt.instance;

  DIHelper.registerRepository<BarberRepository>(
    factory: () => BarberRepository(
      apiService: getIt<ApiService>(),
      databaseService: getIt<DatabaseService>(),
      syncService: getIt<SyncService>(),
    ),
  );

  DIHelper.registerController<BarberListController>(
    factory: () => BarberListController(repository: getIt<BarberRepository>()),
  );
}
