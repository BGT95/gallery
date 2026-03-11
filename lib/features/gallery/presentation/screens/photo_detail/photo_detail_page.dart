import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:webant_gallery/core/presentation/theme/app_theme.dart';
import 'package:webant_gallery/core/presentation/widgets/app_cached_image.dart';
import 'package:webant_gallery/core/presentation/widgets/app_loading_indicator.dart';
import 'package:webant_gallery/core/presentation/widgets/error_widget.dart';
import 'package:webant_gallery/core/presentation/widgets/no_connection_widget.dart';
import 'package:webant_gallery/core/utils/date_formatter.dart';
import 'package:webant_gallery/features/gallery/domain/repos/gallery_repository.dart';
import 'package:webant_gallery/features/gallery/presentation/bloc/photo_detail_bloc.dart';
import 'package:webant_gallery/features/gallery/presentation/bloc/photo_detail_event.dart';
import 'package:webant_gallery/features/gallery/presentation/bloc/photo_detail_state.dart';

class PhotoDetailPage extends StatelessWidget {
  final int photoId;

  const PhotoDetailPage({super.key, required this.photoId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PhotoDetailBloc(
        repository: GetIt.I<GalleryRepository>(),
      )..add(PhotoDetailFetched(photoId)),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.surface,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, size: 24),
            onPressed: () => context.pop(),
          ),
          title: BlocBuilder<PhotoDetailBloc, PhotoDetailState>(
            builder: (context, state) {
              return Text(
                state.photo?.name ?? 'Title',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textPrimary,
                ),
              );
            },
          ),
        ),
        body: BlocBuilder<PhotoDetailBloc, PhotoDetailState>(
          builder: (context, state) {
            if (state.status == PhotoDetailStatus.loading) {
              return const AppLoadingIndicator();
            }

            if (state.status == PhotoDetailStatus.noConnection) {
              return NoConnectionWidget(
                onRetry: () => context
                    .read<PhotoDetailBloc>()
                    .add(PhotoDetailFetched(photoId)),
              );
            }

            if (state.status == PhotoDetailStatus.error) {
              return AppErrorWidget(
                message: state.errorMessage ?? 'Неизвестная ошибка',
                onRetry: () => context
                    .read<PhotoDetailBloc>()
                    .add(PhotoDetailFetched(photoId)),
              );
            }

            final photo = state.photo;
            if (photo == null) return const SizedBox.shrink();

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Hero(
                    tag: 'photo_${photo.id}',
                    child: AspectRatio(
                      aspectRatio: 360 / 240,
                      child: AppCachedImage(
                        imageUrl: photo.fullImageUrl,
                        width: double.infinity,
                        iconSize: 48,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          photo.name,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (photo.userName != null)
                              Expanded(
                                child: Text(
                                  photo.userName!,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            if (photo.dateCreate != null)
                              Text(
                                photo.dateCreate!.formatDayMonthYear(),
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                          ],
                        ),
                        if (photo.description != null &&
                            photo.description!.isNotEmpty) ...[
                          const SizedBox(height: 14),
                          Text(
                            photo.description!,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textPrimary,
                              height: 1.375,
                            ),
                          ),
                        ],
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

}
