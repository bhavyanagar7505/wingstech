import 'package:get/get.dart';
import 'package:flutter/material.dart';

class AppSnackbar {
  static void error(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.shade400,
      colorText: Colors.white,
      margin: const EdgeInsets.all(12),
      borderRadius: 12,
    );
  }

  static void success(String message) {
    Get.snackbar(
      'Success',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.shade400,
      colorText: Colors.white,
      margin: const EdgeInsets.all(12),
      borderRadius: 12,
    );
  }
}
