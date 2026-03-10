import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webant_gallery/features/auth/domain/repos/auth_repository.dart';
import 'package:webant_gallery/features/auth/presentation/bloc/sign_up_event.dart';
import 'package:webant_gallery/features/auth/presentation/bloc/sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final AuthRepository repository;

  SignUpBloc({required this.repository}) : super(const SignUpState()) {
    on<SignUpSubmitted>(_onSubmitted);
  }

  Future<void> _onSubmitted(
    SignUpSubmitted event,
    Emitter<SignUpState> emit,
  ) async {
    final error = _validate(event);
    if (error != null) {
      emit(state.copyWith(
        status: SignUpStatus.failure,
        errorMessage: error,
      ));
      return;
    }

    emit(state.copyWith(status: SignUpStatus.loading));

    final result = await repository.signUp(
      email: event.email.trim(),
      password: event.password,
      displayName: event.displayName.trim(),
      birthday: event.birthday!,
      phone: event.phone?.trim().isNotEmpty == true ? event.phone!.trim() : null,
    );

    result.fold(
      (failure) => emit(state.copyWith(
        status: SignUpStatus.failure,
        errorMessage: failure.message,
      )),
      (_) => emit(state.copyWith(status: SignUpStatus.success)),
    );
  }

  String? _validate(SignUpSubmitted event) {
    if (event.displayName.trim().isEmpty) return 'Enter your name';
    if (event.birthday == null) return 'Select your birthday';
    if (event.email.trim().isEmpty) return 'Enter your email';
    if (event.password.isEmpty) return 'Enter a password';
    if (event.password.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (event.password != event.confirmPassword) {
      return 'Passwords do not match';
    }
    return null;
  }
}
