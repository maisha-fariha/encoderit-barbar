import 'package:gems_core/gems_core.dart';
import 'package:get_it/get_it.dart';

import '../../controllers/appointment_controller.dart';
import '../../repositories/appointment_repository.dart';

/// Wires the [AppointmentController] used by the booking flow.
///
/// [AppointmentRepository] itself is registered by the reservation list
/// module (it's shared between listing existing appointments and booking new
/// ones), so we don't re-register it here.
Future<void> setupAppointmentDomainServices() async {
  final getIt = GetIt.instance;

  DIHelper.registerController<AppointmentController>(
    factory: () => AppointmentController(
      repository: getIt<AppointmentRepository>(),
    ),
  );
}
