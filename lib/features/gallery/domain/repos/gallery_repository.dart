import 'package:dartz/dartz.dart';
import 'package:webant_gallery/core/domain/failures.dart';
import 'package:webant_gallery/features/gallery/domain/entities/photo.dart';
import 'package:webant_gallery/features/gallery/domain/entities/photos_page.dart';

abstract class GalleryRepository {
  Future<Either<Failure, PhotosPage>> getNewPhotos({
    required int page,
    required int limit,
  });

  Future<Either<Failure, PhotosPage>> getPopularPhotos({
    required int page,
    required int limit,
  });

  Future<Either<Failure, Photo>> getPhotoDetails(int id);
}
