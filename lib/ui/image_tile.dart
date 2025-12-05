import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:random_images/bloc/image_cubit.dart';

import 'custom_widgets/custem_progress_indecator.dart';

class ImageTile extends StatelessWidget {
  final String imageUrl;
  const ImageTile({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ImageCubit>();
    final theme = Theme.of(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, progress) {
          if (progress == null) {
            cubit.setImageLoading(false);
            return AnimatedOpacity(opacity: 1, duration: const Duration(milliseconds: 400), child: child);
          }

          cubit.setImageLoading(true);

          final expected = progress.expectedTotalBytes;
          final loaded = progress.cumulativeBytesLoaded;
          final value = expected != null ? loaded / expected : null;

          return Center(child: CustomProgressIndicator(value: value));
        },
        errorBuilder: (c, e, _) {
          cubit.setImageLoading(false);
          final color = theme.colorScheme.onPrimary;
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.broken_image_rounded, size: 50, color: color),
              SizedBox(height: 12),
              Text('Image failed to load', style: TextStyle(color: color)),
              SizedBox(height: 6),
              Text('Tap Another to try again', style: TextStyle(color: color)),
            ],
          );
        },
      ),
    );
  }
}
