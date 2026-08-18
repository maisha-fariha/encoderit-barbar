import 'package:gems_core/gems_core.dart';
import 'package:gems_data_layer/gems_data_layer.dart';

import '../models/service/service_model.dart';
import '../repositories/service_repository.dart';

class ServiceListController extends BaseListController<ServiceModel>
    with BaseControllerMixin<ServiceModel> {
  ServiceListController({required this.repository});

  final ServiceRepository repository;
  String? _shopId;
  int _loadGeneration = 0;

  String? get shopId => _shopId;

  @override
  Future<void> loadItems() async {
    if (_shopId == null || _shopId!.isEmpty) {
      items.clear();
      update(['service-selection']);
      return;
    }

    final generation = ++_loadGeneration;
    setLoading(true);
    errorMessage.value = '';

    try {
      final result = await repository.getByShopId(_shopId!);
      if (generation != _loadGeneration) return;

      result.when(
        success: (services) {
          items
            ..clear()
            ..addAll(services);
        },
        failure: (error) => setError(error.message),
      );
    } finally {
      if (generation == _loadGeneration) {
        setLoading(false);
        update(['service-selection']);
      }
    }
  }

  Future<void> loadByShop(String shopId) async {
    _shopId = shopId;
    await loadItems();
  }
}
