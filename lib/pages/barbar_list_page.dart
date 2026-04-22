import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../controllers/barbar_list_controller.dart';
import '../models/barbar/barbar_model.dart';

class BarbarListPage extends GetView<BarbarListController> {
  const BarbarListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Barbar list'),
        actions: [
          IconButton(
            tooltip: 'Sign out',
            onPressed: () => Get.find<AuthController>().logout(),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
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
            final Barbar item = controller.items[index];
            return ListTile(
              title: Text(item.displayTitle),
              subtitle: Text(item.displaySubtitle, maxLines: 1),
            );
          },
        );
      }),
    );
  }
}
