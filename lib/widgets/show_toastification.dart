import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

void errorToastification(
    BuildContext context, String title, String description) {
  toastification.dismissAll();
  toastification.show(
    // alignment: Alignment.bottomCenter,
    style: ToastificationStyle.flatColored,
    type: ToastificationType.error,
    context: context,
    title: Text(
      title,
      style: const TextStyle(fontWeight: FontWeight.bold),
    ),
    description: Text(description),
    autoCloseDuration: const Duration(seconds: 5),
    icon: const Icon(
      Icons.error_outline,
      color: Colors.red,
    ),
  );
}

void warningToastification(
    BuildContext context, String title, String description) {
  toastification.dismissAll();
  toastification.show(
    // alignment: Alignment.bottomCenter,
    style: ToastificationStyle.flatColored,
    type: ToastificationType.warning,
    context: context,
    title: Text(
      title,
      style: const TextStyle(fontWeight: FontWeight.bold),
    ),
    description: Text(description),
    autoCloseDuration: const Duration(seconds: 5),
    icon: const Icon(
      Icons.warning_amber_outlined,
      color: Colors.orange,
    ),
  );
}

void succesToastification(
    BuildContext context, String title, String description) {
  toastification.dismissAll();
  toastification.show(
    // alignment: Alignment.bottomCenter,
    style: ToastificationStyle.flatColored,
    type: ToastificationType.success,
    context: context,
    title: Text(
      title,
      style: const TextStyle(fontWeight: FontWeight.bold),
    ),
    description: Text(description),
    autoCloseDuration: const Duration(seconds: 5),
    icon: const Icon(
      Icons.check_circle_outline,
      color: Colors.green,
    ),
  );
}
