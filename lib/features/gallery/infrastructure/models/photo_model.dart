import 'package:webant_gallery/core/utils/api_constants.dart';
import 'package:webant_gallery/features/gallery/domain/entities/photo.dart';

class PhotoModel extends Photo {
  const PhotoModel({
    required super.id,
    required super.name,
    super.description,
    required super.imagePath,
    required super.fullImageUrl,
    required super.isNew,
    required super.isPopular,
    super.userName,
    super.dateCreate,
  });

  factory PhotoModel.fromJson(Map<String, dynamic> json) {
    final file = json['file'] as Map<String, dynamic>?;
    final user = json['user'] as Map<String, dynamic>?;
    final path = file?['path'] as String? ?? '';

    return PhotoModel(
      id: json['id'] as int,
      name: (json['name'] as String?) ?? 'Photo #${json['id']}',
      description: json['description'] as String?,
      imagePath: path,
      fullImageUrl: '${ApiConstants.mediaUrl}$path',
      isNew: json['new'] as bool? ?? false,
      isPopular: json['popular'] as bool? ?? false,
      userName: user?['displayName'] as String?,
      dateCreate: json['dateCreate'] != null
          ? DateTime.tryParse(json['dateCreate'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'imagePath': imagePath,
    'new': isNew,
    'popular': isPopular,
    'userName': userName,
    'dateCreate': dateCreate?.toIso8601String(),
  };

  factory PhotoModel.fromCacheJson(Map<String, dynamic> json) {
    final path = json['imagePath'] as String? ?? '';

    return PhotoModel(
      id: json['id'] as int,
      name: (json['name'] as String?) ?? '',
      description: json['description'] as String?,
      imagePath: path,
      fullImageUrl: '${ApiConstants.mediaUrl}$path',
      isNew: json['new'] as bool? ?? false,
      isPopular: json['popular'] as bool? ?? false,
      userName: json['userName'] as String?,
      dateCreate: json['dateCreate'] != null
          ? DateTime.tryParse(json['dateCreate'] as String)
          : null,
    );
  }
}
