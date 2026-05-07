import 'package:gems_core/gems_core.dart';
import 'package:gems_data_layer/gems_data_layer.dart';

import '../models/shop/shop_model.dart';
import '../repositories/shop_repository.dart';

class ShopListController extends BaseListController<Shop>
    with BaseControllerMixin<Shop> {
  ShopListController({required this.repository});

  final ShopRepository repository;

  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  Shop? get selectedShop {
    if (items.isEmpty) return null;
    if (_selectedIndex < 0 || _selectedIndex >= items.length) {
      return items.first;
    }
    return items[_selectedIndex];
  }

  List<ShopService> get selectedShopServices =>
      selectedShop?.services ?? const <ShopService>[];

  void selectShop(int index) {
    if (index < 0 || index >= items.length) return;
    _selectedIndex = index;
    update(['shop-selection']);
  }

  @override
  Future<void> loadItems() async {
    items.clear();
    await handleListResult(() => repository.getAll());
    if (items.isEmpty) {
      _selectedIndex = 0;
      return;
    }
    if (_selectedIndex >= items.length) {
      _selectedIndex = 0;
    }
    update(['shop-selection']);
  }
}
