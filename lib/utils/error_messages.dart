import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class ErrorMessages {
  static String getErrorMessage(BuildContext context, dynamic error) {
    final l10n = AppLocalizations.of(context)!;
    
    if (error == null) {
      return l10n.genericError;
    }

    final errorString = error.toString().toLowerCase();

    // Network errors
    if (errorString.contains('network') ||
        errorString.contains('connection') ||
        errorString.contains('timeout') ||
        errorString.contains('socket')) {
      return l10n.networkError;
    }

    // Permission errors
    if (errorString.contains('permission') ||
        errorString.contains('unauthorized') ||
        errorString.contains('forbidden')) {
      return l10n.permissionError;
    }

    // Validation errors
    if (errorString.contains('validation') ||
        errorString.contains('invalid') ||
        errorString.contains('required')) {
      return l10n.validationError;
    }

    // Storage errors
    if (errorString.contains('storage') ||
        errorString.contains('disk') ||
        errorString.contains('space') ||
        errorString.contains('write')) {
      return l10n.storageError;
    }

    // Not found errors
    if (errorString.contains('not found') ||
        errorString.contains('404')) {
      return l10n.notFoundError;
    }

    // Default generic error
    return l10n.genericError;
  }

  static void showErrorSnackBar(BuildContext context, dynamic error) {
    final message = getErrorMessage(context, error);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  static void showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green.shade700,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 5),
      ),
    );
  }

  static void showInfoSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.blue.shade700,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 5),
      ),
    );
  }
}
