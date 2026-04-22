import 'package:gems_data_layer/gems_data_layer.dart';

import '../models/barbar/barbar_model.dart';
import '../utils/api_endpoints.dart';

/// Extends [BaseRepository] for API + Hive cache + offline sync queue (from gems_data_layer).
class BarbarRepository extends BaseRepository<Barbar> {
  BarbarRepository({
    required super.apiService,
    required super.databaseService,
    required super.syncService,
  }) : super(
          baseEndpoint: ApiEndpoints.barbarList,
          responseListKey: 'data',
        );

  @override
  Barbar fromJson(Map<String, dynamic> json) => Barbar.fromJson(json);
}
