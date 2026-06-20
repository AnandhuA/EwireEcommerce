import 'package:ewire_ecommerce/core/themes/app_colors.dart';
import 'package:ewire_ecommerce/core/themes/theme_extensions.dart';
import 'package:flutter/material.dart';

class AppAlertDialog {
  static Future<bool> show({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: Text(cancelText),
            ),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: context.primary),
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: Text(
                confirmText,
                style: TextStyle(color: AppColors.whiteText),
              ),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }
}
