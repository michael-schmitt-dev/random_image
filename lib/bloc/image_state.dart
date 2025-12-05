import 'package:flutter/material.dart';

class ImageState {
  const ImageState({this.imageUrl, this.isJsonLoading = false, this.isImageLoading = false, this.backgroundColor = Colors.white, this.errorMessage});

  final String? imageUrl;
  final bool isJsonLoading;
  final bool isImageLoading;
  final Color backgroundColor;
  final String? errorMessage;

  ImageState copyWith({String? imageUrl, bool? isJsonLoading, bool? isImageLoading, Color? backgroundColor, String? errorMessage}) {
    return ImageState(
      imageUrl: imageUrl ?? this.imageUrl,
      isJsonLoading: isJsonLoading ?? this.isJsonLoading,
      isImageLoading: isImageLoading ?? this.isImageLoading,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      errorMessage: errorMessage,
    );
  }
}
