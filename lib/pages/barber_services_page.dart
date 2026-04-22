import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../controllers/barber_services_controller.dart';
import '../models/barber_service/barber_service_model.dart';
class BarberServicesPage extends GetView<BarberServicesController> {
  const BarberServicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Barber services'),
        leading: IconButton(
          tooltip: 'Back',
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
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
          return const Center(child: Text('No services'));
        }
        return ListView.builder(
          itemCount: controller.items.length,
          itemBuilder: (context, index) {
            final BarberService item = controller.items[index];
            return ListTile(
              title: Text(item.displayTitle),
              subtitle: Text(item.displaySubtitle, maxLines: 2),
            );
          },
        );
      }),
    );
  }
}
