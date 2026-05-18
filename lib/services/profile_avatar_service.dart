import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../auth/app_auth_gateway.dart';

/// Outcome of an avatar pick attempt.
enum AvatarPickError {
  cameraPermissionDenied,
  galleryPermissionDenied,
  cameraUnavailable,
  missingPlugin,
  noUser,
  saveFailed,
  unknown,
}

class AvatarPickResult {
  const AvatarPickResult._({this.file, this.error, required this.isCancelled});

  const AvatarPickResult.saved(File file)
      : this._(file: file, error: null, isCancelled: false);
  const AvatarPickResult.cancelled()
      : this._(file: null, error: null, isCancelled: true);
  const AvatarPickResult.failure(AvatarPickError err)
      : this._(file: null, error: err, isCancelled: false);

  final File? file;
  final AvatarPickError? error;
  final bool isCancelled;

  bool get isSuccess => file != null;
  bool get isFailure => error != null;
}

/// Picks a profile photo and stores it per user under app documents for preview.
///
/// Upload uses `PUT /profile` with multipart field `avatar` (file) — see
/// [ProfileRepository.updateProfile].
class ProfileAvatarService {
  ProfileAvatarService({
    required this.gateway,
    required this.prefs,
    ImagePicker? picker,
  }) : _picker = picker ?? ImagePicker();

  final AppAuthGateway gateway;
  final SharedPreferences prefs;
  final ImagePicker _picker;

  /// Bumped on any local change so listening widgets rebuild.
  final ValueNotifier<int> revision = ValueNotifier<int>(0);

  String? _currentUserKey;

  Future<void> initialize() async {
    _currentUserKey = await _readUserKey();
  }

  Future<void> dispose() async {}

  /// Call after login/logout so the per-user binding refreshes.
  Future<void> onAuthChanged() async {
    _currentUserKey = await _readUserKey();
    revision.value++;
  }

  Future<String?> _readUserKey() async {
    final auth = await gateway.getStoredAuth();
    final raw = auth?.userData?['email'];
    if (raw is! String) return null;
    final t = raw.trim().toLowerCase();
    return t.isEmpty ? null : t;
  }

  String _safeFileName(String key) =>
      key.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_');

  Future<Directory> _avatarsDir() async {
    final docs = await getApplicationDocumentsDirectory();
    final dir = Directory(p.join(docs.path, 'profile_avatars'));
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  Future<File> _userAvatarFile(String userKey) async {
    final dir = await _avatarsDir();
    return File(p.join(dir.path, '${_safeFileName(userKey)}.jpg'));
  }

  /// Local cached avatar for the signed-in user, if any.
  Future<File?> currentAvatarFile() async {
    final key = _currentUserKey ??= await _readUserKey();
    if (key == null) return null;
    final f = await _userAvatarFile(key);
    if (await f.exists()) return f;
    return null;
  }

  Future<AvatarPickResult> pickFromGallery() =>
      _pickAndStore(ImageSource.gallery);
  Future<AvatarPickResult> pickFromCamera() =>
      _pickAndStore(ImageSource.camera);

  Future<AvatarPickResult> _pickAndStore(ImageSource source) async {
    final XFile? picked;
    try {
      picked = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
    } on PlatformException catch (e) {
      if (kDebugMode) {
        debugPrint('[ProfileAvatarService] PlatformException: '
            'code=${e.code} msg=${e.message}');
      }
      return AvatarPickResult.failure(
        _mapPlatformException(e, source),
      );
    } on MissingPluginException catch (e) {
      if (kDebugMode) {
        debugPrint('[ProfileAvatarService] MissingPluginException: ${e.message}');
      }
      return const AvatarPickResult.failure(
        AvatarPickError.missingPlugin,
      );
    } catch (e, st) {
      if (kDebugMode) {
        debugPrint('[ProfileAvatarService] picker error: $e\n$st');
      }
      return const AvatarPickResult.failure(AvatarPickError.unknown);
    }

    if (picked == null) {
      return const AvatarPickResult.cancelled();
    }

    final key = _currentUserKey ??= await _readUserKey();
    if (key == null) {
      return const AvatarPickResult.failure(AvatarPickError.noUser);
    }

    try {
      final dest = await _userAvatarFile(key);
      final bytes = await File(picked.path).readAsBytes();
      await dest.writeAsBytes(bytes, flush: true);
      revision.value++;
      return AvatarPickResult.saved(dest);
    } catch (e, st) {
      if (kDebugMode) {
        debugPrint('[ProfileAvatarService] save error: $e\n$st');
      }
      return const AvatarPickResult.failure(AvatarPickError.saveFailed);
    }
  }

  AvatarPickError _mapPlatformException(
    PlatformException e,
    ImageSource source,
  ) {
    final code = (e.code).toLowerCase();
    if (code.contains('photo_access_denied') ||
        code.contains('camera_access_denied') ||
        code.contains('permission')) {
      return source == ImageSource.camera
          ? AvatarPickError.cameraPermissionDenied
          : AvatarPickError.galleryPermissionDenied;
    }
    if (code.contains('camera_unavailable') ||
        code.contains('camera') && source == ImageSource.camera) {
      return AvatarPickError.cameraUnavailable;
    }
    return AvatarPickError.unknown;
  }
}
