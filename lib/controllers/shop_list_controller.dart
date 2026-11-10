import 'package:gems_core/gems_core.dart';
import 'package:gems_data_layer/gems_data_layer.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/shop/shop_model.dart';
import '../repositories/appointment_repository.dart';
import '../repositories/shop_repository.dart';
import '../utils/appointment_shop_context.dart';

class ShopListController extends BaseListController<Shop>
    with BaseControllerMixin<Shop> {
  ShopListController({
    required this.repository,
    required this.prefs,
  });

  static const preferredShopIdKey = 'preferred_shop_id';

  final ShopRepository repository;
  final SharedPreferences prefs;

  int _selectedIndex = 0;
  int _loadGeneration = 0;

  /// User-chosen shop id (persisted). Null means "no shop selected".
  String? _preferredShopId;

  /// Last-appointment shop id used only when [_preferredShopId] is unset.
  String? _fallbackShopId;

  int get selectedIndex => _selectedIndex;

  String? get preferredShopId => _preferredShopId;

  bool get hasUserSelectedShop {
    final id = _preferredShopId?.trim() ?? '';
    return id.isNotEmpty && shopById(id) != null;
  }

  Shop? get selectedShop {
    if (items.isEmpty) return null;
    if (_selectedIndex < 0 || _selectedIndex >= items.length) {
      return items.first;
    }
    return items[_selectedIndex];
  }

  /// Shop for contact / appointment lists:
  /// 1) user-selected preferred shop, else
  /// 2) last appointment shop, else
  /// 3) first shop in the list.
  Shop? get contextShop {
    final preferred = shopById(_preferredShopId);
    if (preferred != null) return preferred;
    final fallback = shopById(_fallbackShopId);
    if (fallback != null) return fallback;
    return items.isEmpty ? null : items.first;
  }

  List<ShopService> get selectedShopServices =>
      selectedShop?.services ?? const <ShopService>[];

  Shop? shopById(String? id) {
    final needle = id?.trim() ?? '';
    if (needle.isEmpty || items.isEmpty) return null;
    for (final shop in items) {
      if (shop.id == needle) return shop;
    }
    return null;
  }

  void selectShop(int index) {
    if (index < 0 || index >= items.length) return;
    _selectedIndex = index;
    _setPreferredShopId(items[index].id);
    update(['shop-selection']);
  }

  void selectShopById(String shopId) {
    final index = items.indexWhere((shop) => shop.id == shopId);
    if (index < 0) return;
    selectShop(index);
  }

  void _setPreferredShopId(String shopId) {
    final trimmed = shopId.trim();
    if (trimmed.isEmpty) return;
    _preferredShopId = trimmed;
    prefs.setString(preferredShopIdKey, trimmed);
  }

  void _restorePreferredShopId() {
    final stored = prefs.getString(preferredShopIdKey)?.trim();
    _preferredShopId = (stored == null || stored.isEmpty) ? null : stored;
  }

  void _syncSelectedIndexToContextShop() {
    final shop = contextShop;
    if (shop == null) return;
    final index = items.indexWhere((item) => item.id == shop.id);
    if (index >= 0) _selectedIndex = index;
  }

  /// Loads shops, restores the preferred selection, then fills the
  /// last-appointment fallback when the user has not chosen a shop.
  ///
  /// Pass [forceRefresh] to always hit the network (e.g. Contact page) so
  /// address/phone are not served from a stale in-memory or Hive snapshot.
  Future<void> ensureContextShop({bool forceRefresh = false}) async {
    if (forceRefresh || items.isEmpty) {
      await loadItems(forceRefresh: forceRefresh);
    } else {
      _restorePreferredShopId();
      _normalizeSelectedIndex();
      _syncSelectedIndexToContextShop();
      update(['shop-selection']);
    }
    if (!hasUserSelectedShop) {
      await refreshFallbackFromAppointments();
    }
  }

  AppointmentRepository? get _appointmentRepository {
    final getIt = GetIt.instance;
    if (!getIt.isRegistered<AppointmentRepository>()) return null;
    return getIt<AppointmentRepository>();
  }

  /// Fetches recent appointments and sets [_fallbackShopId] from the latest one.
  Future<void> refreshFallbackFromAppointments() async {
    final repo = _appointmentRepository;
    if (repo == null) return;
    try {
      final result = await repo.getPage(1, forceNetwork: true);
      String? shopId;
      result.when(
        success: (page) {
          shopId = shopIdFromLatestAppointment(page.items);
        },
        failure: (_) {},
      );
      if (shopId == null || shopId!.isEmpty) {
        // Also try upcoming in case page 1 without status differs.
        final upcoming = await repo.getPage(
          1,
          forceNetwork: true,
          status: 'upcoming',
        );
        upcoming.when(
          success: (page) {
            shopId ??= shopIdFromLatestAppointment(page.items);
          },
          failure: (_) {},
        );
      }
      _fallbackShopId = shopId;
      _syncSelectedIndexToContextShop();
      update(['shop-selection']);
    } catch (_) {
      // Keep current selection if appointments cannot be loaded.
    }
  }

  @override
  Future<void> loadItems({bool forceRefresh = false}) async {
    final generation = ++_loadGeneration;
    setLoading(true);
    errorMessage.value = '';
    _restorePreferredShopId();

    try {
      // Always try the network first (repository already does). forceRefresh
      // only matters for ensureContextShop deciding to call loadItems again
      // even when [items] is already populated in memory.
      final result = await repository.getAll(useCache: true);
      if (generation != _loadGeneration) return;

      result.when(
        success: (shops) {
          items
            ..clear()
            ..addAll(ShopRepository.dedupeShops(shops));
          _normalizeSelectedIndex();
          _syncSelectedIndexToContextShop();
        },
        failure: (error) => setError(error.message),
      );
    } finally {
      if (generation == _loadGeneration) {
        setLoading(false);
        update(['shop-selection']);
      }
    }
  }

  void _normalizeSelectedIndex() {
    if (items.isEmpty) {
      _selectedIndex = 0;
      return;
    }
    if (_selectedIndex >= items.length) {
      _selectedIndex = 0;
    }
  }
}
