import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:webant_gallery/core/presentation/theme/app_theme.dart';
import 'package:webant_gallery/features/gallery/domain/entities/photo.dart';

class PhotoGridItem extends StatelessWidget {
  final Photo photo;
  final VoidCallback onTap;

  const PhotoGridItem({super.key, required this.photo, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Hero(
        tag: 'photo_${photo.id}',
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: CachedNetworkImage(
            imageUrl: photo.fullImageUrl,
            fit: BoxFit.cover,
            placeholder: (_, __) => Container(
              color: AppColors.searchBackground,
              child: const Center(
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
            errorWidget: (_, __, ___) => Container(
              color: AppColors.searchBackground,
              child: const Icon(
                Icons.broken_image_outlined,
                color: AppColors.textSecondary,
                size: 32,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
