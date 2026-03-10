import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webant_gallery/features/auth/domain/repos/auth_repository.dart';
import 'package:webant_gallery/features/auth/presentation/bloc/sign_in_event.dart';
import 'package:webant_gallery/features/auth/presentation/bloc/sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final AuthRepository repository;

  SignInBloc({required this.repository}) : super(const SignInState()) {
    on<SignInSubmitted>(_onSubmitted);
  }

  Future<void> _onSubmitted(
    SignInSubmitted event,
    Emitter<SignInState> emit,
  ) async {
    if (event.email.isEmpty || event.password.isEmpty) {
      emit(state.copyWith(
        status: SignInStatus.failure,
        errorMessage: 'Please fill in all fields',
      ));
      return;
    }

    emit(state.copyWith(status: SignInStatus.loading));

    final result = await repository.signIn(
      email: event.email,
      password: event.password,
    );

    result.fold(
      (failure) => emit(state.copyWith(
        status: SignInStatus.failure,
        errorMessage: failure.message,
      )),
      (_) => emit(state.copyWith(status: SignInStatus.success)),
    );
  }
}
