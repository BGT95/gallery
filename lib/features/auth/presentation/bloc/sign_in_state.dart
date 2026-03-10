import 'package:equatable/equatable.dart';

enum SignInStatus { initial, loading, success, failure }

class SignInState extends Equatable {
  final SignInStatus status;
  final String? errorMessage;

  const SignInState({
    this.status = SignInStatus.initial,
    this.errorMessage,
  });

  SignInState copyWith({
    SignInStatus? status,
    String? errorMessage,
  }) {
    return SignInState(
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage];
}
