import 'package:flutter/material.dart';
import 'package:webant_gallery/core/presentation/widgets/app_cached_image.dart';
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
          child: AppCachedImage(imageUrl: photo.fullImageUrl),
        ),
      ),
    );
  }
}
