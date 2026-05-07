import 'package:gems_core/gems_core.dart';
import 'package:gems_data_layer/gems_data_layer.dart';
import 'package:get_it/get_it.dart';

import '../../controllers/service_list_controller.dart';
import '../../repositories/service_repository.dart';

Future<void> setupServiceListDomainServices() async {
  final getIt = GetIt.instance;

  DIHelper.registerRepository<ServiceRepository>(
    factory: () => ServiceRepository(
      apiService: getIt<ApiService>(),
      databaseService: getIt<DatabaseService>(),
      syncService: getIt<SyncService>(),
    ),
  );

  DIHelper.registerController<ServiceListController>(
    factory: () =>
        ServiceListController(repository: getIt<ServiceRepository>()),
  );
}
