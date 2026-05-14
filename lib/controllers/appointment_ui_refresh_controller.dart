import 'package:get/get.dart';

/// Bumps when appointments change on the server (book/delete) so UI can reload.
class AppointmentUiRefreshController extends GetxController {
  final revision = 0.obs;

  void notifyAppointmentsChanged() {
    revision.value++;
  }
}
