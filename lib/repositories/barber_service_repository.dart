import 'package:gems_data_layer/gems_data_layer.dart';

import '../models/barber_service/barber_service_model.dart';
import '../utils/api_endpoints.dart';

class BarberServiceRepository extends BaseRepository<BarberService> {
  BarberServiceRepository({
    required super.apiService,
    required super.databaseService,
    required super.syncService,
  }) : super(
          baseEndpoint: ApiEndpoints.barberServices,
        );

  @override
  BarberService fromJson(Map<String, dynamic> json) => BarberService.fromJson(json);
}
