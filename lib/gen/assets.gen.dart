// dart format width=80

/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use,directives_ordering,implicit_dynamic_list_literal,unnecessary_import

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart' as _svg;
import 'package:vector_graphics/vector_graphics.dart' as _vg;

class $AssetsIconsGen {
  const $AssetsIconsGen();

  /// Directory path: assets/icons/forms
  $AssetsIconsFormsGen get forms => const $AssetsIconsFormsGen();

  /// File path: assets/icons/logo-er.svg
  SvgGenImage get logoEr => const SvgGenImage('assets/icons/logo-er.svg');

  /// File path: assets/icons/logo.svg
  SvgGenImage get logo => const SvgGenImage('assets/icons/logo.svg');

  /// Directory path: assets/icons/navigation
  $AssetsIconsNavigationGen get navigation => const $AssetsIconsNavigationGen();

  /// List of all assets
  List<SvgGenImage> get values => [logoEr, logo];
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/.gitkeep
  String get aGitkeep => 'assets/images/.gitkeep';

  /// List of all assets
  List<String> get values => [aGitkeep];
}

class $AssetsIconsFormsGen {
  const $AssetsIconsFormsGen();

  /// File path: assets/icons/forms/calendar.svg
  SvgGenImage get calendar =>
      const SvgGenImage('assets/icons/forms/calendar.svg');

  /// File path: assets/icons/forms/error.svg
  SvgGenImage get error => const SvgGenImage('assets/icons/forms/error.svg');

  /// File path: assets/icons/forms/loader.svg
  SvgGenImage get loader => const SvgGenImage('assets/icons/forms/loader.svg');

  /// File path: assets/icons/forms/mail.svg
  SvgGenImage get mail => const SvgGenImage('assets/icons/forms/mail.svg');

  /// File path: assets/icons/forms/pass-hide.svg
  SvgGenImage get passHide =>
      const SvgGenImage('assets/icons/forms/pass-hide.svg');

  /// File path: assets/icons/forms/pass-show.svg
  SvgGenImage get passShow =>
      const SvgGenImage('assets/icons/forms/pass-show.svg');

  /// File path: assets/icons/forms/phone.svg
  SvgGenImage get phone => const SvgGenImage('assets/icons/forms/phone.svg');

  /// File path: assets/icons/forms/search.svg
  SvgGenImage get search => const SvgGenImage('assets/icons/forms/search.svg');

  /// File path: assets/icons/forms/user.svg
  SvgGenImage get user => const SvgGenImage('assets/icons/forms/user.svg');

  /// List of all assets
  List<SvgGenImage> get values => [
    calendar,
    error,
    loader,
    mail,
    passHide,
    passShow,
    phone,
    search,
    user,
  ];
}

class $AssetsIconsNavigationGen {
  const $AssetsIconsNavigationGen();

  /// File path: assets/icons/navigation/back.svg
  SvgGenImage get back => const SvgGenImage('assets/icons/navigation/back.svg');

  /// File path: assets/icons/navigation/camera.svg
  SvgGenImage get camera =>
      const SvgGenImage('assets/icons/navigation/camera.svg');

  /// File path: assets/icons/navigation/home.svg
  SvgGenImage get home => const SvgGenImage('assets/icons/navigation/home.svg');

  /// File path: assets/icons/navigation/profile.svg
  SvgGenImage get profile =>
      const SvgGenImage('assets/icons/navigation/profile.svg');

  /// List of all assets
  List<SvgGenImage> get values => [back, camera, home, profile];
}

class Assets {
  const Assets._();

  static const $AssetsIconsGen icons = $AssetsIconsGen();
  static const $AssetsImagesGen images = $AssetsImagesGen();
}

class SvgGenImage {
  const SvgGenImage(this._assetName, {this.size, this.flavors = const {}})
    : _isVecFormat = false;

  const SvgGenImage.vec(this._assetName, {this.size, this.flavors = const {}})
    : _isVecFormat = true;

  final String _assetName;
  final Size? size;
  final Set<String> flavors;
  final bool _isVecFormat;

  _svg.SvgPicture svg({
    Key? key,
    bool matchTextDirection = false,
    AssetBundle? bundle,
    String? package,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    AlignmentGeometry alignment = Alignment.center,
    bool allowDrawingOutsideViewBox = false,
    WidgetBuilder? placeholderBuilder,
    String? semanticsLabel,
    bool excludeFromSemantics = false,
    _svg.SvgTheme? theme,
    _svg.ColorMapper? colorMapper,
    ColorFilter? colorFilter,
    Clip clipBehavior = Clip.hardEdge,
    @deprecated Color? color,
    @deprecated BlendMode colorBlendMode = BlendMode.srcIn,
    @deprecated bool cacheColorFilter = false,
  }) {
    final _svg.BytesLoader loader;
    if (_isVecFormat) {
      loader = _vg.AssetBytesLoader(
        _assetName,
        assetBundle: bundle,
        packageName: package,
      );
    } else {
      loader = _svg.SvgAssetLoader(
        _assetName,
        assetBundle: bundle,
        packageName: package,
        theme: theme,
        colorMapper: colorMapper,
      );
    }
    return _svg.SvgPicture(
      loader,
      key: key,
      matchTextDirection: matchTextDirection,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
      placeholderBuilder: placeholderBuilder,
      semanticsLabel: semanticsLabel,
      excludeFromSemantics: excludeFromSemantics,
      colorFilter:
          colorFilter ??
          (color == null ? null : ColorFilter.mode(color, colorBlendMode)),
      clipBehavior: clipBehavior,
      cacheColorFilter: cacheColorFilter,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
