import 'package:webant_gallery/features/gallery/domain/entities/photos_page.dart';
import 'package:webant_gallery/features/gallery/infrastructure/models/photo_model.dart';

class PhotosPageModel extends PhotosPage {
  const PhotosPageModel({
    required super.photos,
    required super.totalItems,
    required super.currentPage,
    super.lastPage,
  });

  factory PhotosPageModel.fromJson(Map<String, dynamic> json, int page) {
    final members = json['hydra:member'] as List<dynamic>? ?? [];
    final photos = members
        .map((e) => PhotoModel.fromJson(e as Map<String, dynamic>))
        .toList();

    final totalItems = json['hydra:totalItems'] as int? ?? 0;

    int? lastPage;
    final view = json['hydra:view'] as Map<String, dynamic>?;
    if (view != null) {
      final lastUrl = view['hydra:last'] as String?;
      if (lastUrl != null) {
        final uri = Uri.tryParse(lastUrl);
        if (uri != null) {
          lastPage = int.tryParse(uri.queryParameters['page'] ?? '');
        }
      }
    }

    return PhotosPageModel(
      photos: photos,
      totalItems: totalItems,
      currentPage: page,
      lastPage: lastPage,
    );
  }
}
