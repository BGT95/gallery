import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:webant_gallery/core/presentation/router/app_router.dart';
import 'package:webant_gallery/core/presentation/theme/app_theme.dart';
import 'package:webant_gallery/core/presentation/widgets/auth_app_bar.dart';
import 'package:webant_gallery/core/presentation/widgets/custom_button.dart';
import 'package:webant_gallery/core/presentation/widgets/custom_text_field.dart';
import 'package:webant_gallery/core/utils/date_formatter.dart';
import 'package:webant_gallery/features/auth/domain/repos/auth_repository.dart';
import 'package:webant_gallery/features/auth/presentation/bloc/sign_up_bloc.dart';
import 'package:webant_gallery/features/auth/presentation/bloc/sign_up_event.dart';
import 'package:webant_gallery/features/auth/presentation/bloc/sign_up_state.dart';
import 'package:webant_gallery/features/auth/presentation/widgets/gradient_title.dart';
import 'package:webant_gallery/gen/assets.gen.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SignUpBloc(
        repository: GetIt.I<AuthRepository>(),
      ),
      child: const _SignUpView(),
    );
  }
}

class _SignUpView extends StatefulWidget {
  const _SignUpView();

  @override
  State<_SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<_SignUpView> {
  final _nameController = TextEditingController();
  final _birthdayController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  DateTime? _selectedBirthday;

  @override
  void dispose() {
    _nameController.dispose();
    _birthdayController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _pickBirthday() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime(2000, 1, 1),
      firstDate: DateTime(1920),
      lastDate: now,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context)
                .colorScheme
                .copyWith(primary: AppColors.primary),
          ),
          child: child!,
        );
      },
    );
    if (date != null) {
      setState(() {
        _selectedBirthday = date;
        _birthdayController.text = date.formatDayMonthYear();
      });
    }
  }

  void _submit() {
    context.read<SignUpBloc>().add(SignUpSubmitted(
          email: _emailController.text,
          password: _passwordController.text,
          confirmPassword: _confirmPasswordController.text,
          displayName: _nameController.text,
          birthday: _selectedBirthday,
          phone: _phoneController.text,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpBloc, SignUpState>(
      listener: (context, state) {
        if (state.status == SignUpStatus.success) {
          context.go(AppRoutes.home);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: const AuthAppBar(),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: BlocBuilder<SignUpBloc, SignUpState>(
              builder: (context, state) {
                final isLoading = state.status == SignUpStatus.loading;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    const GradientTitle(text: 'Sign Up'),
                    const SizedBox(height: 60),
                    CustomTextField(
                      controller: _nameController,
                      placeholder: 'User Name',
                      isRequired: true,
                      suffixIcon: Assets.icons.forms.user,
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      controller: _birthdayController,
                      placeholder: 'Birthday',
                      isRequired: true,
                      readOnly: true,
                      onTap: _pickBirthday,
                      suffixIcon: Assets.icons.forms.calendar,
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      controller: _phoneController,
                      placeholder: 'Phone number',
                      keyboardType: TextInputType.phone,
                      suffixIcon: Assets.icons.forms.phone,
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      controller: _emailController,
                      placeholder: 'Email',
                      isRequired: true,
                      keyboardType: TextInputType.emailAddress,
                      suffixIcon: Assets.icons.forms.mail,
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      controller: _passwordController,
                      placeholder: 'Password',
                      isRequired: true,
                      obscureText: true,
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      controller: _confirmPasswordController,
                      placeholder: 'Confirm password',
                      isRequired: true,
                      obscureText: true,
                    ),
                    if (state.status == SignUpStatus.failure &&
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
                    const SizedBox(height: 40),
                    SizedBox(
                      width: 163,
                      child: CustomButton(
                        onPressed: isLoading ? null : _submit,
                        text: 'Sign Up',
                        isLoading: isLoading,
                        filled: true,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: 163,
                      child: CustomButton(
                        onPressed: () => context.go(AppRoutes.signIn),
                        text: 'Sign In',
                        isLoading: isLoading,
                        noBorder: true,
                      ),
                    ),
                    const SizedBox(height: 40),
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
