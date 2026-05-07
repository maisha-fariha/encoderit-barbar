import 'package:gems_core/gems_core.dart';
import 'package:gems_data_layer/gems_data_layer.dart';
import 'package:get_it/get_it.dart';

import '../../controllers/shop_list_controller.dart';
import '../../repositories/shop_repository.dart';

Future<void> setupShopListDomainServices() async {
  final getIt = GetIt.instance;

  DIHelper.registerRepository<ShopRepository>(
    factory: () => ShopRepository(
      apiService: getIt<ApiService>(),
      databaseService: getIt<DatabaseService>(),
      syncService: getIt<SyncService>(),
    ),
  );

  DIHelper.registerController<ShopListController>(
    factory: () => ShopListController(repository: getIt<ShopRepository>()),
  );
}
