import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:webant_gallery/core/domain/exceptions.dart';
import 'package:webant_gallery/core/infrastructure/local/hive_service.dart';
import 'package:webant_gallery/features/gallery/infrastructure/models/photo_model.dart';

abstract class GalleryLocalDataSource {
  Future<List<PhotoModel>> getCachedPhotos(String key);
  Future<void> cachePhotos(String key, List<PhotoModel> photos);
  Future<void> clearCache(String key);
}

class GalleryLocalDataSourceImpl implements GalleryLocalDataSource {
  final Box<String> _box;

  static const _newPhotosKey = 'cached_new_photos';
  static const _popularPhotosKey = 'cached_popular_photos';

  GalleryLocalDataSourceImpl(this._box);

  static String keyForNew(int page) => '${_newPhotosKey}_$page';
  static String keyForPopular(int page) => '${_popularPhotosKey}_$page';

  @override
  Future<List<PhotoModel>> getCachedPhotos(String key) async {
    final jsonStr = _box.get(key);
    if (jsonStr == null) throw const CacheException();

    final list = json.decode(jsonStr) as List<dynamic>;
    return list
        .map((e) => PhotoModel.fromCacheJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> cachePhotos(String key, List<PhotoModel> photos) async {
    final jsonStr = json.encode(photos.map((p) => p.toJson()).toList());
    await _box.put(key, jsonStr);
  }

  @override
  Future<void> clearCache(String key) async {
    final keysToDelete = _box.keys.where(
      (k) => k.toString().startsWith(key),
    );
    for (final k in keysToDelete) {
      await _box.delete(k);
    }
  }

  factory GalleryLocalDataSourceImpl.create() {
    return GalleryLocalDataSourceImpl(HiveService.photoCache);
  }
}
