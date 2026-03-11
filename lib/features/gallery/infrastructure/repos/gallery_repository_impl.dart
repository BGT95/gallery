import 'package:dartz/dartz.dart';
import 'package:webant_gallery/core/domain/exceptions.dart';
import 'package:webant_gallery/core/domain/failures.dart';
import 'package:webant_gallery/core/infrastructure/network/network_info.dart';
import 'package:webant_gallery/core/utils/logger.dart';
import 'package:webant_gallery/features/gallery/domain/entities/photo.dart';
import 'package:webant_gallery/features/gallery/domain/entities/photos_page.dart';
import 'package:webant_gallery/features/gallery/domain/repos/gallery_repository.dart';
import 'package:webant_gallery/features/gallery/infrastructure/data_sources/gallery_local_data_source.dart';
import 'package:webant_gallery/features/gallery/infrastructure/data_sources/gallery_remote_data_source.dart';
import 'package:webant_gallery/features/gallery/infrastructure/models/photo_model.dart';

class GalleryRepositoryImpl implements GalleryRepository {
  final GalleryRemoteDataSource remoteDataSource;
  final GalleryLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  GalleryRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, PhotosPage>> getNewPhotos({
    required int page,
    required int limit,
  }) async {
    return _getPhotos(
      remote: () => remoteDataSource.getNewPhotos(page: page, limit: limit),
      cacheKey: localDataSource.keyForNew(page),
    );
  }

  @override
  Future<Either<Failure, PhotosPage>> getPopularPhotos({
    required int page,
    required int limit,
  }) async {
    return _getPhotos(
      remote: () => remoteDataSource.getPopularPhotos(page: page, limit: limit),
      cacheKey: localDataSource.keyForPopular(page),
    );
  }

  Future<Either<Failure, PhotosPage>> _getPhotos({
    required Future<PhotosPage> Function() remote,
    required String cacheKey,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final page = await remote();
        final models = page.photos.cast<PhotoModel>();
        await localDataSource.cachePhotos(cacheKey, models);
        AppLogger.network('Fetched ${models.length} photos (cache: $cacheKey)');
        return Right(page);
      } on ServerException catch (e) {
        AppLogger.error('Server error fetching photos', error: e);
        return Left(ServerFailure(e.message, statusCode: e.statusCode));
      } on NetworkException {
        AppLogger.warning('Network exception while fetching photos');
        return const Left(NetworkFailure());
      }
    } else {
      try {
        final cached = await localDataSource.getCachedPhotos(cacheKey);
        AppLogger.info('Loaded ${cached.length} photos from cache ($cacheKey)');
        return Right(
          PhotosPage(
            photos: cached,
            totalItems: cached.length,
            currentPage: 1,
            lastPage: 1,
          ),
        );
      } on CacheException {
        AppLogger.warning('No cached photos for key: $cacheKey');
        return const Left(NetworkFailure());
      }
    }
  }

  @override
  Future<Either<Failure, Photo>> getPhotoDetails(int id) async {
    if (await networkInfo.isConnected) {
      try {
        final photo = await remoteDataSource.getPhotoDetails(id);
        await localDataSource.cachePhoto(photo);
        AppLogger.network('Fetched and cached photo detail #$id');
        return Right(photo);
      } on ServerException catch (e) {
        AppLogger.error('Server error fetching photo #$id', error: e);
        return Left(ServerFailure(e.message, statusCode: e.statusCode));
      } on NetworkException {
        AppLogger.warning('Network exception fetching photo #$id');
        return const Left(NetworkFailure());
      }
    } else {
      try {
        final cached = await localDataSource.getCachedPhoto(id);
        AppLogger.info('Loaded photo #$id from cache');
        return Right(cached);
      } on CacheException {
        AppLogger.warning('No cached data for photo #$id');
        return const Left(NetworkFailure());
      }
    }
  }
}
