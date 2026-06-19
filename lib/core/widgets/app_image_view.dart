import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_contacts_app/core/utils/image_path_utils.dart';
import 'package:google_contacts_app/core/utils/responsive.dart';
import 'package:google_contacts_app/gen/assets.gen.dart';

class AppImageView extends StatelessWidget {
  const AppImageView({
    super.key,
    required this.imagePath,
    this.height,
    this.width,
    this.color,
    this.fit,
    this.alignment,
    this.onTap,
    this.margin,
    this.radius,
    this.border,
    this.placeholderAssetPath,
  });

  final String? imagePath;
  final double? height;
  final double? width;
  final Color? color;
  final BoxFit? fit;
  final Alignment? alignment;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? radius;
  final BoxBorder? border;
  final String? placeholderAssetPath;

  @override
  Widget build(BuildContext context) {
    final child = _buildWidget(context);
    if (alignment != null) {
      return Align(alignment: alignment!, child: child);
    }
    return child;
  }

  Widget _buildWidget(BuildContext context) {
    final image = _buildClippedImage(context);

    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: onTap == null ? image : InkWell(onTap: onTap, borderRadius: radius, child: image),
    );
  }

  Widget _buildClippedImage(BuildContext context) {
    final image = _buildBorderedImage(context);

    if (radius == null) {
      return image;
    }

    return ClipRRect(borderRadius: radius!, child: image);
  }

  Widget _buildBorderedImage(BuildContext context) {
    final image = _buildImageView(context);

    if (border == null) {
      return image;
    }

    return Container(
      decoration: BoxDecoration(border: border, borderRadius: radius),
      child: image,
    );
  }

  Widget _buildImageView(BuildContext context) {
    final path = imagePath;
    if (path == null || path.isEmpty) {
      return _buildPlaceholder(context);
    }

    final resolvedFit = fit ?? BoxFit.cover;

    switch (path.imageSourceType) {
      case ImageSourceType.svg:
        return SizedBox(
          height: height,
          width: width,
          child: SvgPicture.asset(
            path,
            height: height,
            width: width,
            fit: fit ?? BoxFit.contain,
            colorFilter: color == null ? null : ColorFilter.mode(color!, BlendMode.srcIn),
          ),
        );
      case ImageSourceType.file:
        return Image.file(
          File(path.resolvedFilePath),
          height: height,
          width: width,
          fit: resolvedFit,
          color: color,
          errorBuilder: (_, __, ___) => _buildPlaceholder(context),
        );
      case ImageSourceType.network:
        return CachedNetworkImage(
          height: height,
          width: width,
          fit: fit,
          imageUrl: path,
          color: color,
          placeholder: (_, __) => _buildLoadingIndicator(context),
          errorWidget: (_, __, ___) => _buildPlaceholder(context),
        );
      case ImageSourceType.png:
      case ImageSourceType.gif:
      case ImageSourceType.unknown:
        return Image.asset(
          path,
          height: height,
          width: width,
          fit: resolvedFit,
          color: color,
          errorBuilder: (_, __, ___) => _buildPlaceholder(context),
        );
    }
  }

  Widget _buildLoadingIndicator(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final indicatorSize = Rs.dp(30);

    return SizedBox(
      height: height ?? indicatorSize,
      width: width ?? indicatorSize,
      child: Center(
        child: SizedBox(
          height: indicatorSize,
          width: indicatorSize,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: colorScheme.primary,
            backgroundColor: colorScheme.surfaceContainerHighest,
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    final placeholderPath = placeholderAssetPath ?? Assets.images.appLogo.path;
    final resolvedFit = fit ?? BoxFit.cover;

    return Image.asset(
      placeholderPath,
      height: height,
      width: width,
      fit: resolvedFit,
      errorBuilder: (_, __, ___) => _buildBrokenImageIcon(context),
    );
  }

  Widget _buildBrokenImageIcon(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      height: height,
      width: width,
      child: Icon(Icons.broken_image_outlined, size: Rs.dp(32), color: colorScheme.outline),
    );
  }
}
