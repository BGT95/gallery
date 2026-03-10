import 'package:equatable/equatable.dart';

class Photo extends Equatable {
  final int id;
  final String name;
  final String? description;
  final String imagePath;
  final String fullImageUrl;
  final bool isNew;
  final bool isPopular;
  final String? userName;
  final DateTime? dateCreate;

  const Photo({
    required this.id,
    required this.name,
    this.description,
    required this.imagePath,
    required this.fullImageUrl,
    required this.isNew,
    required this.isPopular,
    this.userName,
    this.dateCreate,
  });

  @override
  List<Object?> get props => [id];
}
