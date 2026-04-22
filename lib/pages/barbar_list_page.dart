import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/barbar_list_controller.dart';

/// Placeholder screen — wire-up only; replace with your design later.
class BarbarListPage extends GetView<BarbarListController> {
  const BarbarListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Barbar list')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.errorMessage.value.isNotEmpty) {
          return Center(child: Text(controller.errorMessage.value));
        }
        if (controller.items.isEmpty) {
          return const Center(child: Text('No items'));
        }
        return ListView.builder(
          itemCount: controller.items.length,
          itemBuilder: (context, index) {
            final item = controller.items[index];
            return ListTile(
              title: Text(item.name),
              subtitle: Text(item.username, maxLines: 1),
            );
          },
        );
      }),
    );
  }
}
