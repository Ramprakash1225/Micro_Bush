import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';

class SecurityUtils {
  // Sanitize user input to prevent injection attacks
  static String sanitizeInput(String input) {
    if (input.isEmpty) return input;
    
    // Remove potentially dangerous characters
    return input
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&#x27;')
        .replaceAll('/', '&#x2F;')
        .trim();
  }

  // Validate PO number format (alphanumeric and hyphens only)
  static bool isValidPONumber(String poNumber) {
    final regex = RegExp(r'^[A-Za-z0-9\-]+$');
    return regex.hasMatch(poNumber) && poNumber.length >= 3 && poNumber.length <= 50;
  }

  // Validate part number format - allows all characters
  static bool isValidPartNumber(String partNumber) {
    // Only check length, allow all characters
    return partNumber.isNotEmpty && partNumber.length <= 100;
  }

  // Generate secure random ID
  static String generateSecureId() {
    final random = Random.secure();
    final bytes = List<int>.generate(16, (i) => random.nextInt(256));
    return base64Url.encode(bytes).replaceAll('=', '');
  }

  // Hash sensitive data (one-way)
  static String hashData(String data) {
    final bytes = utf8.encode(data);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  // Validate date range (delivery date should be after PO date)
  static bool isValidDateRange(DateTime poDate, DateTime deliveryDate) {
    return deliveryDate.isAfter(poDate) || deliveryDate.isAtSameMomentAs(poDate);
  }

  // Validate quantity ranges
  static bool isValidQuantity(int quantity) {
    return quantity > 0 && quantity <= 1000000; // Reasonable max limit
  }

  // Check if production quantity is valid (must be greater than PO quantity)
  static bool isValidProductionQuantity(int productionQty, int poQty) {
    return productionQty > 0 && productionQty > poQty;
  }

  // Encrypt sensitive data (simple base64 for demo - use proper encryption in production)
  static String encryptData(String data) {
    final bytes = utf8.encode(data);
    return base64Encode(bytes);
  }

  // Decrypt sensitive data
  static String decryptData(String encryptedData) {
    try {
      final bytes = base64Decode(encryptedData);
      return utf8.decode(bytes);
    } catch (e) {
      return '';
    }
  }

  // Validate file path to prevent directory traversal
  static bool isValidFilePath(String path) {
    return !path.contains('..') && 
           !path.contains('~') && 
           !path.startsWith('/') &&
           RegExp(r'^[a-zA-Z0-9_\-./]+$').hasMatch(path);
  }
}
