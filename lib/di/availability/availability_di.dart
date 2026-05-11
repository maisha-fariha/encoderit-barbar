import 'package:gems_core/gems_core.dart';
import 'package:gems_data_layer/gems_data_layer.dart';
import 'package:get_it/get_it.dart';

import '../../repositories/availability_repository.dart';

Future<void> setupAvailabilityDomainServices() async {
  final getIt = GetIt.instance;

  DIHelper.registerRepository<AvailabilityRepository>(
    factory: () => AvailabilityRepository(
      apiService: getIt<ApiService>(),
      databaseService: getIt<DatabaseService>(),
    ),
  );
}
