enum ImageSourceType {
  svg,
  png,
  gif,
  network,
  file,
  unknown,
}

extension ImagePathExtension on String {
  ImageSourceType get imageSourceType {
    final lower = toLowerCase();

    if (startsWith('http://') || startsWith('https://')) {
      return ImageSourceType.network;
    }
    if (lower.endsWith('.svg')) {
      return ImageSourceType.svg;
    }
    if (lower.endsWith('.gif')) {
      return ImageSourceType.gif;
    }
    if (startsWith('file://') || startsWith('/')) {
      return ImageSourceType.file;
    }
    if (lower.endsWith('.png') ||
        lower.endsWith('.jpg') ||
        lower.endsWith('.jpeg') ||
        lower.endsWith('.webp')) {
      return ImageSourceType.png;
    }

    return ImageSourceType.unknown;
  }

  String get resolvedFilePath {
    if (startsWith('file://')) {
      return replaceFirst('file://', '');
    }
    return this;
  }
}
