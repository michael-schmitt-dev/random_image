import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:random_images/bloc/image_state.dart';

class ImageCubit extends Cubit<ImageState> {
  ImageCubit() : super(const ImageState());

  Future<void> fetchRandomImage() async {
    emit(state.copyWith(isJsonLoading: true, errorMessage: null));
    try {
      final response = await http.get(Uri.parse('https://november7-730026606190.europe-west1.run.app/image'));

      if (response.statusCode == 200) {
        final url = jsonDecode(response.body)['url'] as String;
        extractBackgroundColor(url);
        emit(state.copyWith(imageUrl: url, isJsonLoading: false));
      } else {
        emit(state.copyWith(isJsonLoading: false, errorMessage: 'Failed to fetch image.'));
      }
    } catch (_) {
      emit(state.copyWith(isJsonLoading: false, errorMessage: 'Network error.'));
    }
  }

  void setImageLoading(bool loading) {
    emit(state.copyWith(isImageLoading: loading));
  }

  Future<void> extractBackgroundColor(String url) async {
    final provider = NetworkImage(url);
    final stream = provider.resolve(ImageConfiguration.empty);
    final completer = Completer<ImageInfo>();

    final listener = ImageStreamListener((info, _) {
      completer.complete(info);
    });

    stream.addListener(listener);
    final info = await completer.future;
    stream.removeListener(listener);

    final bytes = await info.image.toByteData(format: ImageByteFormat.rawRgba);
    if (bytes == null) return;

    final data = bytes.buffer.asUint8List();
    int r = 0, g = 0, b = 0;
    int count = info.image.width * info.image.height;

    for (int i = 0; i < data.length; i += 4) {
      r += data[i];
      g += data[i + 1];
      b += data[i + 2];
    }

    emit(state.copyWith(backgroundColor: Color.fromARGB(255, r ~/ count, g ~/ count, b ~/ count)));
  }
}
