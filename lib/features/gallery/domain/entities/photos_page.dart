import 'package:equatable/equatable.dart';
import 'package:webant_gallery/features/gallery/domain/entities/photo.dart';

class PhotosPage extends Equatable {
  final List<Photo> photos;
  final int totalItems;
  final int currentPage;
  final int? lastPage;

  const PhotosPage({
    required this.photos,
    required this.totalItems,
    required this.currentPage,
    this.lastPage,
  });

  bool get hasMore => lastPage != null && currentPage < lastPage!;

  @override
  List<Object?> get props => [photos, totalItems, currentPage, lastPage];
}
