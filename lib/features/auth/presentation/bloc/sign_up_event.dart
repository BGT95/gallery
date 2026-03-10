import 'package:equatable/equatable.dart';

abstract class SignUpEvent extends Equatable {
  const SignUpEvent();

  @override
  List<Object?> get props => [];
}

class SignUpSubmitted extends SignUpEvent {
  final String email;
  final String password;
  final String confirmPassword;
  final String displayName;
  final DateTime? birthday;
  final String? phone;

  const SignUpSubmitted({
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.displayName,
    this.birthday,
    this.phone,
  });

  @override
  List<Object?> get props => [
        email,
        password,
        confirmPassword,
        displayName,
        birthday,
        phone,
      ];
}
