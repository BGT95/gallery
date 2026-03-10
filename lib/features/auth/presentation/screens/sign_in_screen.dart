import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:webant_gallery/core/presentation/router/app_router.dart';
import 'package:webant_gallery/core/presentation/theme/app_theme.dart';
import 'package:webant_gallery/core/presentation/widgets/custom_button.dart';
import 'package:webant_gallery/core/presentation/widgets/custom_text_field.dart';
import 'package:webant_gallery/features/auth/domain/repos/auth_repository.dart';
import 'package:webant_gallery/features/auth/presentation/widgets/gradient_title.dart';
import 'package:webant_gallery/gen/assets.gen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      setState(() => _error = 'Please fill in all fields');
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    final result = await GetIt.I<AuthRepository>().signIn(
      email: email,
      password: password,
    );

    if (!mounted) return;

    result.fold(
      (failure) {
        setState(() {
          _isLoading = false;
          _error = failure.message;
        });
      },
      (_) => context.go(AppRoutes.home),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          child: Column(
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
              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(
                  _error!,
                  style: const TextStyle(fontSize: 14, color: AppColors.error),
                ),
              ],
              const SizedBox(height: 60),
              SizedBox(
                width: 163,
                child: CustomButton(
                  onPressed: _isLoading ? null : _signIn,
                  text: 'Sign In',
                  isLoading: _isLoading,
                  filled: true,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: 163,
                child: CustomButton(
                  onPressed: () => context.push(AppRoutes.signUp),
                  text: 'Sign Up',
                  isLoading: _isLoading,
                  noBorder: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
