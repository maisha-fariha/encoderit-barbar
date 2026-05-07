import 'package:gems_core/gems_core.dart';
import 'package:gems_data_layer/gems_data_layer.dart';

import '../models/service/service_model.dart';
import '../repositories/service_repository.dart';

class ServiceListController extends BaseListController<ServiceModel>
    with BaseControllerMixin<ServiceModel> {
  ServiceListController({required this.repository});

  final ServiceRepository repository;
  String? _shopId;

  String? get shopId => _shopId;

  @override
  Future<void> loadItems() async {
    if (_shopId == null || _shopId!.isEmpty) {
      items.clear();
      update(['service-selection']);
      return;
    }
    items.clear();
    await handleListResult(() => repository.getByShopId(_shopId!));
    update(['service-selection']);
  }

  Future<void> loadByShop(String shopId) async {
    _shopId = shopId;
    await loadItems();
  }
}
