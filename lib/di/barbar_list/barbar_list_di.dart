import 'package:gems_core/gems_core.dart';
import 'package:gems_data_layer/gems_data_layer.dart';
import 'package:get_it/get_it.dart';

import '../../controllers/barbar_list_controller.dart';
import '../../repositories/barbar_repository.dart';

/// Feature-scoped GetIt registration (mirrors `flutter_gems/lib/di/todo/todo_di.dart`).
Future<void> setupBarbarListDomainServices() async {
  final getIt = GetIt.instance;

  DIHelper.registerRepository<BarbarRepository>(
    factory: () => BarbarRepository(
      apiService: getIt<ApiService>(),
      databaseService: getIt<DatabaseService>(),
      syncService: getIt<SyncService>(),
    ),
  );

  DIHelper.registerController<BarbarListController>(
    factory: () => BarbarListController(
      repository: getIt<BarbarRepository>(),
    ),
  );
}
