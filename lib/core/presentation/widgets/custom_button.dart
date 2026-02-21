import 'package:flutter/material.dart';
import 'package:webant_gallery/core/presentation/theme/app_theme.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    required this.onPressed,
    required this.text,
    this.isLoading = false,
    this.isDisabled = false,
    this.filled = false,
    this.noBorder = false,
    this.elevation,
    this.width,
    this.height,
    super.key,
  });

  final void Function()? onPressed;
  final String text;
  final bool isLoading;
  final bool isDisabled;
  final bool filled;
  final bool noBorder;
  final double? elevation;
  final double? width;
  final double? height;

  static const _borderRadius = BorderRadius.all(Radius.circular(10));
  static const _textStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.w500);

  bool get _effectiveDisabled => isDisabled || isLoading;

  Color _bgColor(bool pressed) {
    if (_effectiveDisabled) return AppColors.disabled;
    if (filled) return pressed ? AppColors.primary : AppColors.textPrimary;
    return Colors.transparent;
  }

  Color _fgColor(bool pressed) {
    if (_effectiveDisabled) return AppColors.disabledText;
    if (filled) return AppColors.surface;
    return pressed ? AppColors.primary : AppColors.textPrimary;
  }

  Color _borderColor(bool pressed) {
    if (_effectiveDisabled) return AppColors.disabled;
    if (noBorder) return Colors.transparent;
    return pressed ? AppColors.primary : AppColors.textPrimary;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 40,
      child: ElevatedButton(
        onPressed: _effectiveDisabled ? null : onPressed,
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith(
            (s) => _bgColor(s.contains(WidgetState.pressed)),
          ),
          foregroundColor: WidgetStateProperty.resolveWith(
            (s) => _fgColor(s.contains(WidgetState.pressed)),
          ),
          shape: WidgetStateProperty.resolveWith(
            (s) => RoundedRectangleBorder(
              side: BorderSide(color: _borderColor(s.contains(WidgetState.pressed))),
              borderRadius: _borderRadius,
            ),
          ),
          elevation: WidgetStateProperty.all(elevation ?? 0),
          overlayColor: WidgetStateProperty.all(Colors.transparent),
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.surface,
                ),
              )
            : Text(text, textAlign: TextAlign.center, style: _textStyle),
      ),
    );
  }
}
