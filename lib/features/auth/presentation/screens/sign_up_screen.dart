import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:webant_gallery/core/presentation/theme/app_theme.dart';
import 'package:webant_gallery/features/auth/domain/repos/auth_repository.dart';
import 'package:webant_gallery/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:webant_gallery/core/presentation/widgets/custom_text_field.dart';
import 'package:webant_gallery/core/presentation/widgets/custom_button.dart';
import 'package:webant_gallery/features/auth/presentation/widgets/gradient_title.dart';
import 'package:webant_gallery/features/gallery/presentation/screens/home/home_page.dart';
import 'package:webant_gallery/gen/assets.gen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _nameController = TextEditingController();
  final _birthdayController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  DateTime? _selectedBirthday;
  bool _isLoading = false;
  String? _error;

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
            colorScheme: Theme.of(
              context,
            ).colorScheme.copyWith(primary: AppColors.primary),
          ),
          child: child!,
        );
      },
    );
    if (date != null) {
      setState(() {
        _selectedBirthday = date;
        _birthdayController.text =
            '${date.day.toString().padLeft(2, '0')}.'
            '${date.month.toString().padLeft(2, '0')}.'
            '${date.year}';
      });
    }
  }

  String? _validate() {
    if (_nameController.text.trim().isEmpty) return 'Enter your name';
    if (_selectedBirthday == null) return 'Select your birthday';
    if (_emailController.text.trim().isEmpty) return 'Enter your email';
    if (_passwordController.text.isEmpty) return 'Enter a password';
    if (_passwordController.text.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (_passwordController.text != _confirmPasswordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  Future<void> _signUp() async {
    final validationError = _validate();
    if (validationError != null) {
      setState(() => _error = validationError);
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    final result = await GetIt.I<AuthRepository>().signUp(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      displayName: _nameController.text.trim(),
      birthday: _selectedBirthday!,
      phone: _phoneController.text.trim().isNotEmpty
          ? _phoneController.text.trim()
          : null,
    );

    if (!mounted) return;

    result.fold(
      (failure) {
        setState(() {
          _isLoading = false;
          _error = failure.message;
        });
      },
      (_) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const HomePage()),
          (route) => false,
        );
      },
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
          onPressed: () => Navigator.of(context).pop(),
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              GradientTitle(text: 'Sign Up'),
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
              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(
                  _error!,
                  style: const TextStyle(fontSize: 14, color: AppColors.error),
                ),
              ],
              const SizedBox(height: 40),
              SizedBox(
                width: 163,
                child: CustomButton(
                  onPressed: _isLoading ? null : _signUp,
                  text: 'Sign Up',
                  isLoading: _isLoading,
                  filled: true,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: 163,
                child: CustomButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const SignInScreen()),
                    );
                  }, 
                  text: 'Sign In',
                  isLoading: _isLoading,
                  noBorder: true,
                ),
              ),              
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
