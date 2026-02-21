import 'package:equatable/equatable.dart';
import 'package:webant_gallery/features/gallery/domain/entities/photo.dart';

enum PhotoListStatus { initial, loading, loaded, loadingMore, error, noConnection }

class PhotoListState extends Equatable {
  final PhotoListStatus status;
  final List<Photo> photos;
  final int currentPage;
  final bool hasMore;
  final String? errorMessage;

  const PhotoListState({
    this.status = PhotoListStatus.initial,
    this.photos = const [],
    this.currentPage = 1,
    this.hasMore = true,
    this.errorMessage,
  });

  PhotoListState copyWith({
    PhotoListStatus? status,
    List<Photo>? photos,
    int? currentPage,
    bool? hasMore,
    String? errorMessage,
  }) {
    return PhotoListState(
      status: status ?? this.status,
      photos: photos ?? this.photos,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, photos, currentPage, hasMore, errorMessage];
}
