import 'package:gems_core/gems_core.dart';
import 'package:gems_data_layer/gems_data_layer.dart';
import 'package:get_it/get_it.dart';

import '../../controllers/reservation_list_controller.dart';
import '../../repositories/appointment_repository.dart';

Future<void> setupReservationListDomainServices() async {
  final getIt = GetIt.instance;

  DIHelper.registerRepository<AppointmentRepository>(
    factory: () => AppointmentRepository(
      apiService: getIt<ApiService>(),
      databaseService: getIt<DatabaseService>(),
      syncService: getIt<SyncService>(),
    ),
  );

  DIHelper.registerController<ReservationListController>(
    factory: () =>
        ReservationListController(repository: getIt<AppointmentRepository>()),
  );
}
