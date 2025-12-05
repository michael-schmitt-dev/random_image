import 'package:flutter/material.dart';

class CustomProgressIndicator extends StatelessWidget {
  const CustomProgressIndicator({this.color, this.value, super.key});

  final Color? color;
  final double? value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final cardColor = scheme.surface;

    final spinnerColor = color ?? scheme.primary;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: scheme.shadow.withAlpha(120), offset: const Offset(1, 1), blurRadius: 4)],
      ),
      child: CircularProgressIndicator(value: value, color: spinnerColor, strokeWidth: 3),
    );
  }
}
