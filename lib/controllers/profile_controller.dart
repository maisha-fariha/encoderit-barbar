import 'package:get/get.dart';

import '../models/profile/profile_update_request.dart';
import '../repositories/profile_repository.dart';

class ProfileController extends GetxController {
  ProfileController({required this.repository});

  final ProfileRepository repository;

  final RxBool isUpdating = false.obs;

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
}
