import 'package:gems_core/gems_core.dart';
import 'package:gems_data_layer/gems_data_layer.dart';

import '../models/barbar/barbar_model.dart';
import '../repositories/barbar_repository.dart';

/// GetX list controller using [BaseListController] + [BaseControllerMixin] (flutter_gems pattern).
class BarbarListController extends BaseListController<Barbar>
    with BaseControllerMixin<Barbar> {
  BarbarListController({required this.repository}) {
    loadItems();
  }

  final BarbarRepository repository;

  @override
  Future<void> loadItems() async {
    await handleListResult(() => repository.getAll());
  }
}
