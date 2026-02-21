import 'package:equatable/equatable.dart';

abstract class PhotoListEvent extends Equatable {
  const PhotoListEvent();

  @override
  List<Object> get props => [];
}

class PhotoListFetched extends PhotoListEvent {
  const PhotoListFetched();
}

class PhotoListRefreshed extends PhotoListEvent {
  const PhotoListRefreshed();
}

class PhotoListNextPage extends PhotoListEvent {
  const PhotoListNextPage();
}
