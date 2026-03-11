import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int id;
  final String email;
  final String? displayName;
  final String? phone;
  final DateTime? birthday;

  const User({
    required this.id,
    required this.email,
    this.displayName,
    this.phone,
    this.birthday,
  });

  @override
  List<Object?> get props => [id, email, displayName, phone, birthday];
}
