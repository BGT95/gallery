import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webant_gallery/core/domain/failures.dart';
import 'package:webant_gallery/core/utils/api_constants.dart';
import 'package:webant_gallery/features/gallery/domain/entities/photo.dart';
import 'package:webant_gallery/features/gallery/domain/entities/photos_page.dart';
import 'package:webant_gallery/features/gallery/domain/repos/gallery_repository.dart';
import 'package:webant_gallery/features/gallery/presentation/bloc/photo_list_event.dart';
import 'package:webant_gallery/features/gallery/presentation/bloc/photo_list_state.dart';

enum PhotoListType { newPhotos, popularPhotos }

class PhotoListBloc extends Bloc<PhotoListEvent, PhotoListState> {
  final GalleryRepository repository;
  final PhotoListType type;

  PhotoListBloc({required this.repository, required this.type})
      : super(const PhotoListState()) {
    on<PhotoListFetched>(_onFetched);
    on<PhotoListRefreshed>(_onRefreshed);
    on<PhotoListNextPage>(_onNextPage);
  }

  Future<void> _onFetched(
    PhotoListFetched event,
    Emitter<PhotoListState> emit,
  ) async {
    if (state.status == PhotoListStatus.loading) return;
    emit(state.copyWith(status: PhotoListStatus.loading));
    await _loadPage(1, emit, isRefresh: false);
  }

  Future<void> _onRefreshed(
    PhotoListRefreshed event,
    Emitter<PhotoListState> emit,
  ) async {
    emit(const PhotoListState(status: PhotoListStatus.loading));
    await _loadPage(1, emit, isRefresh: true);
  }

  Future<void> _onNextPage(
    PhotoListNextPage event,
    Emitter<PhotoListState> emit,
  ) async {
    if (!state.hasMore ||
        state.status == PhotoListStatus.loadingMore ||
        state.status == PhotoListStatus.loading) {
      return;
    }

    emit(state.copyWith(status: PhotoListStatus.loadingMore));
    await _loadPage(state.currentPage + 1, emit, isRefresh: false);
  }

  Future<void> _loadPage(
    int page,
    Emitter<PhotoListState> emit, {
    required bool isRefresh,
  }) async {
    final int limit = ApiConstants.itemsPerPage;

    final Either<Failure, PhotosPage> result =
        type == PhotoListType.newPhotos
            ? await repository.getNewPhotos(page: page, limit: limit)
            : await repository.getPopularPhotos(page: page, limit: limit);

    result.fold(
      (failure) {
        if (failure is NetworkFailure) {
          emit(state.copyWith(
            status: PhotoListStatus.noConnection,
            errorMessage: failure.message,
            photos: isRefresh ? const [] : state.photos,
          ));
        } else {
          emit(state.copyWith(
            status: PhotoListStatus.error,
            errorMessage: failure.message,
            photos: isRefresh ? const [] : state.photos,
          ));
        }
      },
      (photosPage) {
        final List<Photo> allPhotos = page == 1
            ? List<Photo>.from(photosPage.photos)
            : <Photo>[...state.photos, ...photosPage.photos];
        emit(state.copyWith(
          status: PhotoListStatus.loaded,
          photos: allPhotos,
          currentPage: page,
          hasMore: photosPage.hasMore,
        ));
      },
    );
  }
}
