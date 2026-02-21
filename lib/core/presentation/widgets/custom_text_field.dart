import 'package:flutter/material.dart';
import 'package:webant_gallery/core/presentation/theme/app_theme.dart';
import 'package:webant_gallery/gen/assets.gen.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String placeholder;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? errorText;
  final VoidCallback? onTap;
  final bool readOnly;
  final bool enabled;
  final bool isRequired;
  final SvgGenImage? suffixIcon;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.placeholder,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.errorText,
    this.onTap,
    this.readOnly = false,
    this.enabled = true,
    this.isRequired = false,
    this.suffixIcon,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscured;

  @override
  void initState() {
    super.initState();
    _obscured = widget.obscureText;
  }

  @override
  void didUpdateWidget(CustomTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.obscureText != widget.obscureText) {
      _obscured = widget.obscureText;
    }
  }

  bool get _hasError => widget.errorText != null;
  bool get _isPassword => widget.obscureText;

  static const _borderRadius = BorderRadius.all(Radius.circular(10));

  Color get _borderColor {
    if (!widget.enabled) return AppColors.disabled;
    if (_hasError) return AppColors.error;
    return AppColors.textSecondary;
  }

  Color get _focusedBorderColor {
    if (_hasError) return AppColors.error;
    return AppColors.primary;
  }

  Widget? get _buildSuffixIcon {
    if (_isPassword) {
      final icon = _obscured
          ? Assets.icons.forms.passShow
          : Assets.icons.forms.passHide;
      return GestureDetector(
        onTap: () => setState(() => _obscured = !_obscured),
        child: Padding(
          padding: const EdgeInsets.only(right: 10),
          child: icon.svg(
            width: 22,
            height: 22,
            colorFilter: ColorFilter.mode(
              _hasError ? AppColors.error : AppColors.textSecondary,
              BlendMode.srcIn,
            ),
          ),
        ),
      );
    }

    if (widget.suffixIcon != null) {
      return Padding(
        padding: const EdgeInsets.only(right: 10),
        child: widget.suffixIcon!.svg(
          width: 22,
          height: 22,
          colorFilter: ColorFilter.mode(
            !widget.enabled
                ? AppColors.disabled
                : _hasError
                    ? AppColors.error
                    : AppColors.textSecondary,
            BlendMode.srcIn,
          ),
        ),
      );
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: _obscured,
      keyboardType: widget.keyboardType,
      readOnly: widget.readOnly,
      enabled: widget.enabled,
      onTap: widget.onTap,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: widget.enabled ? AppColors.textPrimary : AppColors.disabled,
      ),
      decoration: InputDecoration(
        label: Text.rich(
          TextSpan(
            text: widget.placeholder,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: widget.enabled ? AppColors.textSecondary : AppColors.disabled,
            ),
            children: widget.isRequired
                ? [
                    TextSpan(
                      text: ' *',
                      style: TextStyle(
                        color: widget.enabled ? AppColors.primary : AppColors.disabled,
                      ),
                    ),
                  ]
                : null,
          ),
        ),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        errorText: widget.errorText,
        errorStyle: const TextStyle(fontSize: 12, color: AppColors.error),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
        suffixIcon: _buildSuffixIcon,
        suffixIconConstraints: const BoxConstraints(
          minWidth: 22,
          minHeight: 22,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: _borderRadius,
          borderSide: BorderSide(color: _borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: _borderRadius,
          borderSide: BorderSide(color: _focusedBorderColor, width: 1.5),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: _borderRadius,
          borderSide: const BorderSide(color: AppColors.disabled),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: _borderRadius,
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: _borderRadius,
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
      ),
    );
  }
}
