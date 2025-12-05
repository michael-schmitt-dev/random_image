import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:random_images/bloc/image_cubit.dart';
import 'package:random_images/bloc/image_state.dart';
import 'package:random_images/ui/custom_widgets/custem_progress_indecator.dart';
import 'package:random_images/ui/image_tile.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.system);

  void toggle() {
    emit(state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light);
  }
}

void main() {
  runApp(const MainScreen());
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ImageCubit()..fetchRandomImage()),
        BlocProvider(create: (_) => ThemeCubit()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            title: 'Random Image',
            theme: ThemeData.light(useMaterial3: true),
            darkTheme: ThemeData.dark(useMaterial3: true),
            themeMode: themeMode,
            home: BlocBuilder<ImageCubit, ImageState>(
              builder: (context, state) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  color: state.backgroundColor,
                  child: Scaffold(
                    appBar: AppBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      actions: [IconButton(icon: Icon(Icons.brightness_6), onPressed: () => context.read<ThemeCubit>().toggle())],
                    ),
                    backgroundColor: Colors.transparent,
                    body: SafeArea(
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AspectRatio(
                                aspectRatio: 1,
                                child: state.isJsonLoading
                                    ? const Center(child: CustomProgressIndicator())
                                    : state.imageUrl == null
                                    ? const SizedBox.shrink()
                                    : ImageTile(imageUrl: state.imageUrl!),
                              ),
                              const SizedBox(height: 24),
                              ElevatedButton(
                                onPressed: () {
                                  if (state.isJsonLoading || state.isImageLoading) {
                                    return;
                                  }
                                  context.read<ImageCubit>().fetchRandomImage();
                                },
                                child: const Text('Another'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
