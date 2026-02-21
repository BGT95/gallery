import 'package:equatable/equatable.dart';

abstract class PhotoDetailEvent extends Equatable {
  const PhotoDetailEvent();

  @override
  List<Object> get props => [];
}

class PhotoDetailFetched extends PhotoDetailEvent {
  final int photoId;

  const PhotoDetailFetched(this.photoId);

  @override
  List<Object> get props => [photoId];
}
