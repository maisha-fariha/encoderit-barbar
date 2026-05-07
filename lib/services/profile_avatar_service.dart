import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../auth/app_auth_gateway.dart';
import '../utils/api_endpoints.dart';

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

/// Per-user profile avatar with offline-first storage and online sync.
///
/// - Picking from gallery/camera writes the image to a per-user file under
///   `<app docs>/profile_avatars/<user-key>.jpg` so each logged-in user
///   has their own image, isolated from other accounts on the same device.
/// - The change is reflected immediately in the UI (offline-first).
/// - When network is available (now or via [Connectivity.onConnectivityChanged]),
///   pending uploads are flushed to the backend.
class ProfileAvatarService {
  ProfileAvatarService({
    required this.gateway,
    required this.connectivity,
    required this.prefs,
    ImagePicker? picker,
  }) : _picker = picker ?? ImagePicker();

  final AppAuthGateway gateway;
  final Connectivity connectivity;
  final SharedPreferences prefs;
  final ImagePicker _picker;

  static const String _pendingMapKey = 'profile_avatar_pending_v1';

  /// Bumped on any local change so listening widgets rebuild.
  final ValueNotifier<int> revision = ValueNotifier<int>(0);

  StreamSubscription<ConnectivityResult>? _connSub;
  String? _currentUserKey;
  bool _syncing = false;

  Future<void> initialize() async {
    _currentUserKey = await _readUserKey();
    _connSub = connectivity.onConnectivityChanged.listen((status) {
      if (status != ConnectivityResult.none) {
        unawaited(trySync());
      }
    });
    unawaited(trySync());
  }

  Future<void> dispose() async {
    await _connSub?.cancel();
    _connSub = null;
  }

  /// Call after login/logout so the per-user binding refreshes.
  Future<void> onAuthChanged() async {
    _currentUserKey = await _readUserKey();
    revision.value++;
    unawaited(trySync());
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

  /// Returns the local avatar [File] for the currently logged-in user,
  /// or `null` if none has been set on this device for that user.
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
      await _markPending(key, true);
      revision.value++;
      unawaited(trySync());
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

  Map<String, dynamic> _readPendingMap() {
    final raw = prefs.getString(_pendingMapKey);
    if (raw == null || raw.isEmpty) return <String, dynamic>{};
    try {
      final m = jsonDecode(raw);
      if (m is Map) return Map<String, dynamic>.from(m);
    } catch (_) {}
    return <String, dynamic>{};
  }

  Future<void> _writePendingMap(Map<String, dynamic> map) async {
    await prefs.setString(_pendingMapKey, jsonEncode(map));
  }

  Future<void> _markPending(String userKey, bool pending) async {
    final map = _readPendingMap();
    if (pending) {
      map[userKey] = true;
    } else {
      map.remove(userKey);
    }
    await _writePendingMap(map);
  }

  /// Whether the currently logged-in user's avatar is awaiting upload.
  Future<bool> isCurrentUserPending() async {
    final key = _currentUserKey ??= await _readUserKey();
    if (key == null) return false;
    return _readPendingMap()[key] == true;
  }

  Future<bool> _hasNetwork() async {
    final r = await connectivity.checkConnectivity();
    return r != ConnectivityResult.none;
  }

  /// Uploads any pending avatars when network is available.
  /// Safe to call repeatedly; concurrent calls are deduped.
  Future<void> trySync() async {
    if (_syncing) return;
    if (!await _hasNetwork()) return;
    _syncing = true;
    try {
      final pending = _readPendingMap();
      if (pending.isEmpty) return;
      for (final entry in pending.entries.toList()) {
        final userKey = entry.key;
        final file = await _userAvatarFile(userKey);
        if (!await file.exists()) {
          await _markPending(userKey, false);
          continue;
        }
        final ok = await _upload(file);
        if (ok) {
          await _markPending(userKey, false);
          revision.value++;
        }
      }
    } finally {
      _syncing = false;
    }
  }

  Future<bool> _upload(File file) async {
    try {
      final api = gateway.apiService;
      final form = FormData.fromMap({
        'avatar': await MultipartFile.fromFile(
          file.path,
          filename: p.basename(file.path),
        ),
      });
      final res = await api.post<Map<String, dynamic>>(
        ApiEndpoints.profileAvatar,
        data: form,
      );
      return res.success;
    } catch (_) {
      return false;
    }
  }
}
