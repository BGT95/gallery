import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webant_gallery/core/domain/failures.dart';
import 'package:webant_gallery/features/gallery/domain/repos/gallery_repository.dart';
import 'package:webant_gallery/features/gallery/presentation/bloc/photo_detail_event.dart';
import 'package:webant_gallery/features/gallery/presentation/bloc/photo_detail_state.dart';

class PhotoDetailBloc extends Bloc<PhotoDetailEvent, PhotoDetailState> {
  final GalleryRepository repository;

  PhotoDetailBloc({required this.repository})
      : super(const PhotoDetailState()) {
    on<PhotoDetailFetched>(_onFetched);
  }

  Future<void> _onFetched(
    PhotoDetailFetched event,
    Emitter<PhotoDetailState> emit,
  ) async {
    emit(state.copyWith(status: PhotoDetailStatus.loading));

    final result = await repository.getPhotoDetails(event.photoId);

    result.fold(
      (failure) {
        if (failure is NetworkFailure) {
          emit(state.copyWith(
            status: PhotoDetailStatus.noConnection,
            errorMessage: failure.message,
          ));
        } else {
          emit(state.copyWith(
            status: PhotoDetailStatus.error,
            errorMessage: failure.message,
          ));
        }
      },
      (photo) {
        emit(state.copyWith(status: PhotoDetailStatus.loaded, photo: photo));
      },
    );
  }
}
