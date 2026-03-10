import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:webant_gallery/core/presentation/router/app_router.dart';
import 'package:webant_gallery/core/presentation/theme/app_theme.dart';
import 'package:webant_gallery/core/presentation/widgets/custom_button.dart';
import 'package:webant_gallery/core/presentation/widgets/custom_text_field.dart';
import 'package:webant_gallery/features/auth/domain/repos/auth_repository.dart';
import 'package:webant_gallery/features/auth/presentation/bloc/sign_in_bloc.dart';
import 'package:webant_gallery/features/auth/presentation/bloc/sign_in_event.dart';
import 'package:webant_gallery/features/auth/presentation/bloc/sign_in_state.dart';
import 'package:webant_gallery/features/auth/presentation/widgets/gradient_title.dart';
import 'package:webant_gallery/gen/assets.gen.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SignInBloc(
        repository: GetIt.I<AuthRepository>(),
      ),
      child: const _SignInView(),
    );
  }
}

class _SignInView extends StatefulWidget {
  const _SignInView();

  @override
  State<_SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<_SignInView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    context.read<SignInBloc>().add(SignInSubmitted(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignInBloc, SignInState>(
      listener: (context, state) {
        if (state.status == SignInStatus.success) {
          context.go(AppRoutes.home);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.surface,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_outlined,
              size: 24,
              color: AppColors.searchPlaceholder,
            ),
            onPressed: () => context.pop(),
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(1.0),
            child: Container(color: AppColors.disabledText, height: 1.0),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: BlocBuilder<SignInBloc, SignInState>(
              builder: (context, state) {
                final isLoading = state.status == SignInStatus.loading;
                return Column(
                  children: [
                    const SizedBox(height: 80),
                    const GradientTitle(text: 'Sign In'),
                    const SizedBox(height: 60),
                    CustomTextField(
                      controller: _emailController,
                      placeholder: 'Email',
                      keyboardType: TextInputType.emailAddress,
                      suffixIcon: Assets.icons.forms.mail,
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      controller: _passwordController,
                      placeholder: 'Password',
                      obscureText: true,
                    ),
                    if (state.status == SignInStatus.failure &&
                        state.errorMessage != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        state.errorMessage!,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.error,
                        ),
                      ),
                    ],
                    const SizedBox(height: 60),
                    SizedBox(
                      width: 163,
                      child: CustomButton(
                        onPressed: isLoading ? null : _submit,
                        text: 'Sign In',
                        isLoading: isLoading,
                        filled: true,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: 163,
                      child: CustomButton(
                        onPressed: () => context.push(AppRoutes.signUp),
                        text: 'Sign Up',
                        isLoading: isLoading,
                        noBorder: true,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
