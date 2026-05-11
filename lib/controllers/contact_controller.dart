import 'package:get/get.dart';

import '../repositories/contact_repository.dart';

/// Handles contact form submission state.
class ContactController extends GetxController {
  ContactController({required this.repository});

  final ContactRepository repository;

  final RxBool isSubmitting = false.obs;

  Future<SubmitContactOutcome> submit({
    required String name,
    required String email,
    required String subject,
    required String message,
  }) async {
    if (isSubmitting.value) {
      return const SubmitContactOutcome(
        success: false,
        message: 'Submit already in progress',
      );
    }
    isSubmitting.value = true;
    try {
      return await repository.submit(
        name: name,
        email: email,
        subject: subject,
        message: message,
      );
    } finally {
      isSubmitting.value = false;
    }
  }
}
