import 'package:gems_core/gems_core.dart';
import 'package:gems_data_layer/gems_data_layer.dart';

import '../models/barber_service/barber_service_model.dart';
import '../repositories/barber_service_repository.dart';

class BarberServicesController extends BaseListController<BarberService>
    with BaseControllerMixin<BarberService> {
  BarberServicesController({required this.repository}) {
    loadItems();
  }

  final BarberServiceRepository repository;

  @override
  Future<void> loadItems() async {
    await handleListResult(() => repository.getAll());
  }
}
