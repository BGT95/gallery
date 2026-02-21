import 'package:dio/dio.dart';
import 'package:webant_gallery/core/domain/exceptions.dart';
import 'package:webant_gallery/core/utils/api_constants.dart';
import 'package:webant_gallery/features/gallery/infrastructure/models/photo_model.dart';
import 'package:webant_gallery/features/gallery/infrastructure/models/photos_page_model.dart';

abstract class GalleryRemoteDataSource {
  Future<PhotosPageModel> getNewPhotos({required int page, required int limit});
  Future<PhotosPageModel> getPopularPhotos({required int page, required int limit});
  Future<PhotoModel> getPhotoDetails(int id);
}

class GalleryRemoteDataSourceImpl implements GalleryRemoteDataSource {
  final Dio dio;

  GalleryRemoteDataSourceImpl(this.dio);

  @override
  Future<PhotosPageModel> getNewPhotos({
    required int page,
    required int limit,
  }) async {
    return _fetchPhotos(page: page, limit: limit, filterKey: 'new');
  }

  @override
  Future<PhotosPageModel> getPopularPhotos({
    required int page,
    required int limit,
  }) async {
    return _fetchPhotos(page: page, limit: limit, filterKey: 'popular');
  }

  Future<PhotosPageModel> _fetchPhotos({
    required int page,
    required int limit,
    required String filterKey,
  }) async {
    try {
      final response = await dio.get(
        ApiConstants.photosEndpoint,
        queryParameters: {
          filterKey: true,
          'page': page,
          'itemsPerPage': limit,
        },
      );
      return PhotosPageModel.fromJson(
        response.data as Map<String, dynamic>,
        page,
      );
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout) {
        throw const NetworkException();
      }
      throw ServerException(
        _extractErrorMessage(e),
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<PhotoModel> getPhotoDetails(int id) async {
    try {
      final response = await dio.get('${ApiConstants.photosEndpoint}/$id');
      return PhotoModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout) {
        throw const NetworkException();
      }
      throw ServerException(
        _extractErrorMessage(e),
        statusCode: e.response?.statusCode,
      );
    }
  }

  String _extractErrorMessage(DioException e) {
    final data = e.response?.data;
    if (data is Map<String, dynamic>) {
      return (data['detail'] as String?) ??
          (data['title'] as String?) ??
          'Ошибка сервера';
    }
    return e.message ?? 'Неизвестная ошибка';
  }
}
