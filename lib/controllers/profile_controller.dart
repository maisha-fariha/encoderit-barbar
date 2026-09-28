import 'package:get/get.dart';

import '../models/profile/profile_update_request.dart';
import '../repositories/profile_repository.dart';

class ProfileController extends GetxController {
  ProfileController({required this.repository});

  final ProfileRepository repository;

  final RxBool isUpdating = false.obs;
  final RxBool isDeletingAccount = false.obs;

  Future<UpdateProfileOutcome> updateProfile(ProfileUpdateRequest request) async {
    if (isUpdating.value) {
      return const UpdateProfileOutcome(
        success: false,
        message: 'Update already in progress',
      );
    }
    isUpdating.value = true;
    try {
      return await repository.updateProfile(request);
    } finally {
      isUpdating.value = false;
    }
  }

  Future<DeleteAccountOutcome> deleteAccount({required String password}) async {
    if (isDeletingAccount.value) {
      return const DeleteAccountOutcome(
        success: false,
        message: 'Delete already in progress',
      );
    }
    isDeletingAccount.value = true;
    try {
      return await repository.deleteAccount(password: password);
    } finally {
      isDeletingAccount.value = false;
    }
  }
}
