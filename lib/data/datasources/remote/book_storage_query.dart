import 'dart:io';
import 'dart:typed_data';
import 'package:perpusku/core/constant/app_constant.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class BookStorageQuery {
  final SupabaseClient _client;
  final _uuid = const Uuid();

  BookStorageQuery(this._client);

  StorageFileApi get _storage =>
      _client.storage.from(AppConstants.bookCoversStorage);

  Future<String> uploadCover(File file, {String? existingPath}) async {
    if (existingPath != null) {
      await _deleteCoverByPath(existingPath);
    }

    final compressed = await _compressImage(file);
    final bytes = compressed ?? await file.readAsBytes();
    Uint8List uint8Bytes = Uint8List.fromList(bytes);

    const mimeType = 'image/jpeg';
    final path = 'covers/${_uuid.v4()}.jpg';

    await _storage.uploadBinary(
      path,
      uint8Bytes,
      fileOptions: const FileOptions(contentType: mimeType, upsert: false),
    );

    return _storage.getPublicUrl(path);
  }

  Future<void> deleteCover(String publicUrl) async {
    final path = _extractPath(publicUrl);
    if (path != null) await _deleteCoverByPath(path);
  }

  Future<void> _deleteCoverByPath(String path) async {
    try {
      await _storage.remove([path]);
    } catch (_) {
    }
  }

  String? _extractPath(String url) {
    try {
      final uri = Uri.parse(url);
      final segments = uri.pathSegments;
      final bucketIndex = segments.indexOf(AppConstants.bookCoversStorage);
      if (bucketIndex == -1) return null;
      return segments.sublist(bucketIndex + 1).join('/');
    } catch (_) {
      return null;
    }
  }

  Future<List<int>?> _compressImage(File file) async {
    try {
      final result = await FlutterImageCompress.compressWithFile(
        file.absolute.path,
        minWidth: 800,
        minHeight: 1200,
        quality: 85,
        format: CompressFormat.jpeg,
      );
      return result;
    } catch (_) {
      return null;
    }
  }
}
