import 'package:gems_core/gems_core.dart';
import 'package:gems_data_layer/gems_data_layer.dart';

import '../models/barber/barber_model.dart';
import '../repositories/barber_repository.dart';

class BarberListController extends BaseListController<BarberModel>
    with BaseControllerMixin<BarberModel> {
  BarberListController({required this.repository});

  final BarberRepository repository;
  String? _shopId;
  String? _serviceId;

  @override
  Future<void> loadItems({bool forceNetwork = false}) async {
    if (_shopId == null ||
        _shopId!.isEmpty ||
        _serviceId == null ||
        _serviceId!.isEmpty) {
      items.clear();
      update(['barber-selection']);
      return;
    }
    items.clear();
    await handleListResult(
      () => repository.getByShopAndService(
        shopId: _shopId!,
        serviceId: _serviceId!,
        forceNetwork: forceNetwork,
      ),
    );
    update(['barber-selection']);
  }

  Future<void> loadByShopAndService({
    required String shopId,
    required String serviceId,
    bool forceNetwork = false,
  }) async {
    _shopId = shopId;
    _serviceId = serviceId;
    await loadItems(forceNetwork: forceNetwork);
  }
}
