import 'package:flutter/material.dart';

class AppTextStyles {
  static TextStyle headline(BuildContext context) =>
      Theme.of(context).textTheme.headlineMedium!.copyWith(
        color: Theme.of(context).colorScheme.primary,
        fontWeight: FontWeight.bold,
        letterSpacing: -0.5,
      );
  static TextStyle subtitle(BuildContext context) => TextStyle(
    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.6),
    fontSize: 16,
  );
  static TextStyle splashSubtitle() =>
      const TextStyle(color: Colors.white60, fontSize: 14, letterSpacing: 0.5);
  static TextStyle body(BuildContext context) =>
      TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 14);
  static TextStyle caption(BuildContext context) => TextStyle(
    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.6),
    fontSize: 12,
  );
  static TextStyle buttonText(BuildContext context) =>
      const TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
  static TextStyle linkText(BuildContext context) => TextStyle(
    color: Theme.of(context).colorScheme.secondary,
    fontWeight: FontWeight.bold,
  );
}
