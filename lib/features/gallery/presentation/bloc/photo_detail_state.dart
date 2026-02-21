import 'package:equatable/equatable.dart';
import 'package:webant_gallery/features/gallery/domain/entities/photo.dart';

enum PhotoDetailStatus { initial, loading, loaded, error, noConnection }

class PhotoDetailState extends Equatable {
  final PhotoDetailStatus status;
  final Photo? photo;
  final String? errorMessage;

  const PhotoDetailState({
    this.status = PhotoDetailStatus.initial,
    this.photo,
    this.errorMessage,
  });

  PhotoDetailState copyWith({
    PhotoDetailStatus? status,
    Photo? photo,
    String? errorMessage,
  }) {
    return PhotoDetailState(
      status: status ?? this.status,
      photo: photo ?? this.photo,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, photo, errorMessage];
}
