import 'package:flutter/material.dart';

// ============================================================================
// SNACKBAR UTILITIES
// ============================================================================

class SnackBarUtils {
  // Common text style for snackbars
  static const TextStyle _snackBarTextStyle = TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w500,
  );
  
  // Show loading snackbar
  static void showLoading(BuildContext context, {String message = 'Loading...'}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            const SizedBox(width: 16),
            Text(message, style: _snackBarTextStyle),
          ],
        ),
        backgroundColor: Colors.blue,
        duration: const Duration(seconds: 30),
      ),
    );
  }
  
  // Show success snackbar
  static void showSuccess(
    BuildContext context, 
    String message, {
    Color? backgroundColor,
    Duration? duration,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: _snackBarTextStyle),
        backgroundColor: backgroundColor ?? const Color(0xFFE5A122), // AppColors.orangeColor
        duration: duration ?? const Duration(seconds: 3),
      ),
    );
  }
  
  // Show error snackbar
  static void showError(
    BuildContext context, 
    String message, {
    Duration? duration,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: _snackBarTextStyle),
        backgroundColor: Colors.red,
        duration: duration ?? const Duration(seconds: 5),
      ),
    );
  }
  
  // Hide current snackbar
  static void hide(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }
  
  // Show custom snackbar
  static void showCustom(
    BuildContext context,
    Widget content, {
    Color? backgroundColor,
    Duration? duration,
    SnackBarAction? action,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: content,
        backgroundColor: backgroundColor,
        duration: duration ?? const Duration(seconds: 3),
        action: action,
      ),
    );
  }
}
